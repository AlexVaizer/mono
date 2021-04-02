#!/usr/bin/ruby

#########################################################
# => DEPENDENCIES										#
#########################################################
require 'sinatra'
require 'sinatra/cors'
require "sinatra/basic_auth"
require 'optparse'
require File.expand_path('./lib/lib.rb')
require File.expand_path('./lib/cred.rb')
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

set :port, ServerSetting::PORT
set :bind, ServerSetting::IP
set :views, Proc.new { File.join(root, "views") } 

	
protect do
	get '/' do 
		begin
			if  ['prod','stage'].include?($env) then 
				@list = get_client_info($mono_opts['token']) 
			else 
				@list = $mock_data['client-info'] 
			end
			erb :accounts
		rescue 
			@errors = return_errors($!,$@,$env_values['debug_messages'])
			puts @errors.to_s
			status 500
			erb :error
		end
	end

	get '/account' do
		if not params['start'] then params['start'] = Time.now.to_i - 2592000 end
		if not params['end'] then params['end'] = Time.now.to_i end
		if not params['id'] then 
			status 400
			@error = "Please provide account id as 'id' in query params"
			erb :error
		end
		begin
			if  ['prod','stage'].include?($env) then 
				list = get_client_info($mono_opts['token']) 
			else 
				list = $mock_data['client-info'] 
			end
			@account_info = list['accounts'].select { |x| x["id"] == params['id'] }
			@account_info = @account_info.first
			if ['prod','stage'].include?($env) then 
				@statements = get_account_statements($mono_opts['token'], params['id'], params['start'], params['end']) 
			else 
				@statements = $mock_data['statements'] 
			end
			erb :statements
		rescue 
			@errors = return_errors($!,$@,$env_values['debug_messages'])
			puts @errors.to_s
			status 500
			erb :error
		end	
	end
end
get '/public/*' do 
	send_file(File.join('./public', params['splat'][0]))
end