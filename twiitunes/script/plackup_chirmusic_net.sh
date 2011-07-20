#!/bin/sh
PERL5LIB="/var/www/applications/twiitunes/Acore/lib:/var/www/applications/twiitunes/twiitunes/lib:/var/www/applications/twiitunes/extlib/lib/perl5"
TWIITUNES_CONFIG_FILE="/var/www/applications/twiitunes/twiitunes/config/twiitunes.yaml"
TWIITUNES_CONFIG_LOCAL="/var/www/applications/twiitunes/twiitunes/config/twiitunes_chirmusic_net.yaml"
export PERL5LIB TWIITUNES_CONFIG_FILE TWIITUNES_CONFIG_LOCAL

exec 2>&1
exec  \
/var/www/applications/twiitunes/extlib/bin/start_server \
--port 5511 \
-- /var/www/applications/twiitunes/extlib/bin/plackup \
-s Starlet \
-E production \
--max-workers=10 \
--max-reqs-per-child=128 \
-a /var/www/applications/twiitunes/twiitunes/twiitunes.psgi
