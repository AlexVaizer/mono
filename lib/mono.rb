module MonobankConnector
	require 'net/http'
	require 'uri'
	require 'json'
	
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
				{"id"=>"vwM0597-8y5pyZX-RjmpZQ", "currencyCode"=>980, "cashbackType"=>"UAH", "balance"=>1588, "creditLimit"=>0, "maskedPan"=>["537541*9875"], "type"=>"BLACK", "iban"=>"UA173220010000026206300063546"}, 
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

	def MonobankConnector.get_client_info(env)
		if env == 'local' then
			client_info = Marshal.load(Marshal.dump(MonobankConnector::MOCK_DATA['client-info']))
		else
			url = URI.join(MonobankConnector::API_URL, MonobankConnector::CLIENT_INFO_PATH)
			https = Net::HTTP.new(url.host, url.port)
			https.use_ssl = true
			request = Net::HTTP::Get.new(url)
			request["X-Token"] = MonobankConnector::TOKEN
			response = https.request(request)
			if response.code == '200'
				client_info = JSON.parse(response.read_body)
			else 
				error = JSON.parse(response.read_body)
				raise StandardError.new("Respose from API: #{response.code} - #{error}")
			end
		end
		client_info['accounts'].each do |account|   
			if account['maskedPan'].empty?
				account['maskedPan'] = account['type'].upcase
			else
				account['maskedPan'] = account['maskedPan'].first
			end
			account['maskedPan'] = account['maskedPan'].gsub('******', '*')
			account['balance'] = account['balance'].to_f/100
			account['type'] = account['type'].upcase
		end
		return client_info
	end

	def MonobankConnector.get_statements(env, account, date_start = (Time.now.to_i - 30*24*60*60), date_end = Time.now.to_i)
		if env == 'local'
			json = MOCK_DATA['statements']
		else
			url = URI(MonobankConnector::API_URL + MonobankConnector::STATEMENTS_PATH + "/#{account}/#{date_start}/#{date_end}")
			https = Net::HTTP.new(url.host, url.port)
			https.use_ssl = true
			request = Net::HTTP::Get.new(url)
			request["X-Token"] = MonobankConnector::TOKEN
			response = https.request(request)
			if response.code == '200'
				json = JSON.parse(response.read_body)
			else 
				error = JSON.parse(response.read_body)
				raise StandardError.new("Respose from API: #{response.code} - #{error}")
			end
		end
		return json
	end
end