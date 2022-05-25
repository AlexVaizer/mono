module DataFactory
	require 'net/http'
	require 'uri'
	require 'json'
	
	MOCK_DATA_FOR = [:development]
	TIME_FORMAT = "%d.%m.%Y %H:%M"
	CURRENCIES = {
		'840'			=> 'USD',
		'978'			=> 'EUR',
		'980'			=> 'UAH',
		'9999'			=> 'ETH',
	}
	env = ENV['MONO_ENV'] || 'development'
	ENVIRONMENT = env.to_sym


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
end