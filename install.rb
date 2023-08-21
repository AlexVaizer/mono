#!/usr/bin/ruby
require './lib/server_settings.rb'

#GET Domain
values = {}

puts "Please enter DOMAIN and hit Enter"
domain = gets
values['domain'] = domain
puts "Port chosen: #{values['domain']}"
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

# Get Etherscan Address
puts "Please enter your Ether Address(es). Should be separated by comma"
values['eth_address'] = gets.chomp
puts "ETH token saved: #{values['eth_address']}"
puts "----------------------------------------------"

# Get DB PATH
puts "Please enter SQLite DB path."
values['db_path'] = gets.chomp
values['db_path'] = File.expand_path(values['db_path'])
puts "DB path saved: #{values['db_path']}"
puts "----------------------------------------------"


env_values_string = "ETH_TOKEN=#{values['eth_token']} ETH_ADDRESSES=#{values['eth_address']} MONO_TOKEN='#{values['mono_token']}' MONO_DB_PATH='#{values['db_path']}' MONO_DEBUG_MODE='true' MONO_ENV='development'"
puts "(WORKS ONLY IN UBUNTU) Do you want to set up service [y/n]"
service_setup = gets.chomp
until ['y','n'].include?(service_setup)
	puts "Wrong input, type in 'y' or 'n'"
	service_setup = gets.chomp
end
if service_setup == 'y' then
	ServerSettings.setup_service(values)
else
	puts "----------------------------------------------"
	puts "Command to run server manually:\n#{env_values_string} ruby #{ServerSettings::CURRENT_FOLDER}/monobank.rb"
end
