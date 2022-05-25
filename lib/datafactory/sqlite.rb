module DataFactory
	module DataFactory::SQLite
		require 'sqlite3'
		DB_PATH = ENV["MONO_DB_PATH"]
		DB_UPD_INTERVAL = 120 #seconds
		CLIENT_INFO_MODEL = {
			tableName: 'clients',
			idField: 'clientId',
			fields:[
				{ name: 'clientId', type: 'TEXT'},
				{ name: 'name', type: 'TEXT'},
				{ name: 'webHookUrl', type: 'TEXT'},
				{ name: 'permissions', type: 'TEXT' },
				{ name: 'timeUpdated', type: 'TEXT'}
			]
		}
		ACCOUNT_MODEL = {
			tableName: 'accounts',
			idField: 'id',
			fields: [ 
				{ name: 'id', type: 'TEXT'},
				{ name: 'balance', type: 'NUMERIC'},
				{ name: 'balanceUsd', type: 'NUMERIC'},
				{ name: 'currencyCode', type: 'TEXT'},
				{ name: 'type', type: 'TEXT'},
				{ name: 'maskedPan', type: 'TEXT'},
				{ name: 'maskedPanFull', type: 'TEXT'},
				{ name: 'ethUsdRate', type: 'NUMERIC'},
				{ name: 'timeUpdated', type: 'TEXT'},
			]
		}
		JAR_MODEL = {
			tableName: 'jars',
			idField: 'id',
			fields: [ 
				{ name: 'id', type: 'TEXT'},
				{ name: 'sendId', type: 'TEXT'},
				{ name: 'title', type: 'TEXT'},
				{ name: 'description', type: 'TEXT'},
				{ name: 'currencyCode', type: 'TEXT'},
				{ name: 'balance', type: 'NUMERIC'},
				{ name: 'goal', type: 'NUMERIC'},
				{ name: 'timeUpdated', type: 'TEXT'}
			]
		}

		def self.prepare_migration_request(model = {})
			request = ''
			fields_string = model[:fields].map { |m| "\"#{m[:name]}\" #{m[:type]}" }
			request = "CREATE TABLE IF NOT EXISTS \"#{model[:tableName]}\"(#{fields_string.join(',')},PRIMARY KEY(\"#{model[:idField]}\"))"
			return request
		end

		def self.migrate_db
			File.delete(DB_PATH) if File.exist?(DB_PATH)
			request_accounts = self.prepare_migration_request(ACCOUNT_MODEL)
			request_jars = self.prepare_migration_request(JAR_MODEL)
			request_client_info = self.prepare_migration_request(CLIENT_INFO_MODEL)
			resp_client_info = self.request(request_client_info)
			resp_accounts = self.request(request_accounts)
			resp_jars = self.request(request_jars) 
			return true
		end

		
		def self.request(request)
			db = SQLite3::Database.open(DB_PATH)
			db.results_as_hash = true
			re = db.execute(request)
			db.close
			resp = re.map {|str| str.transform_keys(&:to_sym) }
			return resp
		end


		def self.get(table, id, id_field)
			request = "SELECT * FROM #{table} WHERE #{id_field}=\"#{id}\""
			re = self.request(request)
			return re.first
		end
		
		##
		#Creates or updates row in a TABLE by ID_FIELD with DATA
		def self.create(table, id_field, data) 
			acc = self.get(table, data[id_field.to_sym], id_field)
			if ! acc then
				data[:timeUpdated] = Time.now.iso8601
				keys = data.keys.map { |e| e.to_s }.join(',')
				values = " '#{data.values.join('\',\'')}' "
				request = "INSERT INTO #{table} (#{keys.to_s}) VALUES (#{values})"
				re = self.request(request)
				return re = self.get(table, data[id_field.to_sym], id_field)
			else
				acc = self.update(table, id_field, data)
				return acc
			end
		end

		def self.get_all(table)
			request = "SELECT * FROM #{table}"
			re = self.request(request)
			resp = re.map {|str| str.transform_keys(&:to_sym) }
			return resp
		end

		def self.update(table, id_field,  data)
			request = "UPDATE #{table} SET"
			data[:timeUpdated] = Time.now.iso8601
			data.each do |k,v|
				request = "#{request} #{k.to_s}='#{v}',"
			end
			request = "#{request.chop} WHERE #{id_field}=\"#{data[id_field.to_sym]}\""
			re = self.request(request)
			return self.get(table, data[id_field.to_sym], id_field)
		end
	end
end