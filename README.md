# Transfer data from mysql to postgres database

## Description

This tool copy data from one database to another with sequel.
Only mysql to postgres transfer has been tested.
Database and tables will not be created. Just copy data.

## Using

Download or clone in some path:

    git clone https://github.com/nodecarter/transfer.git

Go to cloned folder:

    cd transfer

Install required gems:

    bundle install

Create config by copying sample:

    cp config/transfer.sample.yml config/transfer.yml

Edit config and then start transfer all tables:

    rake transfer

Or transfer some specific table:

    rake transfer TABLE_NAME=my_table_name

Progress will be printed in STDOUT.

Transfer will be run in transaction. If some error will be occur all transfer will be rolled back.

## Validations

There ar two simple validations.
At first we check that target table is empty.
At the end of transfer we check that count of records are the same.

## Config

Config should contain source and target databases. Sample config:

    source:
      adapter: mysql2
      host: localhost
      database: source_db
      user: root
      password:
      encoding: utf8
    target:
      adapter: postgres
      host: localhost
      database: target_db
      user: postgres
      password:
      encoding: utf8

You can exclude some tables from transfer by defining exclude_tables:

    exclude_tables:
      - schema_migrations

Or you can clear all data in target table before copying:

    truncate_tables:
      - roles
      - users

## Testing

    rake test
