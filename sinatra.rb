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


	set :port, $env_values['port']
	set :bind, $env_values['ip']
	set :views, Proc.new { File.join(root, "views") } 

		
	protect do
			get '/' do 
				if $env == 'prod' then @list = get_client_info($mono_opts['token']) else @list = $mock_data['client-info'] end
				
				erb :accounts
				#return @list.to_s
			end

			get '/account' do
				if not params['start'] then params['start'] = Time.now.to_i - 2592000 end
				if not params['end'] then params['end'] = Time.now.to_i end
				if not params['id'] then return "PLEASE PROVIDE ACCOUNT ID" end
				if $env == 'prod' then list = get_client_info($mono_opts['token']) else list = $mock_data['client-info'] end
				@account_info = list['accounts'].select { |x| x["id"] == params['id'] }
				@account_info = @account_info.first
				if $env == 'prod' then @statements = get_account_statements($mono_opts['token'], params['id'], params['start'], params['end']) else @statements = $mock_data['statements'] end
				erb :statements
			end
	end
	get '/public/*' do 
				send_file File.join('./public', params['splat'][0])
	end