package twiitunes::Controller::PublicTimelineAPI;

use strict;
use warnings;
use utf8;
use Data::Dumper;

sub _auto {
    my ($self, $c, $args) = @_;

    $c->schema->storage->debug(1) if $c->debug;

    1;
}


sub get_new_tweet {
    my ($self, $c, $args) = @_;

    # validate
    my $regex = $c->config->{default_validate}->{number};
    my $top_twiitunes_tweet_id = $args->{top_twiitunes_tweet_id};
    if ( $top_twiitunes_tweet_id !~ /$regex/o ) {
        $c->log->error('top_twiitunes_tweet_id error : ' . $top_twiitunes_tweet_id );
        $c->error( 500, "validate error." );
    }

    my $page_row = $args->{page_row};
    if ( $page_row !~ /$regex/o ) {
        $c->log->error('page_row error : ' . $page_row );
        $c->error( 500, "validate error." );
    }

    my $validate_page_row_max = $c->config->{default_validate}->{page_row};
    if ( $page_row >= $validate_page_row_max ) {
        $c->log->error('page_row max error : ' . $page_row );
        $c->error( 500, "validate error." );
    }

    my @twiitunes_tweets = $c->schema->resultset("TwiitunesTweet")->search({}, {
                                order_by    => 'created_on DESC',
                                rows        => $page_row,
                           });
    if ( scalar(@twiitunes_tweets) <= 0 ) {
        $c->log->info('twiitunes_tweet not found.');
        return $c->forward( $c->view("JSON") => "process", [] );
    }
    if ($twiitunes_tweets[0]->id == $top_twiitunes_tweet_id) {
        return $c->forward( $c->view("JSON") => "process", [] );
    }

    my @result;
    push( @result, $_->json_hash({
        tweet_length    => $c->config->{tweet_twitter}->{valid_characters_length},
    }) ) for @twiitunes_tweets;

    $c->forward( $c->view("JSON") => "process", \@result );
}


sub get_tweet {
    my ($self, $c, $args) = @_;

    # validate
    my $regex = $c->config->{default_validate}->{number};
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
    $cond = {
        id => { '<' => $last_twiitunes_tweet_id },
    } if $last_twiitunes_tweet_id;

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

#　
1;
