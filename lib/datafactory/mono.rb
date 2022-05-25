module DataFactory
	module DataFactory::Mono
		CLIENT_INFO_PATH = '/personal/client-info'
		STATEMENTS_PATH = '/personal/statement'
		API_URL = 'https://api.monobank.ua'
		TOKEN = ENV['MONO_TOKEN']
		MOCK_DATA = {
			client_info: {
					"clientId"=>"4xhSmt92RD", 
					"name"=>"Вайзер Олександр", 
					"webHookUrl"=>"", 
					"permissions"=>"psfj", 
					"accounts"=>[ 
						{"id"=>"Wru4sMWBrWfsCGp", "sendId"=>"7QTY7LSHHU", "currencyCode"=>978, "cashbackType"=>"UAH", "balance"=>0, "creditLimit"=>0, "maskedPan"=>["537541******4467"], "type"=>"black", "iban"=>"UA693220010000026203301174950"}, 
						{"id"=>"RXgPPTrGMLQu_iX", "sendId"=>"", "currencyCode"=>980, "cashbackType"=>"", "balance"=>50, "creditLimit"=>0, "maskedPan"=>[], "type"=>"fop", "iban"=>"UA623220010000026009300295836"}, 
						{"id"=>"vwM0597-8y5pyZX", "sendId"=>"4xhSmt9HHU", "currencyCode"=>980, "cashbackType"=>"UAH", "balance"=>791749, "creditLimit"=>0, "maskedPan"=>["537541******0999"], "type"=>"black", "iban"=>"UA173220010000026206300027406"}, 
						{"id"=>"aDIOepi3OM48BgB", "sendId"=>"7Vx3VA7HHU", "currencyCode"=>980, "cashbackType"=>"UAH", "balance"=>248018, "creditLimit"=>0, "maskedPan"=>["444111******8867"], "type"=>"white", "iban"=>"UA423220010000026200313965478"}, 
						{"id"=>"ZhcEkxQNsgSozL2", "sendId"=>"", "currencyCode"=>980, "cashbackType"=>"UAH", "balance"=>0, "creditLimit"=>0, "maskedPan"=>["444111******9876"], "type"=>"eAid", "iban"=>"UA633220010000026206320009876"}
					], 
					"jars"=>[
						{"id"=>"SlHUM-1qJEA_pzc_EvGIf5CsIGVYUTR", "sendId"=>"jar/5D155Y2tY7", "title"=>"На машину", "description"=>"", "currencyCode"=>978, "balance"=>40000, "goal"=>40000}, 
						{"id"=>"3_eXW5If939bPhonMGclqxbaIr5BDOT", "sendId"=>"jar/3XSbN32TKK", "title"=>"На черный день", "description"=>"", "currencyCode"=>840, "balance"=>40000, "goal"=>400000}
					]
			},
			statements: [
				{"id"=>"fQ35XN5yrDI0wFys", "time"=>1612212722, "description"=>"Patreon", "mcc"=>5815, "amount"=>-14080, "operationAmount"=>-500, "currencyCode"=>840, "commissionRate"=>0, "cashbackAmount"=>0, "balance"=>1409232, "hold"=>false, "receiptId"=>"K737-HMXC-H45X-XA6K"}, 
				{"id"=>"43zcG2xWtQ-OE3Or", "time"=>1612188144, "description"=>"Від: Антон К.", "mcc"=>4829, "amount"=>12400, "operationAmount"=>12400, "currencyCode"=>980, "commissionRate"=>0, "cashbackAmount"=>0, "balance"=>1423312, "hold"=>true}, 
				{"id"=>"Gzl-xSPVTvsj-Lf5", "time"=>1612187087, "description"=>"Велика Кишеня", "mcc"=>5411, "amount"=>-12400, "operationAmount"=>-12400, "currencyCode"=>980, "commissionRate"=>0, "cashbackAmount"=>0, "balance"=>1410912, "hold"=>false, "receiptId"=>"HE3P-T762-EE2K-92EB"}, 
				{"id"=>"ZEcXBmHXn6GzoqPN", "time"=>1612143372, "description"=>"Відсотки за сiчень", "mcc"=>4829, "amount"=>5010, "operationAmount"=>5010, "currencyCode"=>980, "commissionRate"=>0, "cashbackAmount"=>0, "balance"=>1423312, "hold"=>true}
			],
		}


		
		def self.get_client_info()
			if DataFactory::MOCK_DATA_FOR.include?(ENVIRONMENT) then
				client_info = Marshal.load(Marshal.dump(DataFactory::Mono::MOCK_DATA[:client_info]))
			else
				url = URI.join(DataFactory::Mono::API_URL, DataFactory::Mono::CLIENT_INFO_PATH).to_s
				client_info = DataFactory.send_request(url, DataFactory::Mono::TOKEN)
			end
			return client_info
		end
		
		def self.parse_accounts(accounts)
			result_accounts = []
			accounts.each do |account|
				account = account.transform_keys(&:to_sym)
				if account[:maskedPan].empty?
					maskedPan = account[:type].upcase
				else
					maskedPan = account[:maskedPan].first
				end
				acc_res = {
					id: account[:id],
					balance: account[:balance].to_f/100,
					balanceUsd: 0,
					currencyCode: DataFactory::CURRENCIES[account[:currencyCode].to_s],
					type: account[:type].upcase,
					maskedPanFull: maskedPan,
					maskedPan: maskedPan.gsub('******', '*'),
					ethUsdRate: 0
				}
				result_accounts.push(acc_res)
			end
			result_accounts.sort_by! { |k| k[:maskedPan]}
			return result_accounts
		end
		
		def self.parse_jars(jars)
			result = []
			jars.each do |jar|
				jar = jar.transform_keys(&:to_sym)
				result_jar = {
					id: jar[:id],
					sendId: jar[:sendId],
					title: jar[:title],
					description: jar[:description],
					currencyCode: CURRENCIES[jar[:currencyCode].to_s],
					balance: jar[:balance].to_f/100,
					goal: jar[:goal].to_f/100
				}
				result.push(result_jar)
			end
			return result
		end

		def self.return_client_info()
			client_info = self.get_client_info()
			client_info = client_info.transform_keys(&:to_sym)
			result_accounts = self.parse_accounts(client_info[:accounts])
			result_jars = self.parse_jars(client_info[:jars])
			result_info = {
				clientId: client_info[:clientId], 
				name: client_info[:name], 
				webHookUrl: client_info[:webHookUrl] , 
				permissions: client_info[:permissions]
			}
			result_info[:accounts] = result_accounts
			result_info[:jars] = result_jars
			return result_info
		end

		def self.get_statements(selected_account, date_start = Time.now.to_i - 30*24*60*60, date_end = Time.now.to_i)
			if DataFactory::MOCK_DATA_FOR.include?(ENVIRONMENT) then
				statements = Marshal.load(Marshal.dump(DataFactory::Mono::MOCK_DATA[:statements]))
			else
				url = URI.join(DataFactory::Mono::API_URL, "#{DataFactory::Mono::STATEMENTS_PATH}/#{selected_account}/#{date_start}/#{date_end}").to_s
				statements = DataFactory.send_request(url, DataFactory::Mono::TOKEN)
			end
			return statements
		end

		def self.parse_statements(array)
			parsed_statements = []
			array.each do |stat| 
				stat = stat.transform_keys(&:to_sym)
				a = {
					time: Time.at(stat[:time]).strftime(DataFactory::TIME_FORMAT), 
					amount: stat[:amount].to_f/100, 
					description: stat[:description],
					balance: stat[:balance].to_f/100,
				}
				parsed_statements.push(a)
			end
			return parsed_statements
		end
		
		def self.return_statements(selected_account)
			statements = self.get_statements(selected_account)
			parsed_statements = self.parse_statements(statements)
			return parsed_statements
		end
	end
end