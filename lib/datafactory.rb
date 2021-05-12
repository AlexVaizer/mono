module DataFactory
	MOCK_DATA_FOR = ['local']
	DEFAULT_ENV = 'local'
	API_URL = 'https://api.monobank.ua'
	TOKEN = ENV['MONO_TOKEN']
	CLIENT_INFO_PATH = '/personal/client-info'
	STATEMENTS_PATH = '/personal/statement'
	CURRENCIES = {
		'840'			=> 'USD',
		'978'			=> 'EUR',
		'980'			=> 'UAH',
	}
	
	MOCK_DATA = {
		'client-info' 	=> {
			"clientId"=>"4xhSmt92RD", 
			"name"=>"Вайзер Олександр", 
			"webHookUrl"=>"", 
			"permissions"=>"psf", 
			"accounts"=>[
				{"id"=>"lu_DfA927YqdOUyQyiwIwA", "currencyCode"=>840, "cashbackType"=>"UAH", "balance"=>1200.0, "creditLimit"=>0, "maskedPan"=>["537541*0987"], "type"=>"BLACK", "iban"=>"UA983220010000026204304774520"}, 
				{"id"=>"Wru4sMWBrWfsCGpwg_2OJg", "currencyCode"=>978, "cashbackType"=>"UAH", "balance"=>12000, "creditLimit"=>0, "maskedPan"=>["537541*4567"], "type"=>"BLACK", "iban"=>"UA693220010000026203301609457"}, 
				{"id"=>"vwM0597-8y5pyZX-RjmpZQ", "currencyCode"=>980, "cashbackType"=>"UAH", "balance"=>1588, "creditLimit"=>0, "maskedPan"=>["537541*9875"], "type"=>"WHITE", "iban"=>"UA173220010000026206300063546"}, 
				{"id"=>"RXgPPTrGMLQu_iXuGRXJbg", "currencyCode"=>980, "cashbackType"=>"", "balance"=>12040, "creditLimit"=>0, "maskedPan"=>["FOP"], "type"=>"FOP", "iban"=>"UA173220010000026206300063546"}
			]
		},
		'statements'	=> [
			{"id"=>"fQ35XN5yrDI0wFys", "time"=>1612212722, "description"=>"Patreon", "mcc"=>5815, "amount"=>-14080, "operationAmount"=>-500, "currencyCode"=>840, "commissionRate"=>0, "cashbackAmount"=>0, "balance"=>1409232, "hold"=>false, "receiptId"=>"K737-HMXC-H45X-XA6K"}, 
			{"id"=>"43zcG2xWtQ-OE3Or", "time"=>1612188144, "description"=>"Від: Антон К.", "mcc"=>4829, "amount"=>12400, "operationAmount"=>12400, "currencyCode"=>980, "commissionRate"=>0, "cashbackAmount"=>0, "balance"=>1423312, "hold"=>true}, 
			{"id"=>"Gzl-xSPVTvsj-Lf5", "time"=>1612187087, "description"=>"Велика Кишеня", "mcc"=>5411, "amount"=>-12400, "operationAmount"=>-12400, "currencyCode"=>980, "commissionRate"=>0, "cashbackAmount"=>0, "balance"=>1410912, "hold"=>false, "receiptId"=>"HE3P-T762-EE2K-92EB"}, 
			{"id"=>"ZEcXBmHXn6GzoqPN", "time"=>1612143372, "description"=>"Відсотки за сiчень", "mcc"=>4829, "amount"=>5010, "operationAmount"=>5010, "currencyCode"=>980, "commissionRate"=>0, "cashbackAmount"=>0, "balance"=>1423312, "hold"=>true}
		],	
	}

	def DataFactory.send_request(url)
		https = Net::HTTP.new(url.host, url.port)
		https.use_ssl = true
		request = Net::HTTP::Get.new(url)
		request["X-Token"] = DataFactory::TOKEN
		response = https.request(request)
		if response.code == '200'
				client_info = JSON.parse(response.read_body)
				raise StandardError.new("empty response!") if client_info.empty?
		else 
				error = JSON.parse(response.read_body)
				raise StandardError.new("Respose from API: #{response.code} - #{error}")
		end

		return client_info
	end

	def DataFactory.get_statements (obj, env = DEFAULT_ENV, date_start = Time.now.to_i - 30*24*60*60, date_end = Time.now.to_i)
		if MOCK_DATA_FOR.include?(env)
			statements = client_info = Marshal.load(Marshal.dump(DataFactory::MOCK_DATA['statements']))
		else
			url = URI(DataFactory::API_URL + DataFactory::STATEMENTS_PATH + "/#{obj.selected_account}/#{date_start}/#{date_end}")
			statements = DataFactory.send_request(url)
		end
		parsed_statements = []
		statements.each do |stat| 
			stat = stat.transform_keys(&:to_sym)
			a = {
				time: Time.at(stat[:time]).strftime("%d.%m.%Y"), 
				amount: stat[:amount].to_f/100, 
				description: stat[:description],
				balance: stat[:balance].to_f/100,
			}
			parsed_statements.push(a)
		end
		obj.statements = parsed_statements
		return true
	end

	def DataFactory.get_client_info(obj,env = DEFAULT_ENV)
		if MOCK_DATA_FOR.include?(env) then
			client_info = Marshal.load(Marshal.dump(DataFactory::MOCK_DATA['client-info']))
		else
			url = URI.join(DataFactory::API_URL, DataFactory::CLIENT_INFO_PATH)
			client_info = DataFactory.send_request(url)
		end
		client_info = client_info.transform_keys(&:to_sym)
		accounts = client_info[:accounts]
		result_accounts = []
		accounts.each do |account|
			account = account.transform_keys(&:to_sym)
			account[:currencyCode] = CURRENCIES[account[:currencyCode].to_s]
			if account[:maskedPan].empty?
				account[:maskedPan] = account[:type].upcase
			else
				account[:maskedPan] = account[:maskedPan].first
			end
			account[:maskedPan] = account[:maskedPan].gsub('******', '*')
			account[:balance] = account[:balance].to_f/100
			account[:type] = account[:type].upcase
			result_accounts.push(account)
		end
		result_accounts.sort_by! { |k| k[:maskedPan]}
		obj.accounts = result_accounts
		client_info.delete(:accounts)
		obj.client_info = client_info
		return true
	end
end
