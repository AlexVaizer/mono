#########################################################
# => SERVER SET UP										#
#########################################################

#########################################################

module ServerSettings
	require 'erb'
	ALLOWED_ENVS = ['local', 'stage', 'prod']
	SSL_ENABLE_FOR = ['prod','stage']
	SSL_CERT_PATH = './ssl/cert.crt'
	SSL_KEY_PATH = './ssl/pkey.pem'
	SSL_SETUP_PATH = './lib/ssl.rb'
	IP = ENV['MONO_SERV_IP'] || '127.0.0.1'
	PORT = ENV['MONO_SERV_PORT'].to_i || 4567
	SERVICE_TEMPLATE_PATH = './lib/monobank_service.erb'
	SERVICE_DESTINATION_PATH = '/etc/systemd/system/monobank.service'
	CURRENT_FOLDER = `pwd`.chomp
	DEBUG_MESSAGES = true

	def ServerSettings.validate_env(env)
		if not ALLOWED_ENVS.include?(env) then 
			raise ArgumentError.new("Environment should be: #{ALLOWED_ENVS.to_s}")
		else 
			return env
		end
	end

	def ServerSettings.enable_ssl(env)
		if SSL_ENABLE_FOR.include?(env) then 
			require File.expand_path(SSL_SETUP_PATH)
			set :ssl_certificate, File.expand_path(SSL_CERT_PATH)
			set :ssl_key, File.expand_path(SSL_KEY_PATH)
		end
	end

	def ServerSettings.setup_service
		puts "Setting up service for Sinatra"
		puts "Saving file to #{ServerSettings::SERVICE_DESTINATION_PATH}"
		service_settings = ERB.new(File.read(File.expand_path(SERVICE_TEMPLATE_PATH)))
		out_file = File.new(SERVICE_DESTINATION_PATH, "w")
		out_file.puts(service_settings.result)
		out_file.close
		puts 'File saved.'
		puts 'If you want to run sinatra on startup, please run "sudo systemctl enable monobank"'
	end
	
	def ServerSettings.list_ifconfig_ips
		a = `ifconfig | grep 'inet ' | awk '{print $2}'`
		a = a.split
		return a
	end
	
	def ServerSettings.return_errors(short,full,errorlevel)
		if errorlevel == false
			return short.message
		else
			return "#{short.message}.\n #{full.to_s}"
		end
	end
end
