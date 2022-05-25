class MonobankConnector
	attr_accessor :client_info, :accounts, :selected_account, :statements, :jars
	CLIENT_INFO_TABLE = 'clients'
	CLIENT_INFO_TABLE_ID = 'clientId'
	ACCOUNTS_TABLE = 'accounts'
	ACCOUNTS_TABLE_ID = 'id'
	JARS_TABLE = 'jars'
	JARS_TABLE_ID = 'id'
	
	def initialize()
		@client_info = {}
		@client_info_updated = ''
		@accounts = []
		@statements = []
		@selected_account = {}
		@jars = []
	end

	def get_client_info_from_db()
		client_info = DataFactory::SQLite.get_all(CLIENT_INFO_TABLE) 
		if ! client_info.empty? then
			@client_info = client_info.first
			@client_info_updated = Time.parse(@client_info[:timeUpdated])
			return true
		else
			return false
		end
	end

	def get_accounts_from_db()
		accounts = DataFactory::SQLite.get_all(ACCOUNTS_TABLE)
		if ! accounts.empty? then
			@accounts  = accounts
			return true
		else
			return false
		end
	end
	
	def get_jars_from_db()
		jars = DataFactory::SQLite.get_all(JARS_TABLE)
		if ! jars.empty? then
			@jars  = jars
			return true
		else
			return false
		end
	end

	def get_client_info
		self.get_client_info_from_db
		if @client_info.empty? || (@client_info_updated < (Time.now - DataFactory::SQLite::DB_UPD_INTERVAL)) then
			self.get_client_info_from_api_and_save_to_db
		else
			self.get_accounts_from_db
			self.get_jars_from_db
		end
	end

	def get_client_info_from_api_and_save_to_db
		client_info = DataFactory::Mono.return_client_info()
		@accounts = client_info[:accounts]
		@jars = client_info[:jars]
		@accounts.concat(DataFactory::ETH.return_client_info())
		client_info.delete(:accounts)
		client_info.delete(:jars)
		@client_info = client_info
		DataFactory::SQLite.create(CLIENT_INFO_TABLE, CLIENT_INFO_TABLE_ID, @client_info)
		@accounts.each do |acc|
				DataFactory::SQLite.create(ACCOUNTS_TABLE, ACCOUNTS_TABLE_ID, acc)
		end
		@jars.each do |jar|
				DataFactory::SQLite.create(JARS_TABLE, JARS_TABLE_ID, jar)
		end
	end

	def get_statements_from_api
		if @selected_account.nil? || @selected_account.empty?
			raise ArgumentError.new('no selected account found')
		else
			if @selected_account[:type] == 'CRYPT'
				@statements = DataFactory::ETH.return_statements(@selected_account[:id])
			else
				@statements = DataFactory::Mono.return_statements(@selected_account[:id])
			end
		end
	end

	def select_account(id)
		@selected_account = @accounts.select { |x| x[:id] == id }.first 
		puts @selected_account
		if ! @selected_account.empty? 
			return true 
		else
			raise ArgumentError.new("Could nor select account #{id}")
		end
	end
end
