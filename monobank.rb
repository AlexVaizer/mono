#!/usr/bin/ruby

#########################################################
# => DEPENDENCIES										#
#########################################################
require 'bundler/setup'
Bundler.require 
require 'sinatra'
require "sinatra/basic_auth"
require "sinatra/cookies"
require 'optparse'
require File.expand_path('./lib/mono.rb')
require File.expand_path('./lib/server_settings.rb')
require File.expand_path('./lib/auth.rb')
require File.expand_path('./lib/datafactory.rb')
require File.expand_path './lib/datafactory/mono.rb'
require File.expand_path './lib/datafactory/eth.rb'
require  File.expand_path'./lib/datafactory/sqlite.rb'
require  File.expand_path'./lib/token.rb'
#########################################################

env = ENV['MONO_ENV'] || 'development'
env = env.to_sym
enable :logging
ServerSettings::ENV = ServerSettings.validate_env(env)
ServerSettings.save_pid
DataFactory::SQLite.migrate_db
require File.expand_path('./create_mock_users.rb') if File.exist?('./create_mock_users.rb')

helpers do 
	def protected!
    	return if authorized?
    	cookies.delete(:token)
    	redirect to('/login')
	end

	def extractToken
		reqToken = cookies[:token]
		return reqToken
	end

	def authorized?
		reqToken = extractToken
		token = Token.new()
		token.parseJwt(reqToken)
		return token.isValid
	end
end

	set :environment, ServerSettings::ENV
	set :port, ServerSettings::PORT
	set :bind, ServerSettings::IP
	set :ssl_certificate, File.expand_path(ServerSettings::SSL_CERT_PATH)
	set :ssl_key, File.expand_path(ServerSettings::SSL_KEY_PATH)
	set :allow_origin, '*'
	set :views, Proc.new { File.join(root, "views") }

	get '/login' do 
		erb :login
	end

	post '/login' do 
		userId = params["id"]
		password = params["password"]
		user = DataFactory::SQLite.get(:user, userId)
		if user && user[:password] == password
			token = Token.new()
			token.create(userId: userId)
			response.set_cookie(:token, :value => token.jwt, :expires => Time.at(token.exp))
			redirect('/')
		else
			"Wrong Creds"
		end
	end

		
	get '/' do
		protected!
		date_start = params['start'] || Time.now.to_i - 30*24*60*60
		date_end = params['end'] || Time.now.to_i
		begin
			mono = MonobankConnector.new
			mono.get_client_info
			@title = "Accounts List – MONO"
			if !(params['id'].nil? || params['id'].empty?) then 
				mono.select_account(params['id'])
				mono.get_statements_from_api
				@title = "#{mono.selected_account[:maskedPan]} – MONO"
			end
			@object = mono
			erb :index
		rescue 
			@errors = ServerSettings.return_errors($!,$@,ServerSettings::DEBUG_MESSAGES)
			logger.error(@errors)
			status 500
			erb :errors
		end
	end

	
	get '/public/*' do 
		send_file(File.join('./public', params['splat'][0]))
	end
