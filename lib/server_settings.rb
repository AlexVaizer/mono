module ServerSettings
	require 'erb'
	ALLOWED_ENVS = ['local', 'stage', 'prod']
	SSL_ENABLE_FOR = ['prod']
	SSL_KEYS_FOLDER = ENV['MONO_SSL_FOLDER'] || './ssl'
	SSL_CERT_PATH = File.join(SSL_KEYS_FOLDER, 'cert.pem')
	SSL_KEY_PATH = File.join(SSL_KEYS_FOLDER, 'privkey.pem')
	SSL_SETUP_PATH = './lib/ssl.rb'
	IP = ENV['MONO_SERV_IP'] || '127.0.0.1'
	PORT = ENV['MONO_SERV_PORT'].to_i || 4567
	SERVICE_TEMPLATE_PATH = './lib/monobank_service.erb'
	SERVICE_DESTINATION_PATH = '/etc/systemd/system/monobank.service'
	CURRENT_FOLDER = `pwd`.chomp
	DEBUG_MESSAGES = ENV['MONO_DEBUG_MODE'] || true
	BASIC_AUTH_USER = ENV['MONO_BASIC_AUTH_USER']
	BASIC_AUTH_PASS = ENV['MONO_BASIC_AUTH_PASS']

	def ServerSettings.validate_env(env)
		if not ALLOWED_ENVS.include?(env) then 
			raise ArgumentError.new("Environment should be: #{ALLOWED_ENVS.to_s}")
		else 
			return env
		end
	end

	def ServerSettings.enable_ssl(env)
		if SSL_ENABLE_FOR.include?(env) then 
			require File.expand_path(ServerSettings::SSL_SETUP_PATH)
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
