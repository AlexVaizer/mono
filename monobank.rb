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
require File.expand_path('./lib/server.rb')
require File.expand_path('./lib/auth.rb')
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
	set :views, Proc.new { File.join(root, "views") }
	puts "Server started for ENV:#{ServerSettings::ENV} at #{ServerSettings::IP}:#{ServerSettings::PORT}" 

		
	protect do
		get '/' do 
			date_start = params['start'] || Time.now.to_i - 30*24*60*60
			date_end = params['end'] || Time.now.to_i
			begin
				if not params['id'] then 
					@list = MonobankConnector.get_client_info(ServerSettings::ENV) 
					erb :accounts
				else
					account_id = params['id']
					@list = MonobankConnector.get_client_info(ServerSettings::ENV)
					@account_info = @list['accounts'].select { |x| x["id"] == account_id }
					@account_info = @account_info.first
					@statements = MonobankConnector.get_statements(ServerSettings::ENV, account_id, date_start, date_end) 
					erb :statements
				end
			rescue 
				@errors = ServerSettings.return_errors($!,$@,ServerSettings::DEBUG_MESSAGES)
				puts @errors.to_s
				status 500
				erb :error
			end
		end
	end
	
	get '/public/*' do 
		send_file(File.join('./public', params['splat'][0]))
	end
