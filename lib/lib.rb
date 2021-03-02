require './cred.rb'
require 'net/http'
require 'uri'
def get_client_info (token)
	
	url = URI.join($mono_opts['site'], $mono_opts['client-info'])

	https = Net::HTTP.new(url.host, url.port)
	https.use_ssl = true

	request = Net::HTTP::Get.new(url)
	request["X-Token"] = token

	response = https.request(request)
	return response.read_body
end

def get_account_statements (token, account, date_start = Time.now.to_i - 2592000, date_end = Time.now.to_i)

	url = URI($mono_opts['site'] + $mono_opts['statements'] + "#{account}/#{date_start}/#{date_end}")
	
	https = Net::HTTP.new(url.host, url.port)
	https.use_ssl = true

	request = Net::HTTP::Get.new(url)
	request["X-Token"] = token

	response = https.request(request)
	return response.read_body
end
