package twiitunes::Controller::Debug;

use strict;
use warnings;
use utf8;
use Net::Twitter;
use Data::Dumper;


sub _auto {
    my ($self, $c, $args) = @_;

    $c->res->header(
        "pragma"        => "no-cache",
        "Cache-Control" => "no-cache",
    ) if $args->{action} ne "static";

    if ( $c->config->{product_mode} ) {
        $c->error( 404, "not debug mode." );
        return 0;
    }

    1;
}


sub hello_world {
    my ($self, $c) = @_;
    $c->response->body( "ok" );
}

sub play {
    my ($self, $c) = @_;
    $c->render("debug/play.mt");
}

sub auth {
    my ($self, $c) = @_;
    $c->render("debug/auth.mt");
}

sub manual_login {
    my ($self, $c) = @_;

    # twitter app 情報
    my $consumer_key    = $c->config->{twitter_oauth}->{consumer_key};
    my $consumer_secret = $c->config->{twitter_oauth}->{consumer_key_secret};

    ### topicmaker_dev 情報
    my $access_token        = '205562203-x6YaPeywmA4sfjui94SzTV5YcnCYTESljdefOnqZ';
    my $access_token_secret = '15ulsHDnDpYMTHdanMaAO6IUYJZPqD7OnquxyKvZdrM';

    # twitter oauth
    my $nt = Net::Twitter->new(
        traits   => [qw/OAuth API::REST/],
        consumer_key        => $consumer_key,
        consumer_secret     => $consumer_secret,
        access_token        => $access_token,
        access_token_secret => $access_token_secret,
    );
    my $profiles = $nt->verify_credentials();
    $c->log->debug(Dumper($profiles));

    if ( !$profiles->{id} ) {
        $c->log->error( Dumper($profiles) );
        $c->error( 500, "login error." );
    }

###======================================================================

    # アカウント情報更新（新規作成）
    my $user = $c->schema->resultset("TwiitunesAccount")->search({ name => $profiles->{id} })->first;
    if ( !$user ) {
        eval {
            $user = $c->schema->resultset("TwiitunesAccount")->create({
                name                        => $profiles->{id},
                twitter_screen_name         => $profiles->{screen_name},
                twitter_profile_image_url   => $profiles->{profile_image_url},
            });
        };
        if ($@) {
            $c->error( 500, "create TwiitunesAccount error : $@" );
        }
    }

    # ログイン
    $c->login({
        user                => $user,
        access_token        => $access_token,
        access_token_secret => $access_token_secret,
    });




    ### 戻り先url処理
    $c->session->set( "after_login_uri" => $c->req->headers->referer );
    my $url = $c->session->get("after_login_uri") || $c->uri_for('/');
    $c->session->set( "after_login_uri" => undef );

    $c->res->redirect($url);
###======================================================================

}


1;
