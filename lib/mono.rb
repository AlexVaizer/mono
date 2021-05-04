class MonobankConnector
	require 'net/http'
	require 'uri'
	require 'json'
	
	attr_accessor :env, :client_info, :accounts, :statements 
	
	def initialize(env)
		@env = env
		@client_info = {}
		@accounts = []
		@statements = []
	end
	def get_client_info
		DataFactory.get_client_info(self)
	end

	def get_statements(account)
		DataFactory.get_statements(self,account)
	end
end