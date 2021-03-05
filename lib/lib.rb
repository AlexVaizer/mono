require 'net/http'
require 'uri'
def get_client_info (token)
	
	url = URI.join($mono_opts['site'], $mono_opts['client-info'])

	https = Net::HTTP.new(url.host, url.port)
	https.use_ssl = true

	request = Net::HTTP::Get.new(url)
	request["X-Token"] = token

	response = https.request(request)
	if response.code == '200'
		return JSON.parse(response.read_body)
	else 
		raise StandardError.new("Respose from API: #{response.code} - #{response.read_body}")
	end
end

def get_account_statements (token, account, date_start = Time.now.to_i - 2592000, date_end = Time.now.to_i)

	url = URI($mono_opts['site'] + $mono_opts['statements'] + "#{account}/#{date_start}/#{date_end}")
	
	https = Net::HTTP.new(url.host, url.port)
	https.use_ssl = true

	request = Net::HTTP::Get.new(url)
	request["X-Token"] = token

	response = https.request(request)
	if response.code == '200'
		return JSON.parse(response.read_body)
	else 
		raise StandardError.new("Respose from API: #{response.code} - #{response.read_body}")
	end
end

def return_errors(short,full,errorlevel)
	if errorlevel == false
		return short
	else
		return short, full
	end
end

def get_server_ip
	if FileTest.exist?("./ip.txt") then
		file = File.open("./ip.txt")
		ip = file.readlines.map(&:chomp)
		file.close
		return ip.first
	else
		puts("IP address was not set up. Please run './install.rb' first")
		exit
	end
end