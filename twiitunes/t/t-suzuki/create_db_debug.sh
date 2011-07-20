#!/bin/sh
# description: t-suzuki debug用

dropdb twiitunes_debug
createdb  -U twiitunes -E UTF8 -T template0 --lc-collate=ja_JP.UTF-8 --lc-ctype=ja_JP.UTF-8 twiitunes_debug
psql -U twiitunes -d twiitunes_debug -f /home/t-suzuki/public_html/applications/twiitunes/webapplication/trunk/twiitunes/sql/pg_create_table.sql

for i in $(seq 1 500) ;do psql twiitunes_debug -c "INSERT INTO twiitunes_account (name,twitter_screen_name,twitter_profile_image_url) VALUES ('name$i','twitter_screen_name$i','http://chirmusic.net/foo$i')";done;
for i in $(seq 1 500) ;do psql twiitunes_debug -c "INSERT INTO twiitunes_music (itunes_trackid) VALUES ('itunes_trackid$i')";done;
for i in $(seq 1 500) ;do psql twiitunes_debug -c "INSERT INTO twiitunes_tweet (twiitunes_music, twiitunes_account) VALUES ($i,1)";done;

psql twiitunes_debug -c "EXPLAIN SELECT * from twiitunes_account where name='foo';"
psql twiitunes_debug -c "EXPLAIN SELECT * from twiitunes_music where itunes_trackid='1';"
psql twiitunes_debug -c "EXPLAIN SELECT * from twiitunes_tweet where twiitunes_music=1;"
psql twiitunes_debug -c "EXPLAIN SELECT * from twiitunes_tweet where created_on ='2010-01-01'::date;"
