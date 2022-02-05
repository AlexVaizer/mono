#!/usr/bin/ruby
require './lib/server_settings.rb'
require 'sqlite3'

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

# Get Etherscan Address
puts "Please enter your Ether Address(es). Should be separated by comma"
values['eth_address'] = gets.chomp
puts "ETH token saved: #{values['eth_address']}"
puts "----------------------------------------------"

# Get DB PATH
puts "Please enter SQLite DB path."
values['db_path'] = gets.chomp

create_accounts = 'CREATE TABLE IF NOT EXISTS "accounts" ("id"	TEXT NOT NULL UNIQUE,"type"	TEXT,"currencyCode"	TEXT,"balance"	NUMERIC,"balanceUsd"	NUMERIC,"cashbackType"	TEXT,"creditLimit"	NUMERIC,"maskedPan"	TEXT,"sendId"	TEXT,"maskedPanFull"	TEXT,"iban"	TEXT,"timeUpdated"	TEXT,PRIMARY KEY("id"))' 
create_clients = 'CREATE TABLE IF NOT EXISTS "clients" ("clientId"	TEXT UNIQUE,"name"	TEXT,"webHookUrl"	TEXT,"permissions"	TEXT,"timeUpdated"	TEXT,PRIMARY KEY("clientId"))'
File.delete(values['db_path']) if File.exist?(values['db_path'])
db = SQLite3::Database.open(values['db_path'])
db.results_as_hash = true
db.execute(create_accounts)
db.execute(create_clients)
result_accounts = db.execute("PRAGMA table_info(accounts)")
result_clients =  db.execute("PRAGMA table_info(clients)")
db.close
puts "Clients table created: #{result_clients}"
puts "Accounts table created: #{result_accounts}"
puts "DB path saved: #{values['db_path']}"
puts "----------------------------------------------"


env_values_string = "MONO_SERV_IP='#{values['ip']}' MONO_SERV_PORT='#{values['port']}' ETH_TOKEN=#{values['eth_token']} ETH_ADDRESSES=#{values['eth_address']} MONO_TOKEN='#{values['mono_token']}' MONO_BASIC_AUTH_USER='#{values['mono_user']}' MONO_BASIC_AUTH_PASS='#{values['mono_pass']}' MONO_SSL_FOLDER='#{values['mono_ssl']}' MONO_DB_PATH='#{values['db_path']}'"
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
	puts "Command to run server manually:\n#{env_values_string} ruby #{ServerSettings::CURRENT_FOLDER}/monobank.rb -e development"
end
