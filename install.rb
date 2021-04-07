#!/usr/bin/ruby
require './lib/server.rb'
ips = ServerSettings.list_ifconfig_ips
ips.each_with_index do |v,i|
	puts "#{i+1}. [#{v}]"
end
puts "Please enter [1-#{ips.count}] number and hit Enter"
i = gets
i = i.to_i
ip = ips[i-1]
out_file = File.new("./ip.txt", "w")
out_file.puts(ip)
out_file.close
puts "#{ip} was saved to ./ip.txt"

puts "(WORKS ONLY IN UBUNTU) Do you want to set up service [y/n]"
service_setup = gets.chomp
until ['y','n'].include?(service_setup)
	puts "Wrong input, type in 'y' or 'n'"
	service_setup = gets
end
if service_setup == 'y' then
	ServerSettings.setup_service
else
	puts "No service setup needed. Closing script"
end
