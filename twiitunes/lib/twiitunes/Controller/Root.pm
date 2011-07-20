package twiitunes::Controller::Root;

use strict;
use warnings;
use utf8;
use Data::Dumper;
use Net::Twitter;


sub _auto {
    my ($self, $c, $args) = @_;

    $c->res->header(
        "pragma"        => "no-cache",
        "Cache-Control" => "no-cache",
    ) if $args->{action} ne "static";

    1;
}


sub login {
    my ($self, $c) = @_;

    # ログイン後の戻り先を保存
    $c->session->set( "after_login_uri" => $c->req->headers->referer );

    # twitter oauth
    my $nt = Net::Twitter->new(
        traits          => ['API::REST', 'OAuth'],
        consumer_key    => $c->config->{twitter_oauth}->{consumer_key},
        consumer_secret => $c->config->{twitter_oauth}->{consumer_key_secret},
    );

     my $url = $nt->get_authorization_url(callback => $c->config->{twitter_oauth}->{callback_url},);

     $c->res->cookies->{oauth} = {
         value => {
             token          => $nt->request_token,
             token_secret   => $nt->request_token_secret,
         },
     };

     $c->res->redirect($url);
}

sub auth_callback  {
    my ($self, $c) = @_;

    my %cookie      = $c->request->cookies->{oauth}->value;
    my $verifier    = $c->req->param("oauth_verifier");
    my $token       = $c->req->param("oauth_token");     # oauth_tokenを取得

    my $nt = Net::Twitter->new(
        traits          => ['API::REST', 'OAuth'],
        consumer_key    => $c->config->{twitter_oauth}->{consumer_key},
        consumer_secret => $c->config->{twitter_oauth}->{consumer_key_secret},
    );
    $nt->request_token($cookie{token});
    $nt->request_token_secret($cookie{token_secret});

    my($access_token, $access_token_secret)
        = $nt->request_access_token(token => $token, verifier => $verifier); # tokenを追加

    $nt->access_token($access_token);
    $nt->access_token_secret($access_token_secret);
    my $profiles = $nt->verify_credentials();
    $c->log->debug(Dumper($profiles));

    if ( !$profiles->{id} ) {
        $c->log->error( Dumper($profiles) );
        $c->error( 500, "login error." );
    }

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

    my $url = $c->session->get("after_login_uri") || $c->uri_for('/');
    $c->session->set( "after_login_uri" => undef );
    $c->res->redirect($url);
}

sub logout {
    my ($self, $c) = @_;
    $c->logout();
    $c->redirect( $c->uri_for('/') );
}


1;
