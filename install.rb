#!/usr/bin/ruby
require './lib/server_settings.rb'

#GET IP ADDRESS
values = {}
ips = ServerSettings.list_ifconfig_ips
ips.each_with_index do |v,i|
	puts "#{i+1}. [#{v}]"
end
puts "Please enter [1-#{ips.count}] number and hit Enter"
i = gets
i = i.to_i
values['ip'] = ips[i-1]
puts "IP address chosen: #{values['ip'] }"
puts "----------------------------------------------"

# GET PORT
puts "Please enter PORT number and hit Enter"
port_s = gets
values['port'] = port_s.to_i
puts "Port chosen: #{values['port']}"
puts "----------------------------------------------"

# GET MONOBANK TOKEN
puts "Please enter Monobank Auth Token and hit Enter"
values['mono_token'] = gets.chomp
puts "Token chosen: #{values['mono_token']}"
puts "----------------------------------------------"

# GET BASIC AUTH SETTINGS
puts "Please enter Username for Basic Auth"
values['mono_user'] = gets.chomp
puts "Basic Auth Username chosen: #{values['mono_user']}"
puts "----------------------------------------------"

puts "Please enter Password for Basic Auth"
values['mono_pass'] = gets.chomp
puts "Basic Auth Password chosen: #{values['mono_pass']}"
puts "----------------------------------------------"

# Get SSL files path
puts "Please enter Path where your SSL certificates are located"
values['mono_ssl'] = gets.chomp
puts "SSL Path saved: #{values['mono_ssl']}"
puts "----------------------------------------------"

# Get Etherscan TOKEN
puts "Please enter your Etherscan token"
values['eth_token'] = gets.chomp
puts "ETH token saved: #{values['eth_token']}"
puts "----------------------------------------------"

# Get Etherscan TOKEN
puts "Please enter your Ether Address"
values['eth_address'] = gets.chomp
puts "ETH token saved: #{values['eth_address']}"
puts "----------------------------------------------"

env_values_string = "MONO_SERV_IP='#{values['ip']}' MONO_SERV_PORT='#{values['port']}' ETH_TOKEN=#{values['eth_token']} ETH_ADDRESS=#{values['eth_address']} MONO_TOKEN='#{values['mono_token']}' MONO_BASIC_AUTH_USER='#{values['mono_user']}' MONO_BASIC_AUTH_PASS='#{values['mono_pass']}' MONO_SSL_FOLDER='#{values['mono_ssl']}'"
puts "(WORKS ONLY IN UBUNTU) Do you want to set up service [y/n]"
service_setup = gets.chomp
until ['y','n'].include?(service_setup)
	puts "Wrong input, type in 'y' or 'n'"
	service_setup = gets
end
if service_setup == 'y' then
	ServerSettings.setup_service(values)
else
	puts "----------------------------------------------"
	puts "Command to run server manually:\n#{env_values_string} ruby #{ServerSettings::CURRENT_FOLDER}/monobank.rb -e local"
end
