module ServerSettings
	require 'erb'
	ALLOWED_ENVS = [:development, :test, :production]
	IP = ENV['MONO_SERV_IP'] || '127.0.0.1'
	PORT = ENV['MONO_SERV_PORT'].to_i || 8080
	SERVICE_TEMPLATE_PATH = './lib/monobank_service.erb'
	NGINX_TEMPLATE_PATH = './lib/nginx.erb'
	SERVICE_DESTINATION_PATH = '/etc/systemd/system/monobank.service'
	NGINX_DESTINATION_PATH = '/etc/nginx/sites-available'
	CURRENT_FOLDER = `pwd`.chomp
	DEBUG_MESSAGES = ENV['MONO_DEBUG_MODE'] || false
	BASIC_AUTH_USER = ENV['MONO_BASIC_AUTH_USER']
	BASIC_AUTH_PASS = ENV['MONO_BASIC_AUTH_PASS']

	def ServerSettings.validate_env(env)
		if not ALLOWED_ENVS.include?(env) then 
			raise ArgumentError.new("Environment should be: #{ALLOWED_ENVS.to_s}")
		else 
			return env
		end
	end

	def ServerSettings.setup_service(env_values)
		puts "Setting up service for Sinatra"
		puts "Saving file to #{ServerSettings::SERVICE_DESTINATION_PATH}"
		@env_values = env_values
		service_settings = ERB.new(File.read(File.expand_path(ServerSettings::SERVICE_TEMPLATE_PATH)))
		out_file = File.new(ServerSettings::SERVICE_DESTINATION_PATH, "w")
		out_file.puts(service_settings.result(binding))
		out_file.close
		puts "File saved."
		puts "If you want to run sinatra on startup, please run 'sudo systemctl enable monobank'"
		service_settings = ERB.new(File.read(File.expand_path(ServerSettings::NGINX_TEMPLATE_PATH)))
		out_file = File.new("#{ServerSettings::NGINX_DESTINATION_PATH}/#{@env_values['domain']}}", "w")
		out_file.puts(service_settings.result(binding))
		out_file.close
		puts "You need to enable created nginx server: 'sudo ln -s /etc/nginx/sites-available/#{@env_values['domain']} #{NGINX_DESTINATION_PATH} && sudo service nginx restart'"
	end
	
	def ServerSettings.list_ifconfig_ips
		a = `ifconfig | grep 'inet ' | awk '{print $2}'`
		a = a.split
		return a
	end
	
	def ServerSettings.return_errors(short,full,errorlevel)
		if errorlevel 
			return "#{short.message}.\n #{full.to_s}"
		else
			return short.message
		end
	end

	def ServerSettings.save_pid
		pid = Process.pid
		pidfile_path = File.join(ServerSettings::CURRENT_FOLDER,"mono.pid")
		pidfile = File.new(pidfile_path, "w")
		pidfile.puts(pid)
		pidfile.close
	end
end
