#!/bin/sh
# description: ＤＢ作成スクリプト

dropdb twiitunes
dropuser twiitunes
createuser -s -e twiitunes
createdb  -U twiitunes -E UTF8 -T template0 --lc-collate=ja_JP.UTF-8 --lc-ctype=ja_JP.UTF-8 twiitunes
psql -U twiitunes -d twiitunes -f pg_create_table.sql
