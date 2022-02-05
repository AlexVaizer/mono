#!/usr/bin/ruby
require 'sqlite3'
create_accounts = 'CREATE TABLE IF NOT EXISTS "accounts" (
	"id"	TEXT NOT NULL UNIQUE,
	"type"	TEXT,
	"currencyCode"	TEXT,
	"balance"	NUMERIC,
	"balanceUsd"	NUMERIC,
	"cashbackType"	TEXT,
	"creditLimit"	NUMERIC,
	"maskedPan"	TEXT,
	"sendId"	TEXT,
	"maskedPanFull"	TEXT,
	"iban"	TEXT,
	"timeUpdated"	TEXT,
	PRIMARY KEY("id")
)' 

create_clients = 'CREATE TABLE IF NOT EXISTS "clients" (
	"clientId"	TEXT UNIQUE,
	"name"	TEXT,
	"webHookUrl"	TEXT,
	"permissions"	TEXT,
	"timeUpdated"	TEXT,
	PRIMARY KEY("clientId")
)'

db = SQLite3::Database.open('./db.sqlite')
db.results_as_hash = true
db.execute(create_accounts)
db.execute(create_clients)
result_accounts = db.execute("PRAGMA table_info(accounts)")
result_clients =  db.execute("PRAGMA table_info(clients)")
db.close
puts "Clients table created: #{result_clients}"
puts "Accounts table created: #{result_accounts}"