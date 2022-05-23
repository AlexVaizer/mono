module DataFactory
	require 'net/http'
	require 'uri'
	require 'json'
	
	MOCK_DATA_FOR = [:development]
	DEFAULT_ENV = :development
	TIME_FORMAT = "%d.%m.%Y %H:%M"
	CURRENCIES = {
		'840'			=> 'USD',
		'978'			=> 'EUR',
		'980'			=> 'UAH',
		'9999'			=> 'ETH',
	}
	ENVIRONMENT = ENV['MONO_ENV'].to_sym || :development

	
	def DataFactory.remap_by_model(hash_source, model = [])
		hash_dst = {}
		model.each do |field|
			hash_dst[field] = hash_source[field]
		end
		return hash_dst
	end

	def DataFactory.send_request(url, mono_token = '', params = [], eth_token = '')
		if url.downcase.include?('etherscan')
			raise ArgumentError.new("Add params Hash and ETH token") if params.empty? || eth_token.empty?
			path = "?"
			params.each do |k,v| 
				path = path + "#{k}=#{v}&"
			end
			path = "#{path}apikey=#{eth_token}"
		elsif url.downcase.include?('monobank')
			raise ArgumentError.new("add Monobank API token to request") if mono_token.empty?
		else 
			raise ArgumentError.new("Unknown URL: #{url}. Should contain 'etherscan' or 'monobank'")
		end
		url = "#{url}#{path}"
		uri = URI(url)
		https = Net::HTTP.new(uri.host, uri.port)
		https.use_ssl = true
		request = Net::HTTP::Get.new(uri)
		request["X-Token"] = mono_token if !mono_token.empty?
		response = https.request(request)
		if url.downcase.include?('etherscan')
			if JSON.parse(response.read_body)['status'] == "1" then 
				client_info = JSON.parse(response.read_body)['result']
				client_info = [] if client_info.empty?
			else
				error = client_info
				raise StandardError.new("Respose from API: #{uri.host} - #{response.code} - #{error}.\nPlease try again later")
			end	
		else
			if response.code == '200' then 
				client_info = JSON.parse(response.read_body)
			else
				error = JSON.parse(response.read_body)
				raise StandardError.new("Respose from API: #{uri.host} - #{response.code} - #{error}.\nPlease try again later")
			end
		end
		return client_info
	end

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
		CLIENT_INFO_MODEL = [:clientId, :name, :webHookUrl, :permissions]
		ACCOUNT_MODEL = [:id, :balance, :balanceUsd, :currencyCode, :type, :maskedPan, :maskedPanFull, :ethUsdRate]
		JAR_MODEL = [:id, :sendId, :title, :description, :currencyCode, :balance, :goal]
		STATEMENTS_MODEL = [:time, :amount, :description, :balance]
		
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
				account[:currencyCode] = CURRENCIES[account[:currencyCode].to_s]
				if account[:maskedPan].empty?
					account[:maskedPan] = account[:type].upcase
				else
					account[:maskedPan] = account[:maskedPan].first
				end
				account[:maskedPan] = account[:maskedPan].gsub('******', '*')
				account[:balance] = account[:balance].to_f/100
				account[:type] = account[:type].upcase
				result = DataFactory.remap_by_model(account, ACCOUNT_MODEL)
				result_accounts.push(result)
			end
			result_accounts.sort_by! { |k| k[:maskedPan]}
			return result_accounts
		end
		
		def self.parse_jars(jars)
			result = []
			jars.each do |jar|
				jar = jar.transform_keys(&:to_sym)
				result_jar = DataFactory.remap_by_model(jar, JAR_MODEL)
				result_jar[:currencyCode] = CURRENCIES[jar[:currencyCode].to_s]
				result_jar[:balance] = result_jar[:balance].to_f/100
				result_jar[:goal] = result_jar[:goal].to_f/100
				result.push(result_jar)
			end
			return result
		end

		def self.return_client_info()
			client_info = self.get_client_info()
			client_info = client_info.transform_keys(&:to_sym)
			result_accounts = self.parse_accounts(client_info[:accounts])
			result_jars = self.parse_jars(client_info[:jars])
			result_info = DataFactory.remap_by_model(client_info, CLIENT_INFO_MODEL)
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

		
		def self.return_statements(selected_account)
			statements = self.get_statements(selected_account)
			parsed_statements = []
			statements.each do |stat| 
				stat = stat.transform_keys(&:to_sym)
				a = {
					time: Time.at(stat[:time]).strftime(DataFactory::TIME_FORMAT), 
					amount: stat[:amount].to_f/100, 
					description: stat[:description],
					balance: stat[:balance].to_f/100,
				}
				b = DataFactory.remap_by_model(a, STATEMENTS_MODEL)
				parsed_statements.push(b)
			end
			return parsed_statements
		end
	end

	module DataFactory::ETH
		require 'bigdecimal'
		ETH_ADDRESSES = ENV["ETH_ADDRESSES"]
		ETH_TOKEN = ENV['ETH_TOKEN']
		ETH_URL = 'https://api.etherscan.io/api/'
		TX_LIST_PARAMS = {module: 'account',action: 'txlist',tag: 'latest',startblock: 0,endblock: 99999999,sort: 'desc'}
		LAST_PRICE_PARAMS = {module: 'stats',action: 'ethprice'}
		BALANCE_PARAMS = {module: 'account',action: 'balancemulti',tag: 'latest',address: ETH_ADDRESSES}
		ROUND_AMOUNTS_TO = 6
		MOCK_DATA = {
			last_price: {"ethbtc"=>"0.06809", "ethbtc_timestamp"=>"1643494559", "ethusd"=>"2603.9", "ethusd_timestamp"=>"1643494552"},
			balance: [{"account"=>"0xA07fDc4A73a067078601a00C36dc6627FA0A80B8", "balance"=>"1881190803163104475"},{"account"=>"0xA07fDc4A73a067078601a00C36dc6627FA0A80B9", "balance"=>"1881190803163104475"}],
			tx_list: [{"blockNumber"=>"11877350", "timeStamp"=>"1613604825", "hash"=>"0x4e21ecb8b21c031b34fde7a33b88451fe896412883502411ef6a883f087c4a96", "nonce"=>"3069", "blockHash"=>"0x4593f9b7c799a674b1c2cfa67a39f5b83a6a6dcf95e9c3380225e3aaf9abf126", "transactionIndex"=>"143", "from"=>"0x77ab999d1e9f152156b4411e1f3e2a42dab8cd6d", "to"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "value"=>"1013977000000000000", "gas"=>"21000", "gasPrice"=>"146000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"11135499", "gasUsed"=>"21000", "confirmations"=>"2225946"},{"blockNumber"=>"11879338", "timeStamp"=>"1613631560", "hash"=>"0xca5a509c2ccec51ab010344ae7031a75fb65e8952692a4ee99cd16d0fa21b962", "nonce"=>"0", "blockHash"=>"0xffccc93befe0ea32cba343a38935d3c3aa58d17acd5b9776d0560ba0666c9ade", "transactionIndex"=>"169", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0xdac17f958d2ee523a2206206994597c13d831ec7", "value"=>"0", "gas"=>"50926", "gasPrice"=>"134000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x095ea7b30000000000000000000000007a250d5630b4cf539739df2c5dacb4c659f2488dffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff", "contractAddress"=>"", "cumulativeGasUsed"=>"10677171", "gasUsed"=>"46297", "confirmations"=>"2223958"},{"blockNumber"=>"11879365", "timeStamp"=>"1613631854", "hash"=>"0x061225f0eb08bf2b123beb646dd60911ddb1995cbb77de4ac651ae4705fa53d2", "nonce"=>"1", "blockHash"=>"0x7b505b8197c16af195554ffb40acdec8e07bcfbed4ae72c1d59fd204ec793535", "transactionIndex"=>"64", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0x7a250d5630b4cf539739df2c5dacb4c659f2488d", "value"=>"736897954410460079", "gas"=>"185689", "gasPrice"=>"126000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0xf305d719000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec70000000000000000000000000000000000000000000000000000000053724e000000000000000000000000000000000000000000000000000000000053077e400000000000000000000000000000000000000000000000000a2ce5c2e84e4462000000000000000000000000a07fdc4a73a067078601a00c36dc6627fa0a80b800000000000000000000000000000000000000000000000000000000602e1581", "contractAddress"=>"", "cumulativeGasUsed"=>"4663717", "gasUsed"=>"147825", "confirmations"=>"2223931"},{"blockNumber"=>"11887848", "timeStamp"=>"1613744366", "hash"=>"0xaaf9ba01b9537fbc858eabe5b415cb6205ff3bc4d802d316de26d5d05b043553", "nonce"=>"2", "blockHash"=>"0x4f726f1774e9a145a3b0d83a1c4af3ddfecd479b97bee80d6d3bb95f5b038e37", "transactionIndex"=>"100", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0x38d3d9abbdba8305ebb8b72996efe55bf785aed0", "value"=>"0", "gas"=>"94889", "gasPrice"=>"193000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x095ea7b30000000000000000000000007a250d5630b4cf539739df2c5dacb4c659f2488dffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff", "contractAddress"=>"", "cumulativeGasUsed"=>"5174480", "gasUsed"=>"84118", "confirmations"=>"2215448"},{"blockNumber"=>"11887870", "timeStamp"=>"1613744723", "hash"=>"0x5f62728b86fcdb8a3a00871db10a8f47fac7cdf926cc30473fe59bd07795b29c", "nonce"=>"3", "blockHash"=>"0x7c92fe3b1083d4b3c090c42b173820f4f5a3cc1ff30d0151b25b7aed580d98b8", "transactionIndex"=>"102", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0x7a250d5630b4cf539739df2c5dacb4c659f2488d", "value"=>"0", "gas"=>"204332", "gasPrice"=>"192000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x38ed1739000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000039736f5d00000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000a07fdc4a73a067078601a00c36dc6627fa0a80b800000000000000000000000000000000000000000000000000000000602fcd9e000000000000000000000000000000000000000000000000000000000000000200000000000000000000000038d3d9abbdba8305ebb8b72996efe55bf785aed0000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48", "contractAddress"=>"", "cumulativeGasUsed"=>"6940006", "gasUsed"=>"164388", "confirmations"=>"2215426"},{"blockNumber"=>"11964483", "timeStamp"=>"1614763968", "hash"=>"0x26388ee23f6ab6a0696c946a3691fb01e7b8a55e83829bf9279c02634662b116", "nonce"=>"4951", "blockHash"=>"0x710621fa9bcf03e7b5f85b038af50d95fe29c68a557876a5a9be03ed4831d0fb", "transactionIndex"=>"243", "from"=>"0x77ab999d1e9f152156b4411e1f3e2a42dab8cd6d", "to"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "value"=>"320842030000000000", "gas"=>"21000", "gasPrice"=>"101000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"7529927", "gasUsed"=>"21000", "confirmations"=>"2138813"},{"blockNumber"=>"11964633", "timeStamp"=>"1614765941", "hash"=>"0x0407b069129ff4d7cc902807cdec11cd037c52e9c69cc7e0d83e366d619719d5", "nonce"=>"4", "blockHash"=>"0x932b7c45fea3073159c3ae62b66b8fcd1208d751b574c1d95bc2d1f2afa1e102", "transactionIndex"=>"54", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0x4592f3193481b073db2cd6f7333c346557be27af", "value"=>"52200000000000000", "gas"=>"21000", "gasPrice"=>"110000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"4041888", "gasUsed"=>"21000", "confirmations"=>"2138663"},{"blockNumber"=>"12042282", "timeStamp"=>"1615799344", "hash"=>"0xbf9032b774abfb1ae2c04ea2cada8080bae3c4efe66a2ff821b3b9de669d811b", "nonce"=>"5", "blockHash"=>"0x9cbb6aa066059fa28d044de614e83b6c48cca4e228c3959dda1589e2b6a327cf", "transactionIndex"=>"164", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48", "value"=>"0", "gas"=>"86790", "gasPrice"=>"144000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0xa9059cbb0000000000000000000000001b2e540a60077a70140a51682e059b5140b8148e00000000000000000000000000000000000000000000000000000000a8c15cea", "contractAddress"=>"", "cumulativeGasUsed"=>"9858827", "gasUsed"=>"42381", "confirmations"=>"2061014"},{"blockNumber"=>"12101360", "timeStamp"=>"1616586389", "hash"=>"0x7d8de08507740dd57fe27b1a23506a4ed2fa871d5c0965d3def4bf80f71a7958", "nonce"=>"6", "blockHash"=>"0x980048f0e0592a4833c4bc41d3c911ef9fb6f0cdbe5376ec9ce6ef4747d663db", "transactionIndex"=>"207", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0x4592f3193481b073db2cd6f7333c346557be27af", "value"=>"75800000000000000", "gas"=>"21000", "gasPrice"=>"126000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"12470349", "gasUsed"=>"21000", "confirmations"=>"2001936"},{"blockNumber"=>"12265220", "timeStamp"=>"1618764304", "hash"=>"0xaa2bf928f84f61458b31001682f1192ecd172866548e6913d885f7f769dd5b2e", "nonce"=>"7", "blockHash"=>"0xb5254c9a95c229be009195e7e2158343d97ced471046b06fcee27587b08f1a0d", "transactionIndex"=>"58", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48", "value"=>"0", "gas"=>"60496", "gasPrice"=>"128000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x095ea7b3000000000000000000000000881d40237659c251811cec9c364ef91dc08d300c0000000000000000000000000000000000000000004a817c7ffffffdabf41c00", "contractAddress"=>"", "cumulativeGasUsed"=>"11766214", "gasUsed"=>"60047", "confirmations"=>"1838076"},{"blockNumber"=>"12265221", "timeStamp"=>"1618764306", "hash"=>"0x1bfb3501e77ce01c90e2f1706bf7fb701e2a496d66363a60b6aceaf8765a24b4", "nonce"=>"8", "blockHash"=>"0xd1ad1ee5302bb09a47e6c3d3405600b53fd13e8d116e9187d01b0b95879e709d", "transactionIndex"=>"129", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0x881d40237659c251811cec9c364ef91dc08d300c", "value"=>"0", "gas"=>"281351", "gasPrice"=>"128000000000", "isError"=>"1", "txreceipt_status"=>"0", "input"=>"0x5f5755290000000000000000000000000000000000000000000000000000000000000080000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb480000000000000000000000000000000000000000000000000000000032a9f88000000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000000000000000000000000000000000000000000d616972737761704c696768743200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018000000000000000000000000000000000000000000000000000000000607c615500000000000000000000000000000000000000000000000000000000607c620e000000000000000000000000a5d07e978398eb1715056d3ca5cb31035c02fdad000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec700000000000000000000000000000000000000000000000000000000325fa8ab000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb480000000000000000000000000000000000000000000000000000000032a9f880000000000000000000000000000000000000000000000000000000000000001bdf119f5cbd98f2b39c237c187a2f83bf954ab1d174b302fafaa6e659248d002364251aa07506f75c6fddf3cafb043f43c56fc8d6c70b5e68ed895f573a85a0da00000000000000000000000000000000000000000000000000000000000000000000000000000000000000007296333e1615721f4bd9df1a3070537484a50cf86c", "contractAddress"=>"", "cumulativeGasUsed"=>"7253368", "gasUsed"=>"112079", "confirmations"=>"1838075"},{"blockNumber"=>"12317316", "timeStamp"=>"1619458473", "hash"=>"0x737a448aafb4333094a3de5ac1ded544596cb0c8b1dfaca39d575f526ebd737f", "nonce"=>"10595", "blockHash"=>"0xe3653ec27cf53fd602a65ea1355ebddf7b2ef63ba13c3cb86581b616d15d8690", "transactionIndex"=>"195", "from"=>"0x77ab999d1e9f152156b4411e1f3e2a42dab8cd6d", "to"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "value"=>"73243900000000000", "gas"=>"21000", "gasPrice"=>"83000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"13351150", "gasUsed"=>"21000", "confirmations"=>"1785980"},{"blockNumber"=>"12321229", "timeStamp"=>"1619511216", "hash"=>"0xd528a2395a0726c9a9f3095966c1d422f6e811432f97473d57195664c1f826ab", "nonce"=>"9", "blockHash"=>"0x211873b0c5a970f44ff631ddeeba138e20a44a67d8bdd5acffd3bdc89e6b9efe", "transactionIndex"=>"304", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0x4592f3193481b073db2cd6f7333c346557be27af", "value"=>"62000000000000000", "gas"=>"21000", "gasPrice"=>"41000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"9966307", "gasUsed"=>"21000", "confirmations"=>"1782067"},{"blockNumber"=>"12331452", "timeStamp"=>"1619646659", "hash"=>"0x606290d20f2f651979dd96cf68bb8ae3c50f953b204c97068856b81f679fd3a2", "nonce"=>"10", "blockHash"=>"0x6922a19f277a71b2d69fc5ac770cce6fa8d0d73c760f1c94067c720b1883733a", "transactionIndex"=>"2", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "value"=>"0", "gas"=>"66836", "gasPrice"=>"112500000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"63000", "gasUsed"=>"21000", "confirmations"=>"1771844"},{"blockNumber"=>"12450122", "timeStamp"=>"1621230394", "hash"=>"0x4c8c215d4f472f05d78458cda3b590b6689a49e03c4f568d76f0854ce1a41658", "nonce"=>"11", "blockHash"=>"0xeccbf79348ade13948023b2c0c24d43fd398e24443d7a5a4292a31a8e5869115", "transactionIndex"=>"184", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0x7a250d5630b4cf539739df2c5dacb4c659f2488d", "value"=>"0", "gas"=>"317488", "gasPrice"=>"63000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0xded9382a000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7000000000000000000000000000000000000000000000000000014bbd175d50600000000000000000000000000000000000000000000000000000000761f3766000000000000000000000000000000000000000000000000086a48b0e5263929000000000000000000000000a07fdc4a73a067078601a00c36dc6627fa0a80b80000000000000000000000000000000000000000000000000000000060a20bfd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001c1b6185ce3cbf32c45006cb74e324742eb1f461c64f3bdae531ddfb4315e9b28632f5c085bedc6b17b5bda00ceb4bb23cae6b501431ce68db116624b5b90832b8", "contractAddress"=>"", "cumulativeGasUsed"=>"14495429", "gasUsed"=>"165108", "confirmations"=>"1653174"},{"blockNumber"=>"12450189", "timeStamp"=>"1621231469", "hash"=>"0xe096af71e80e8b312952cb4579775e9e12c5b6fd384e8d458523d2633c930fa5", "nonce"=>"12", "blockHash"=>"0xafa6b0d2d32be90250d14608ed80ce08b1846a8bf78e55aed2b84cabf0761f49", "transactionIndex"=>"110", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "value"=>"0", "gas"=>"58676", "gasPrice"=>"96000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"9593167", "gasUsed"=>"21000", "confirmations"=>"1653107"},{"blockNumber"=>"12450231", "timeStamp"=>"1621231962", "hash"=>"0x8df1c4e984bc2d51aee9ad300bd28323ad200e1af76cddffa3bb0740d1d95d51", "nonce"=>"13", "blockHash"=>"0x5e8b2878d436e3e8c42fee4618fe10bb738d8b7f759741a01864c5082a1d37d3", "transactionIndex"=>"54", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0xdac17f958d2ee523a2206206994597c13d831ec7", "value"=>"0", "gas"=>"58676", "gasPrice"=>"95000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x095ea7b3000000000000000000000000e592427a0aece92de3edee1f18e0157c05861564ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff", "contractAddress"=>"", "cumulativeGasUsed"=>"2770915", "gasUsed"=>"48897", "confirmations"=>"1653065"},{"blockNumber"=>"12450235", "timeStamp"=>"1621231999", "hash"=>"0xeca41489132e4598c270cae34f6a3c3722a54ac7c6233e4460f813ce379acca0", "nonce"=>"14", "blockHash"=>"0xdced3a3249119919d1012611d0e4732861cd5d4a04fc8ff537559be619c7b38b", "transactionIndex"=>"79", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0xe592427a0aece92de3edee1f18e0157c05861564", "value"=>"0", "gas"=>"156021", "gasPrice"=>"97000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x414bf389000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb4800000000000000000000000000000000000000000000000000000000000001f4000000000000000000000000a07fdc4a73a067078601a00c36dc6627fa0a80b80000000000000000000000000000000000000000000000000000000060a20e0a000000000000000000000000000000000000000000000000000000007c5d65d9000000000000000000000000000000000000000000000000000000007bbb19850000000000000000000000000000000000000000000000000000000000000000", "contractAddress"=>"", "cumulativeGasUsed"=>"4148902", "gasUsed"=>"111763", "confirmations"=>"1653061"},{"blockNumber"=>"12467123", "timeStamp"=>"1621458170", "hash"=>"0xd55563bacabdbc34d5d0f68d7d3610271d4c004f15674715045d198f2d756687", "nonce"=>"15", "blockHash"=>"0x46fd0643c20896fba2d6b77215752b0ee59b7b1ef34adb423f9d14e378393e37", "transactionIndex"=>"100", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0xe592427a0aece92de3edee1f18e0157c05861564", "value"=>"0", "gas"=>"276763", "gasPrice"=>"140000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0xac9650d8000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000016000000000000000000000000000000000000000000000000000000000000002a000000000000000000000000000000000000000000000000000000000000000c4f3995c67000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb480000000000000000000000000000000000000000000000000000000099724a570000000000000000000000000000000000000000000000000000000060a5857a000000000000000000000000000000000000000000000000000000000000001b100413ee81a584f199fc377d4ea3ac54054e489cbf0e40380e0ed248737fae2b1b6209c014b7ef3f8827697891b5e7e9b86c3f18a1a8f88ed242b39efc842b4a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000104db3e2198000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc20000000000000000000000000000000000000000000000000000000000000bb800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060a580ca0000000000000000000000000000000000000000000000000de0b6b3a76400000000000000000000000000000000000000000000000000000000000099724a57000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004449404b7c0000000000000000000000000000000000000000000000000de0b6b3a7640000000000000000000000000000a07fdc4a73a067078601a00c36dc6627fa0a80b800000000000000000000000000000000000000000000000000000000", "contractAddress"=>"", "cumulativeGasUsed"=>"8384757", "gasUsed"=>"198104", "confirmations"=>"1636173"},{"blockNumber"=>"12482763", "timeStamp"=>"1621668411", "hash"=>"0x84a8d71f84340c80e1f61318a39e840a83946e594ecfb9ceb627ddb979c51228", "nonce"=>"13210", "blockHash"=>"0xec4547c1335fc373532512b01bea686cec408253f0f3364bebdcbdd7e89c10ed", "transactionIndex"=>"345", "from"=>"0x77ab999d1e9f152156b4411e1f3e2a42dab8cd6d", "to"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "value"=>"85634830000000000", "gas"=>"21000", "gasPrice"=>"60000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"8864279", "gasUsed"=>"21000", "confirmations"=>"1620533"},{"blockNumber"=>"12541357", "timeStamp"=>"1622453292", "hash"=>"0x2a97835201957c2e90ef986acc2f52f1d94c30fe61cc269118c5b0362938eb28", "nonce"=>"16", "blockHash"=>"0xbb9be875497fba7d9800c8d35288c2c5004e6d8be7003b6a8d10034b9620b852", "transactionIndex"=>"177", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0x4592f3193481b073db2cd6f7333c346557be27af", "value"=>"62000000000000000", "gas"=>"21000", "gasPrice"=>"20000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"10042618", "gasUsed"=>"21000", "confirmations"=>"1561939"},{"blockNumber"=>"12704312", "timeStamp"=>"1624638626", "hash"=>"0x1b6d0757c060a84a3189d052f713208eecb992a4e7a95a3a2313868ab5489690", "nonce"=>"17", "blockHash"=>"0x0b367751692c2dd31e598d71302e50c63209aa28c7b3672a6159d9c92f14d147", "transactionIndex"=>"199", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0x4592f3193481b073db2cd6f7333c346557be27af", "value"=>"67800000000000000", "gas"=>"21000", "gasPrice"=>"49000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"12881252", "gasUsed"=>"21000", "confirmations"=>"1398984"},{"blockNumber"=>"12767491", "timeStamp"=>"1625488275", "hash"=>"0x75ca6a69e970df17dbbe99ecece7c960da151c16a372505f2c88d6e9654163be", "nonce"=>"16837", "blockHash"=>"0x80717bfa729b9bd1a37b3986c0afc72a0a198d267f3d32d09967857875bb62d8", "transactionIndex"=>"108", "from"=>"0x77ab999d1e9f152156b4411e1f3e2a42dab8cd6d", "to"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "value"=>"206802170000000000", "gas"=>"21000", "gasPrice"=>"11000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"8375644", "gasUsed"=>"21000", "confirmations"=>"1335805"},{"blockNumber"=>"12793010", "timeStamp"=>"1625831656", "hash"=>"0xec11e92b1948fd9747ec42a9b944eeae8054973af00d9a2c2ae4ed5454ab6155", "nonce"=>"18", "blockHash"=>"0x21d94e382f56ec14b364ffcb02498dbba776c46242bb1cf453951bfb637205ad", "transactionIndex"=>"95", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0x4592f3193481b073db2cd6f7333c346557be27af", "value"=>"39000000000000000", "gas"=>"21000", "gasPrice"=>"24000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"12680749", "gasUsed"=>"21000", "confirmations"=>"1310286"},{"blockNumber"=>"12902001", "timeStamp"=>"1627304987", "hash"=>"0xe0b78c56a1791d9a9b2fee25caa094563ac4661d8f724a5aabcc67d93986159d", "nonce"=>"19", "blockHash"=>"0xea29791afa28edb5ea84ef07467e3f11126dea9c7985909a6425c1c1446f7826", "transactionIndex"=>"130", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0x4592f3193481b073db2cd6f7333c346557be27af", "value"=>"52000000000000000", "gas"=>"21000", "gasPrice"=>"47000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"6533860", "gasUsed"=>"21000", "confirmations"=>"1201295"}],
		}
		ACCOUNT_MODEL = [:id, :balance, :balanceUsd, :currencyCode, :type, :maskedPan, :maskedPanFull, :ethUsdRate]
		STATEMENTS_MODEL = [:time, :amount, :tx_id, :tx_fee]

		def self.get_client_info()
			if MOCK_DATA_FOR.include?(ENVIRONMENT)
				last_price = Marshal.load(Marshal.dump(MOCK_DATA[:last_price]))
				balance = Marshal.load(Marshal.dump(MOCK_DATA[:balance]))
			else
				last_price = DataFactory.send_request(ETH_URL, '', LAST_PRICE_PARAMS, ETH_TOKEN)
				balance = DataFactory.send_request(ETH_URL, '', BALANCE_PARAMS, ETH_TOKEN)
			end
			info = {
				last_price: last_price,
				balances: balance
			}
			return info 
		end

		def self.return_client_info()
			if ! (ETH_ADDRESSES.nil? || ETH_ADDRESSES.empty?) then
				client_info = self.get_client_info()
				accounts = []
				client_info[:balances].each do |account|
					in_float = (BigDecimal(account['balance'])/10**18).to_f
					bal_eth = in_float.round(ROUND_AMOUNTS_TO)
					bal_usd = bal_eth * client_info[:last_price]['ethusd'].to_f
					bal_usd = bal_usd.round(1)
					account = {
						currencyCode: 'ETH',
						type: 'ETH',
						maskedPan: "#{account['account'][0..4]}..#{account['account'][-5..-1]}",
						balance: bal_eth,
						balanceUsd: bal_usd,
						ethUsdRate: client_info[:last_price]['ethusd'].to_f,
						id: account['account'],
						maskedPanFull: account['account']
					}
					result = DataFactory.remap_by_model(account, ACCOUNT_MODEL)
					accounts.push(result)
				end
			else
				accounts = [] 
			end
			return accounts
		end

		def self.get_statements(address)
			if MOCK_DATA_FOR.include?(ENVIRONMENT)
				statements = Marshal.load(Marshal.dump(MOCK_DATA[:tx_list]))
			else
				params = TX_LIST_PARAMS.merge({address: address})
				statements = DataFactory.send_request(ETH_URL, '', params, ETH_TOKEN)
			end
			return statements
		end

		
		def self.return_statements(address)
			statements = self.get_statements(address)
			parsed_statements = []
			statements.each do |stat| 
				fee = ((BigDecimal(stat['gasPrice']) * BigDecimal(stat['gasUsed'])) / 10**18).to_f.round(ROUND_AMOUNTS_TO)
				amount = (BigDecimal(stat['value']) / 10**18).to_f.round(ROUND_AMOUNTS_TO)
				if stat['from'].downcase == address.downcase then 
					symbol =  '-'
				else 
					symbol = '+'
				end
				a = {
					time: Time.at(stat['timeStamp'].to_i).strftime(DataFactory::TIME_FORMAT), 
					amount: symbol + amount.to_s, 
					tx_id: "<a target=_new href='https://etherscan.io/tx/#{stat['hash']}'>#{stat['hash'][0..4]}..#{stat['hash'][-4..-1]}</a>",
					tx_fee: fee,
				}
				b = DataFactory.remap_by_model(a, STATEMENTS_MODEL)
				parsed_statements.push(b)
			end
			return parsed_statements
		end
	end

	module DataFactory::SQLite
		require 'sqlite3'
		DB_PATH = ENV["MONO_DB_PATH"]
		DB_UPD_INTERVAL = 300 #seconds
		
		def self.request(request)
			db = SQLite3::Database.open(DB_PATH)
			db.results_as_hash = true
			re = db.execute(request)
			db.close
			resp = re.map {|str| str.transform_keys(&:to_sym) }
			return resp
		end


		def self.get(table, id, id_field)
			request = "SELECT * FROM #{table} WHERE #{id_field}=\"#{id}\""
			re = self.request(request)
			return re.first
		end
		
		##
		#Creates or updates row in a TABLE by ID_FIELD with DATA
		def self.create(table, id_field, data) 
			acc = self.get(table, data[id_field.to_sym], id_field)
			if ! acc then
				data[:timeUpdated] = Time.now.iso8601
				keys = data.keys.map { |e| e.to_s }.join(',')
				values = " '#{data.values.join('\',\'')}' "
				request = "INSERT INTO #{table} (#{keys.to_s}) VALUES (#{values})"
				re = self.request(request)
				return re = self.get(table, data[id_field.to_sym], id_field)
			else
				acc = self.update(table, id_field, data)
				return acc
			end
		end

		def self.get_all(table)
			request = "SELECT * FROM #{table}"
			re = self.request(request)
			resp = re.map {|str| str.transform_keys(&:to_sym) }
			return resp
		end

		def self.update(table, id_field,  data)
			request = "UPDATE #{table} SET"
			data[:timeUpdated] = Time.now.iso8601
			data.each do |k,v|
				request = "#{request} #{k.to_s}='#{v}',"
			end
			request = "#{request.chop} WHERE #{id_field}=\"#{data[id_field.to_sym]}\""
			re = self.request(request)
			return self.get(table, data[id_field.to_sym], id_field)
		end
	end
end