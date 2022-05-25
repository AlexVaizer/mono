class MonobankConnector
	attr_accessor :client_info, :accounts, :selected_account, :statements, :jars
	
	def initialize()
		@client_info = {}
		@client_info_updated = ''
		@accounts = []
		@statements = []
		@selected_account = {}
		@jars = []
	end

	def get_client_info_from_db()
		client_info = DataFactory::SQLite.get_all(DataFactory::SQLite::CLIENT_INFO_MODEL[:tableName]) 
		if ! client_info.empty? then
			@client_info = client_info.first
			@client_info_updated = Time.parse(@client_info[:timeUpdated])
			return true
		else
			return false
		end
	end

	def get_accounts_from_db()
		accounts = DataFactory::SQLite.get_all(DataFactory::SQLite::ACCOUNT_MODEL[:tableName])
		if ! accounts.empty? then
			@accounts  = accounts
			return true
		else
			return false
		end
	end
	
	def get_jars_from_db()
		jars = DataFactory::SQLite.get_all(DataFactory::SQLite::JAR_MODEL[:tableName])
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
		DataFactory::SQLite.create(DataFactory::SQLite::CLIENT_INFO_MODEL[:tableName], DataFactory::SQLite::CLIENT_INFO_MODEL[:idField], @client_info)
		@accounts.each do |acc|
				DataFactory::SQLite.create(DataFactory::SQLite::ACCOUNT_MODEL[:tableName], DataFactory::SQLite::ACCOUNT_MODEL[:idField], acc)
		end
		@jars.each do |jar|
				DataFactory::SQLite.create(DataFactory::SQLite::JAR_MODEL[:tableName], DataFactory::SQLite::JAR_MODEL[:idField], jar)
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
		if !(@selected_account.nil? || @selected_account.empty?)
			return true 
		else
			raise ArgumentError.new("Could not find account '#{id}'")
		end
	end
end
