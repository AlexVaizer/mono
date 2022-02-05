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
	opts.on("-e", "--env ENVIRONMENT", "Set a testing ENV. Possible values: development, test, production") do |e|
		@env = e.to_sym
	end
end.parse!

ServerSettings::ENV = ServerSettings.validate_env(@env)
ServerSettings.save_pid

	set :environment, ServerSettings::ENV
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
				db_client_info = DataFactory::SQLite.get_all('clients')
				if db_client_info.empty? || (Time.parse(db_client_info.first[:timeUpdated]) < (Time.now - 60)) then
					mono.client_info = DataFactory::Mono.return_client_info(ServerSettings::ENV)
					mono.accounts = mono.client_info[:accounts]
					mono.client_info.delete(:accounts)
					mono.accounts.concat(DataFactory::ETH.return_client_info(ServerSettings::ENV))
					DataFactory::SQLite.create('clients', 'clientId', mono.client_info)
					mono.accounts.each do |acc|
						DataFactory::SQLite.create('accounts', 'id', acc)
					end
				else
					mono.client_info = db_client_info
					mono.accounts = DataFactory::SQLite.get_all('accounts')
				end
				@list = mono.accounts
				@title = "Accounts List"
				if (!(params['id'].nil? || params['id'].empty?) && mono.accounts.any? {|h| h[:id] == params['id']}) then 
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
