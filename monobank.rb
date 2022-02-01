#!/usr/bin/ruby

#########################################################
# => DEPENDENCIES										#
#########################################################
require 'bundler/setup'
Bundler.require 
require 'sinatra'
require 'sinatra/cors'
require "sinatra/basic_auth"
require 'optparse'
require File.expand_path('./lib/mono.rb')
require File.expand_path('./lib/server_settings.rb')
require File.expand_path('./lib/auth.rb')
require File.expand_path('./lib/datafactory.rb')
#########################################################


OptionParser.new do |opts|
	opts.banner = "Usage: ruby sinatra.rb -e <ENV>"
	opts.on("-e", "--env ENVIRONMENT", "Set a testing ENV. Possible values: local, stage, prod") do |e|
		@env = e
	end
end.parse!

ServerSettings::ENV = ServerSettings.validate_env(@env)
ServerSettings.save_pid


	set :port, ServerSettings::PORT
	set :bind, ServerSettings::IP
	set :ssl_certificate, File.expand_path(ServerSettings::SSL_CERT_PATH)
	set :ssl_key, File.expand_path(ServerSettings::SSL_KEY_PATH)
	ServerSettings.enable_ssl(ServerSettings::ENV)
	set :views, Proc.new { File.join(root, "views") }
	puts "Server started for ENV:#{ServerSettings::ENV} at #{ServerSettings::IP}:#{ServerSettings::PORT}" 

		
	protect do
		get '/' do 
			date_start = params['start'] || Time.now.to_i - 30*24*60*60
			date_end = params['end'] || Time.now.to_i
			begin
				mono = MonobankConnector.new
				mono.client_info = DataFactory::Mono.return_client_info(ServerSettings::ENV)
				mono.accounts = mono.client_info[:accounts]
				mono.client_info.delete(:accounts)
				mono.accounts.push(DataFactory::ETH.return_client_info(ServerSettings::ENV))
				@list = mono.accounts
				@title = "Accounts List"
				if !(params['id'].nil? || params['id'].empty?)  then 
					mono.selected_account = params['id']
					@account_info = mono.accounts.select { |x| x[:id] == mono.selected_account }
					@account_info = @account_info.first
					if mono.selected_account[0..1] == '0x'
						mono.statements = DataFactory::ETH.return_statements(ServerSettings::ENV, mono.selected_account)
					else
						mono.statements = DataFactory::Mono.return_statements(ServerSettings::ENV, mono.selected_account)
					end
					@statements = mono.statements
					@title = @account_info[:maskedPan]
				end
				erb :index
			rescue 
				@errors = ServerSettings.return_errors($!,$@,ServerSettings::DEBUG_MESSAGES)
				status 500
				erb :errors
			end
		end
	end
	
	get '/public/*' do 
		send_file(File.join('./public', params['splat'][0]))
	end
