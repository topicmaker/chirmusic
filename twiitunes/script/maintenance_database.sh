#!/bin/sh
# description: 毎日定時にＤＢのバックアップを行う用スクリプト

psql twiitunes -U postgres -c "VACUUM ANALYZE;"

FNAME=twiitunes_`date +%Y%m%d`.dmp
pg_dump -U twiitunes twiitunes > $FNAME
gzip $FNAME
mv $FNAME* /var/www/backups/pg_dump
