package twiitunes::Controller::TweetCreate;

use strict;
use warnings;
use utf8;
use Data::Dumper;
use Net::Twitter;

sub _auto {
    my ($self, $c, $args) = @_;
    1;
}


sub form_GET {
    my ($self, $c, $args) = @_;

    # ログイン必須
    if ( !$c->user ) {
        return $c->res->redirect($c->uri_for('/login'));
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

     $c->render("tweet_create/form.mt");
}

sub req_POST {
    my ($self, $c) = @_;

    # ログイン必須
    if ( !$c->user ) {
        return $c->res->redirect($c->uri_for('/login'));
    }

    # CSRF
    if ( $c->req->param('sid') ne $c->session->session_id ) {
        $c->error( 500 => 'CSRF detacted.' );
    }

    # validate
    my $twiitunes_music = $c->schema->resultset("TwiitunesMusic")->search({
        itunes_trackid => $c->req->param("itunes_trackid"),
    })->first;
    $c->error( 500 => 'validate error. itunes_trackid : '. $c->req->param("itunes_trackid") ) if !$twiitunes_music;

    my $validate_error;
    my $description = $c->req->param("description");
    if (length($description) <= 0 || $description =~ m/^[\r?\n|\s|\　]+$/g) {
        $c->log->warning('description validate error. not_null.' );
        $validate_error->{description}->{not_null} = 1;
    }
    if (length($description) > $c->config->{tweet_validate}->{description}->{length} ) {
        $c->log->warning('description validate error. length too long : ' . $description );
        $validate_error->{description}->{length} = 1;
    }

    if (keys(%{$validate_error}) >= 1) {
        $c->flash->set(validate_error => $validate_error);
        return $c->res->redirect($c->uri_for('/tweet_create/form/', $c->req->param("itunes_trackid")));
    }

    # update - twitter
    my $tweet_string = substr($description, 0, $c->config->{tweet_twitter}->{valid_characters_length}) . "...";
    $c->log->debug("tweet_string : $tweet_string");

    my $tw_login = $c->session->get('tw_login');
    eval {
      my $nt = Net::Twitter->new(
        traits   => [qw/OAuth API::REST/],
        consumer_key        => $c->config->{twitter_oauth}->{consumer_key},
        consumer_secret     => $c->config->{twitter_oauth}->{consumer_key_secret},
        access_token        => $tw_login->{twitter}->{access_token},
        access_token_secret => $tw_login->{twitter}->{access_token_secret},
      );
      my $result = $nt->update($tweet_string);
    };
    if ($@) {
        $c->log->warning("twitter update error. $@");
        $validate_error->{twitter_update} = 1;
        $c->flash->set(validate_error => $validate_error);
        return $c->res->redirect($c->uri_for('/tweet_create/form/', $c->req->param("itunes_trackid")));
    }

    # update - twiitunes_tweet
    my $twiitunes_tweet = $c->schema->resultset("TwiitunesTweet")->create({
        twiitunes_music     => $twiitunes_music->id,
        twiitunes_account   => $c->user->id,
        description         => $description,
        ratings             => $c->req->param("ratings"),
    });

    $c->res->redirect($c->uri_for('/tweet_timeline/view/', $c->req->param("itunes_trackid")));
}


1;
