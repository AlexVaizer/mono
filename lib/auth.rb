# Specify your authorization logic
authorize do |username, password|
  username == "vaizer" && password == "BlahBlahPass"
end