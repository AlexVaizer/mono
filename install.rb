#!/usr/bin/ruby
require './lib/server.rb'

#GET IP ADDRESS
ips = ServerSettings.list_ifconfig_ips
ips.each_with_index do |v,i|
	puts "#{i+1}. [#{v}]"
end
puts "Please enter [1-#{ips.count}] number and hit Enter"
i = gets
i = i.to_i
ip = ips[i-1]
puts "IP address chosen: #{ip}"
puts "----------------------------------------------"

# GET PORT
puts "Please enter PORT number and hit Enter"
port_s = gets
port = port_s.to_i
puts "Port chosen: #{port}"
puts "----------------------------------------------"

# GET MONOBANK TOKEN
puts "Please enter Monobank Auth Token and hit Enter"
mono_token = gets
puts "Token chosen: #{mono_token}"


env_values = "MONO_SERV_IP='#{ip}' MONO_SERV_PORT='#{port}' MONO_TOKEN='#{mono_token}'"
puts "(WORKS ONLY IN UBUNTU) Do you want to set up service [y/n]"
service_setup = gets.chomp
until ['y','n'].include?(service_setup)
	puts "Wrong input, type in 'y' or 'n'"
	service_setup = gets
end
if service_setup == 'y' then
	ServerSettings.setup_service(env_values)
else
	puts "----------------------------------------------"
	puts "Command to run server manually:\n#{env_values} #{ServerSettings::CURRENT_FOLDER}/monobank.rb -e local"
end
