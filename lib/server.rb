#########################################################
# => SERVER SET UP										#
#########################################################
	$allowed_envs = ['local', 'stage', 'prod']
	OptionParser.new do |opts|
		opts.banner = "Usage: ruby sinatra.rb -e <ENV>"
		opts.on("-e", "--env ENVIRONMENT", "Set a testing ENV. Possible values: local, stage, prod") do |e|
			$env = e
		end
	end.parse!

	#Get server IP from file.
	$ip = get_server_ip

	$server = {
				'local' => {
					'port' => 4567,
					'ip' => $ip,
					'ssl' => false,
					'debug_messages' => true,
				},
				'stage' => {
					'port' => 4567,
					'ip' => $ip,
					'ssl' => false,
					'debug_messages' => true,
				},
				'prod' => {
					'port' => 11111,
					'ip' => $ip,
					'ssl' => true,
					'debug_messages' => false,
				},
	}


	#Validate ENVIRONMENT
	if not $allowed_envs.include?($env) then raise ArgumentError.new("Environment should be: #{$allowed_envs.to_s}") end
	$env_values = $server[$env]


	
	#Enable SSL if needed
	if $env_values['ssl'] then 
		require File.expand_path('./lib/sinatra_ssl.rb') 
		set :ssl_certificate, File.expand_path("./ssl/cert.crt")
		set :ssl_key, File.expand_path("./ssl/pkey.pem")
	end
	puts "SERVER STARTED WITH SETTINGS: #{$env_values}"
#########################################################