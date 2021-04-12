# Description
Provides a frontend for Monobank API (https://api.monobank.ua/docs/)

Works on Sinatra DSL (http://sinatrarb.com/)

Deployment and work is tested on Ubuntu 20.04.2 LTS hosted on AWS virtual machine with Ruby v2.7.0. You can see other dependencies here: https://github.com/AlexVaizer/mono/blob/master/Gemfile
## Features
 - shows list of accounts
 - shows list of transaction by Account ID
## Security
 - Stage and Prod ENVs are working through HTTPS protocol
 - Monobank Token and is taken from ENV variables and is never sent anywhere except Monobank servers
 - Basic Auth (User and Password are taken from ENV variables)


# Installation (For Ubuntu)
 - Install ruby v2.7.0: `sudo apt install ruby-full`
 - Clone the repo: `git clone https://github.com/AlexVaizer/mono.git`
 - Install dependencies: `cd ./mono/ && bundle install`
 - Get a Monobank API Token: https://api.monobank.ua/
 - Run service setup: `sudo ./install.rb`, follow the instructions (USER-INPUT needed). This will create a service file in `/etc/systemd/system/monobank.service`
 - Create a `ssl` folder inside project, copy SSL certificate/key there. They should be named `cert.crt` (certificate) and `pkey.pem` (private key)


# Run Server
## As a Service
**Service installation and run is tested on UBUNTU ONLY. If you use other operating system, run in debugging mode**

Run:
`sudo systemctl start monobank`.
Always starts with 'prod' env.

If you want to run sinatra at **startup**, run `sudo systemctl enable monobank` once.

## Debugging mode or locally
Run `./install.rb` and fill all needed info, reply 'n' to question "Do you want to install service" - you'll get proper command to run the server locally.

# Stop Server
## As a service 
`sudo systemctl stop monobank`

## In debugging mode
 - `./stop.rb` for Local, Stage
 - `sudo ./stop.rb` for Production

# Logging
If Sinatra runs as a service, logs are saved into `/var/log/syslog`

To see only monobank logs, use `tail -f /var/log/syslog | grep monobank`

If you are running in debug mode, logs are outputted to the console.
