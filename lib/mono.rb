class MonobankConnector
	require 'net/http'
	require 'uri'
	require 'json'
	
	attr_accessor :client_info, :accounts, :selected_account, :statements 
	
	def initialize()
		@client_info = {}
		@accounts = []
		@statements = []
		@selected_account = ''
	end
end
