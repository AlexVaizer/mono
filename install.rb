#!/usr/bin/ruby

	a = `ifconfig | grep 'inet ' | awk '{print $2}'`
	a = a.split
	a.each_with_index do |v,i|
		puts "#{i+1}. [#{v}]"
	end
	puts "Please enter [1-#{a.count}] number and hit Enter"
	i = gets
	i = i.to_i
	ip = a[i-1]
	out_file = File.new("./ip.txt", "w")
	out_file.puts(ip)
	out_file.close
	puts "#{ip} was saved to ./ip.txt"

	


	# puts "Setting up service for Sinatra"
	# puts "Saving file to /etc/systemd/system/sinatra.service"
	# current_folder = `pwd`.chomp
	# destination = '/etc/systemd/system/sinatra.service'
	# service_settings = "
	# 					[Unit]
	# 					Description=Sinatra Ticket Creator service
	# 					After=network.target
	# 					StartLimitIntervalSec=0

	# 					[Service]
	# 					Type=simple
	# 					User=root
	# 					WorkingDirectory=#{current_folder}
	# 					ExecStart=#{File.join(current_folder, 'sinatra.rb -e prod')}
	# 					ExecStop=#{File.join(current_folder,'stop.rb')}

	# 					[Install]
	# 					WantedBy=default.target
	# 					"


	
	# out_file = File.new(destination, "w")
	# out_file.puts(service_settings)
	# out_file.close
	# puts 'File saved.'
	# puts 'If you want to run sinatra on startup, please run "systemctl enable sinatra"'


