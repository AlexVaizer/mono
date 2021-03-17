# Root
## install.rb
When being run, creates
 - ip.txt file that contains server IP Address
 - /etc/systemd/system/monobank.service file with Service info

## monobank.rb
Main file for sinatra. 
Contains: 
 - calls for all neededed gems and files 
 - endpoints set up

## stop.rb
Script used to stop monobank service.

# ./lib
## auth.rb
Contains credentials for Basic Auth

## cred.rb
Contains next variables:
 - $mock_data of 'statements' and 'client-info'
 - monobank connection set up. $mono_opts: 'token', 'site'; pathes for 'client-info', 'statements' calls
 - Currencies list with numeric-to-text

## lib.rb
Contains main functions:
 - Retrieve data from Monobank API: get_client_info(token), get_account_statements(token, date_start, date_end)
 - Return error depending on debug : return_errors(short,full,errorlevel)
 - Read IP Address from file: get_server_ip()


## server.rb
Info for server set up:
 - check ENV from command-line params
 - read IP from ip.txt
 - set up SSL, port, debug_messages depending on ENV

## ssl.rb
Contains SSL set up, being called from server.rb if needed

# ./public
Contains media files

# ./views
## accounts.erb
View to display accounts list

## error.erb
View to display error messages, if something went wrong

## head.erb
Renders header of the page, needs to be called from other views along with *@title* variable

## statements.erb
View to display statements page

## table.erb
View to display tables. Needs to be called from other views along with *@table_content* variable with next structure:
```@table_content = {
	'headers' => ['header1', 'header2', 'header3'],
 	'width' => [20,50,30],
 	'content' => [
 		['hello', 'cruel', 'world'],
 		['my', 'name', 'is Alex'],
 		['and', 'i love', 'living'],
 	]
 }```
