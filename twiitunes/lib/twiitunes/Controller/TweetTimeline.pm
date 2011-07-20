package twiitunes::Controller::TweetTimeline;

use strict;
use warnings;
use utf8;
use Data::Dumper;

sub _auto {
    my ($self, $c, $args) = @_;
    1;
}


sub view_GET {
    my ($self, $c, $args) = @_;

    # param check
    if ( $args->{itunes_trackid} !~ /^\w+$/ ) {
        $c->error( 500 => 'param itunes_trackid error.' );
    }

    # search TwiitunesMusic
    my $twiitunes_music = $c->schema->resultset("TwiitunesMusic")->search({
        itunes_trackid => $args->{itunes_trackid},
    })->first;
    $c->log->debug("search ok TwiitunesMusic. itunes_trackid : " . $twiitunes_music->itunes_trackid) if $twiitunes_music;

    if ( !$twiitunes_music ) {
        $twiitunes_music = $c->schema->create_twiitunes_music({
            itunes_trackid  => $args->{itunes_trackid},
            itunes_country  => $c->is_lang_jp(),
            bitly_long_url  => $c->uri_for('/tweet_timeline/view/',$args->{itunes_trackid}),
        });
        $c->error( 500 => "create_twiitunes_music error." ) if !$twiitunes_music;
        $c->log->info("create TwiitunesMusic. itunes_trackid : " . $twiitunes_music->itunes_trackid);
    }
    $c->stash->{twiitunes_music} = $twiitunes_music;

    $c->render("tweet_timeline/view.mt");
}

#　
1;
