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
require File.expand_path './lib/datafactory/mono.rb'
require File.expand_path './lib/datafactory/eth.rb'
require  File.expand_path'./lib/datafactory/sqlite.rb'
#########################################################

env = ENV['MONO_ENV'] || :development
env = env.to_sym
enable :logging
ServerSettings::ENV = ServerSettings.validate_env(env)
ServerSettings.save_pid
DataFactory::SQLite.migrate_db

	set :environment, ServerSettings::ENV
	set :port, ServerSettings::PORT
	set :bind, ServerSettings::IP
	set :ssl_certificate, File.expand_path(ServerSettings::SSL_CERT_PATH)
	set :ssl_key, File.expand_path(ServerSettings::SSL_KEY_PATH)
	ServerSettings.enable_ssl(ServerSettings::ENV)
	set :views, Proc.new { File.join(root, "views") }
		
	protect do
		get '/' do 
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
				logger.error("#{$!} #{$@}")
				status 500
				erb :errors
			end
		end
	end
	
	get '/public/*' do 
		send_file(File.join('./public', params['splat'][0]))
	end
