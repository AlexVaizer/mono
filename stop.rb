#!/usr/bin/ruby
file = File.open("./mono.pid")
pid = file.readlines.first.chomp
file.close
puts "Killing process #{pid}"
`kill #{pid}`
puts "Monobank process #{pid} killed"
File.delete("./mono.pid")