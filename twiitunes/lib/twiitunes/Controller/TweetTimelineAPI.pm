package twiitunes::Controller::TweetTimelineAPI;

use strict;
use warnings;
use utf8;
use Data::Dumper;

sub _auto {
    my ($self, $c, $args) = @_;
    1;
}


sub get_tweet {
    my ($self, $c, $args) = @_;

    # validate
    my $regex = $c->config->{default_validate}->{number};
    my $twiitunes_music_id = $args->{twiitunes_music_id};
    if ( $twiitunes_music_id !~ /$regex/o ) {
        $c->log->error('twiitunes_music_id error : ' . $twiitunes_music_id );
        $c->error( 500, "validate error." );
    }

    my $last_twiitunes_tweet_id = $args->{last_twiitunes_tweet_id};
    if ( $last_twiitunes_tweet_id !~ /$regex/o ) {
        $c->log->error('last_twiitunes_tweet_id error : ' . $last_twiitunes_tweet_id );
        $c->error( 500, "validate error." );
    }

    my $page_row = $args->{page_row};
    if ( $page_row !~ /$regex/o ) {
        $c->log->error('page_row error : ' . $page_row );
        $c->error( 500, "validate error." );
    }

    my $cond;
    $cond->{twiitunes_music}    = $twiitunes_music_id;
    $cond->{id}                 = { '<' => $last_twiitunes_tweet_id } if $last_twiitunes_tweet_id;

    my @twiitunes_tweets = $c->schema->resultset("TwiitunesTweet")->search(
        $cond, {
            order_by    => 'created_on DESC',
            rows        => $page_row,
        },
    );
    if ( scalar(@twiitunes_tweets) <= 0 ) {
        $c->log->info('twiitunes_tweet not found.');
        return $c->forward( $c->view("JSON") => "process", [] );
    }

    my @result;
    push( @result, $_->json_hash({
        tweet_length    => $c->config->{tweet_twitter}->{valid_characters_length},
    }) ) for @twiitunes_tweets;

    $c->forward( $c->view("JSON") => "process", \@result );
}


sub count_tweet {
    my ($self, $c, $args) = @_;

    # validate
    my $regex = $c->config->{default_validate}->{number};
    my $itunes_trackid = $args->{itunes_trackid};
    if ( $itunes_trackid !~ /$regex/o ) {
        $c->log->error('itunes_trackid error : ' . $itunes_trackid);
        $c->error( 500, "validate error." );
    }

    my $twiitunes_music = $c->schema->resultset("TwiitunesMusic")->search(
        { itunes_trackid => $itunes_trackid },
        { rows => 1 },
    )->first;
    return $c->forward( $c->view("JSON") => "process", [0] ) if !$twiitunes_music;

    my $twiitunes_tweets_count = $c->schema->resultset("TwiitunesTweet")->search(
        { twiitunes_music => $twiitunes_music->id }, {},
    )->count;

    $c->forward( $c->view("JSON") => "process", [$twiitunes_tweets_count] );
}


1;
