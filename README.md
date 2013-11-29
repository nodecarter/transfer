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

There are few simple validations.
- the target table should be empty
- primary key on the target should be the same as in the source
- count of records in the target are the same as in the source after copying

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

## License

The MIT License (MIT)

Copyright (c) 2013 Undev.ru

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
