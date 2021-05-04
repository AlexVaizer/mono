class MonobankConnector
	require 'net/http'
	require 'uri'
	require 'json'
	
	attr_accessor :client_info, :accounts, :statements 
	
	def initialize()
		@client_info = {}
		@accounts = []
		@statements = []
	end
end
