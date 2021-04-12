authorize do |username, password|
	user = ServerSettings::BASIC_AUTH_USER 
	pass = ServerSettings::BASIC_AUTH_PASS
	username == user && password == pass
end