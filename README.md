# Description
Provides a frontend for Monobank API (https://api.monobank.ua/docs/)
Provides additional frontend for Etherscan API (https://docs.etherscan.io/)


Works on Sinatra DSL (http://sinatrarb.com/)

Deployment and work is tested on Ubuntu 22.04.3 LTS hosted on AWS virtual machine with Ruby v3.2.0. See other dependencies here: https://github.com/AlexVaizer/mono/blob/master/Gemfile
## Features
 - shows list of accounts from Monobank and Etherscan
 - shows list of transaction from Monobank and etherscan by Account ID
 - saves accounts info to the SQLite DB to minimize API calls quantity. Statements for the account are always fetched from API
## Security
 - Prod ENV is working through HTTPS protocol (HTTPS Served by NGINX, it redirects requests to local sinatra HTTP server)
 - Monobank and Etherscan Token and is taken from ENV variables and is never sent anywhere except Monobank and Etherscan servers, respectively
 - JWT Auth


# Installation (For Ubuntu)
 - Install ruby v3.0.2 and other deps: `sudo apt install curl ruby-full ruby-bundler ruby-dev net-tools libsqlite3-dev sqlite3 build-essential zlib1g-dev libreadline-dev libssl-dev libcurl4-openssl-dev nginx`
 - Install certbot and get SSL certificates, if you need https support: `sudo snap install core; sudo snap refresh core; sudo snap install --classic certbot; sudo certbot certonly --standalone` and copy the path where certificates are saved, you gonna need it on Service Setup step
 - Clone the repo: `git clone https://github.com/AlexVaizer/mono.git`
 - Install dependencies: `cd ./mono/ && bundle install`
 - Get a Monobank API Token: https://api.monobank.ua/
 - Get an Etherscan API Token https://docs.etherscan.io/
 - Run service setup: `sudo ./install.rb`, follow the instructions (USER-INPUT needed). This will create a service file in `/etc/systemd/system/monobank.service` and add nginx config to `/etc/nginx/sites-available`
 - sqlite DB is created by the install.rb script, but you need to create Users manually: `INSERT INTO user (id, password) values (USERNAME, PASSWORD)`
 - Create a RSA using SHA-256 hash algorithm certificate/private key and save them into `cert/token.rsa` and `cert/token.rsa.pub` repectively. They will be used for singning JWT Tokens


# Run Server
## As a Service
**Service installation and run is tested on UBUNTU ONLY. If you use other operating system, run in debugging mode**

Run:
`sudo systemctl start nginx && sudo systemctl start monobank`.
Always starts with 'production' env.

If you want to run sinatra at **startup**, run `sudo systemctl enable monobank` once.

## Debugging mode or locally
Run `./install.rb` and fill all needed info, reply 'n' to question "Do you want to install service" - you'll get proper command to run the server locally.

# Stop Server
## As a service 
`sudo systemctl stop monobank && sudo systemctl stop nginx`

## In debugging mode
 - `./stop.rb` for Development, Test environments
 - `sudo ./stop.rb` for Production

# Logging
If Sinatra runs as a service, logs are saved into `/var/log/syslog`

To see only monobank logs, use `sudo journalctl --no-pager --since 00:00 SYSLOG_IDENTIFIER=monobank.service`

If you are running in debug mode, logs are outputted to the console.
