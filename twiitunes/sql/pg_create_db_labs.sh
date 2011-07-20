#!/bin/sh
# description: ＤＢ作成スクリプト【labs.internal (PostgreSQL 7.4.16) 用】

#createuser -dA twiitunes
dropdb -U twiitunes twiitunes
createdb twiitunes -U twiitunes -E UNICODE
psql -U twiitunes -f pg_create_table.sql twiitunes
