# Installation
 - Install ruby: `sudo apt install ruby-full`
 - Install gems: `sudo gem install sinatra sinatra-cors --no-doc`
 - Download the binaries to folder on your PC
 - Run IP address and service setup: `cd /path/to/files && sudo ./install.rb`, follow the instructions (USER-INPUT needed). This will create a service file in `/etc/systemd/system/monobank.service`
 - Create a `ssl` folder inside project, copy SSL certificate/key there. They should be named `cert.crt` (certificate) and `pkey.pem` (private key)


# Run Server
## As a Service
**Service installation and run is tested on UBUNTU ONLY. If you use other operating system, run in debugging mode**

Run:
`sudo systemctl start monobank`.
Always starts with 'prod' env.

If you want to run sinatra at **startup**, run `sudo systemctl enable monobank` once.

## Debugging mode

`sudo ./monobank.rb -e <ENVIRONMENT>`

Possible ENVIRONMENT values: *'local', 'stage', 'prod'*.

*"sudo" is needed only for 'prod' environment because AWS declines to run server on port 443 as non-root.*

# Stop Server
## As a service 
`sudo systemctl stop monobank`

## In debugging mode
 - `./stop.rb` for Local, Stage
 - `sudo ./stop.rb` for Production

# Logging
If Sinatra runs as a service, logs are saved into `/var/log/syslog`

To see only sinatra logs, use `tail -f /var/log/syslog | grep sinatra`

If you are running in debug mode, logs are outputted to the console.

# ENVS Settings
IP address is taken from 'ip.txt' file in root directory (run `install.rb` to save it there)

You can change these settings in server.rb file (see `$server` variable)

## Local
*(No data is sent to JIRA when ENV == Local, Mock Data used. See `$mock_data` variable in ./lib/cred.rb)*
 - 'port' = 4567,
 - 'ssl' = false, 
 - 'debug_messages' = true, 

## Stage
 - 'port' = 4567, 
 - 'ssl' = true, 
 - 'debug_messages' = true, 

## Prod
 - 'port' = 11111, 
 - 'ssl' = true, 
 - 'debug_messages' = false, 
