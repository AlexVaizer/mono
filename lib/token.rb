class Token	
	require 'jwt'
	SIGN_KEY_PATH = ENV['FIN_SIGN_KEY_PATH'] || File.expand_path(File.join("#{__dir__}/../", 'cert/token.rsa'))
	VERIFY_KEY_PATH = ENV['FIN_VERIFY_KEY_PATH'] || File.expand_path(File.join("#{__dir__}/../", 'cert/token.rsa.pub'))
	TOKEN_TTL = 7*24*3600 #7 days
	attr_reader :errorMessage, :exp, :header, :payload, :verifyKey, :signKey, :jwt, :isValid
	
	def initialize()
		@signKey = ''
		File.open(SIGN_KEY_PATH) do |file|
				@signKey = OpenSSL::PKey.read(file)
		end
		@verifyKey = ''
		File.open(VERIFY_KEY_PATH) do |file|
				@verifyKey = OpenSSL::PKey.read(file)
		end
		@payload = nil 
		@jwt = nil
		@isValid = false
	end

	def parseJwt(jwt)
		@jwt = jwt
		begin
			@payload, @header = JWT.decode(@jwt, @verifyKey, true, { algorithm: 'RS256'} )
			@exp = @header["exp"]
			@isValid = true
			if @exp.nil?
				@errorMessage = "No exp set on JWT token."
				@isValid = false
			end
			@exp = Time.at(@exp.to_i)
			if Time.now > @exp
				@errorMessage = "JWT token expired."
				@isValid = false
			end
		rescue JWT::DecodeError => e
			@errorMessage = "JWT invalid: #{e.message}"
			@isValid = false
		end
	end

		
	def create(payload)
		@header = {
			exp: Time.now.to_i + TOKEN_TTL 
		}
		@jwt = JWT.encode(payload, @signKey, "RS256", header)
		@exp = @header[:exp]
		@payload = payload
		@isValid = true
		return @jwt
	end
end