#!/usr/bin/ruby
#`kill \`ps -ef | grep sinatra.rb | grep -v grep | awk '{print $2}'\``
pid = `ps -ef | grep monobank.rb | grep -v grep | awk '{print $2}'`
pid = pid.chomp
if pid.empty? then
	puts ('Sinatra Process was not found. Nothing to stop')
else
	puts "Process found. ID: #{pid}. Killing it."
	`kill #{pid}`
	puts "Process #{pid} was killed"
end