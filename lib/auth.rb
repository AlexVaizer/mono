authorize do |username, password|
	user = ENV['MONO_BASIC_USER'] || "vaizer"
	pass = ENV['MONO_BASIC_PASS'] || "BlahBlahPass"
	username == user && password == pass
end