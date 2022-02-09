# Description
Provides a frontend for Monobank API (https://api.monobank.ua/docs/)
Provides additional frontend for Etherscan API (https://docs.etherscan.io/)


Works on Sinatra DSL (http://sinatrarb.com/)

Deployment and work is tested on Ubuntu 20.04.2 LTS hosted on AWS virtual machine with Ruby v2.7.0. See other dependencies here: https://github.com/AlexVaizer/mono/blob/master/Gemfile
## Features
 - shows list of accounts from Monobank and Etherscan
 - shows list of transaction from Monobank and etherscan by Account ID
 - saves accounts info to the SQLite DB to minimize API calls quantity. Statements for the account are always fetched from API
## Security
 - Prod ENV is working through HTTPS protocol
 - Monobank and Etherscan Token and is taken from ENV variables and is never sent anywhere except Monobank and Etherscan servers, respectively
 - Basic Auth (User and Password are taken from ENV variables)


# Installation (For Ubuntu)
 - Install ruby v2.7.0: `sudo apt install ruby-full`
 - Install sqlite client: `sudo apt-get install libsqlite3-dev`
 - Clone the repo: `git clone https://github.com/AlexVaizer/mono.git`
 - Install dependencies: `cd ./mono/ && bundle install`
 - Get a Monobank API Token: https://api.monobank.ua/
 - Get an Etherscan API Token https://docs.etherscan.io/
 - Create a folder on your server and copy SSL certificate/key there. They should be named `cert.pem` (certificate) and `privkey.pem` (private key)
 - Run service setup: `sudo ./install.rb`, follow the instructions (USER-INPUT needed). This will create a service file in `/etc/systemd/system/monobank.service`
 - sqlite DB is created by the install.rb script, so no need to create manually or do any migrations.


# Run Server
## As a Service
**Service installation and run is tested on UBUNTU ONLY. If you use other operating system, run in debugging mode**

Run:
`sudo systemctl start monobank`.
Always starts with 'production' env.

If you want to run sinatra at **startup**, run `sudo systemctl enable monobank` once.

## Debugging mode or locally
Run `./install.rb` and fill all needed info, reply 'n' to question "Do you want to install service" - you'll get proper command to run the server locally.

# Stop Server
## As a service 
`sudo systemctl stop monobank`

## In debugging mode
 - `./stop.rb` for Development, Test environments
 - `sudo ./stop.rb` for Production

# Logging
If Sinatra runs as a service, logs are saved into `/var/log/syslog`

To see only monobank logs, use `sudo journalctl --no-pager --since 00:00 SYSLOG_IDENTIFIER=monobank.service`

If you are running in debug mode, logs are outputted to the console.
