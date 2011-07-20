#!/bin/sh
PERL5LIB="$HOME/public_html/applications/twiitunes/webapplication/trunk/Acore/lib:$HOME/public_html/applications/twiitunes/webapplication/trunk/twiitunes/lib:$HOME/public_html/applications/twiitunes/webapplication/trunk/extlib/lib/perl5"
export PERL5LIB

#TWIITUNES_CONFIG_FILE=""
#TWIITUNES_CONFIG_LOCAL=""
#export PERL5LIB TWIITUNES_CONFIG_FILE TWIITUNES_CONFIG_LOCAL

#exec 2>&1
exec  \
$HOME/public_html/applications/twiitunes/webapplication/trunk/extlib/bin/start_server \
--port 5511 \
-- $HOME/public_html/applications/twiitunes/webapplication/trunk/extlib/bin/plackup \
-s Starlet \
-E production \
--max-workers=2 \
--max-reqs-per-child=100 \
-a $HOME/public_html/applications/twiitunes/webapplication/trunk/twiitunes/twiitunes.psgi
