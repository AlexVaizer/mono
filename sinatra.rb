#########################################################
# => DEPENDENCIES										#
#########################################################
require 'sinatra'
require 'sinatra/cors'
require 'optparse'
require File.expand_path('./lib/lib.rb')
require File.expand_path('./lib/cred.rb')
require File.expand_path('./lib/server.rb') 
#########################################################


	set :port, $env_values['port']
	set :bind, $env_values['ip']
	set :views, Proc.new { File.join(root, "views") } 

	get '/' do 
		@list = get_client_info($mono_opts['token'])
		erb :accounts
		#return @list.to_s
	end

	get '/account' do
		if not params['start'] then params['start'] = Time.now.to_i - 2592000 end
		if not params['end'] then params['end'] = Time.now.to_i end
		if not params['id'] then return "PLEASE PROVIDE ACCOUNT ID" end
		list = get_client_info($mono_opts['token'])
		@account_info = list['accounts'].select { |x| x["id"] == params['id'] }
		@account_info = @account_info.first
		@statements = get_account_statements($mono_opts['token'], params['id'], params['start'], params['end'])
		erb :statements
	end