package twiitunes;

use strict;
use warnings;
use Any::Moose;
use Storable qw( freeze thaw );
use Data::Dumper;
extends 'Acore::WAF';

our $VERSION = '0.1';

my @plugins = qw/
    Session
    FormValidator
    FillInForm
/;
__PACKAGE__->setup(@plugins);

__PACKAGE__->meta->make_immutable;
no Any::Moose;



# method
sub schema {
    my $c = shift;
    return $c->model('DBIC')->schema;
}

sub is_smartphone {
    my $c = shift;
    return ($c->req->user_agent =~ /iPhone|iPod|Android/);
}

sub is_lang_jp {
    my $c = shift;

    my $is_lang_jp = ($c->req->header('accept-language') =~ /ja/) ? 'JP' : undef;
    $c->log->debug("is_lang_jp : " . $is_lang_jp);

    return $is_lang_jp;
}

# Acore Override
sub login {
    my ($c, $prms) = @_;

    my $tw_login = {
        account_id      => $prms->{user}->id,
        account_freeze  => freeze($prms->{user}),
        twitter         => {
            access_token        => $prms->{access_token},
            access_token_secret => $prms->{access_token_secret},
        },
    };

    $c->session->set('tw_login' => $tw_login);
    $prms->{user};
}

sub logout {
    my $c = shift;
    $c->session->set('tw_login' => undef);
}

sub user {
    my $c = shift;

    my $tw_login = $c->session->get('tw_login');
    return if !$tw_login;

    my $user;
    eval { $user = thaw($tw_login->{account_freeze}) };
    $c->log->debug("thaw(account_freeze) ok message : $@") if $@;
    return $user if $user;

    $user = $c->schema->resultset("TwiitunesAccount")->search({ id => $tw_login->{account_id} })->first;
    $c->log->debug("search TwiitunesAccount. account_id : " . $tw_login->{account_id});
    $c->login({
        user                => $user,
        access_token        => $tw_login->{twitter}->{access_token},
        access_token_secret => $tw_login->{twitter}->{access_token_secret},
    });

    $user;
}

sub finalize {
    my ($c) = @_;

    # commit or rollback
    my $status = $c->res->status;
    if ($status =~ qr/^[2|3]\d{2}$/) {
        $c->log->debug( "commit. status : $status");
        $c->schema->txn_commit;
    }
    else {
        $c->log->debug( "rollback. status : $status");
        $c->schema->txn_rollback;
    }
    $c->log->flush;

    $c->next::method(@_);
};



package twiitunes::Dispatcher;
use Acore::WAF::Util qw/ :dispatcher /;
use HTTPx::Dispatcher;

connect "static/:filename", to class "twiitunes" => "dispatch_static";
connect "favicon.ico",      to class "twiitunes" => "dispatch_favicon";

# Admin console
for (bundled "AdminConsole") {
    connect "admin_console/",                 to $_ => "index";
    connect "admin_console/static/:filename", to $_ => "static";
    connect "admin_console/:action",          to $_;
}

# Sites
connect "sites/",      to bundled "Sites" => "page";
connect "sites/:page", to bundled "Sites" => "page";


# Controller
connect "login",            to controller "Root" => "login";
connect "logout",           to controller "Root" => "logout";
connect "auth_callback",    to controller "Root" => "auth_callback";

connect "", to controller "RootIndex" => "index";

connect "debug/:action", to controller "Debug";

connect "public_timeline", to controller "PublicTimeline" => "index";

connect "search/:action",                       to controller "Search";

connect "search_api/:action/:keyword/:page",    to controller "SearchAPI";

connect "tweet_create/:action/:itunes_trackid",     to controller "TweetCreate";
connect "tweet_create/:action",                     to controller "TweetCreate";

connect "tweet_timeline/:action/:itunes_trackid",   to controller "TweetTimeline";

connect "tweet_timeline_api/count_tweet/:itunes_trackid",
            to controller "TweetTimelineAPI" => "count_tweet",
            args => { page => "count_tweet" };
connect "tweet_timeline_api/get_tweet/:twiitunes_music_id/:last_twiitunes_tweet_id/:page_row",
            to controller "TweetTimelineAPI" => "get_tweet",
            args => { page => "get_tweet" };

connect "your_tweet/", to controller "YourTweet" => "index";

connect "your_tweet_api/get_tweet/:last_twiitunes_tweet_id/:page_row",
            to controller "YourTweetAPI" => "get_tweet",
            args => { page => "get_tweet" };

connect "public_timeline_api/get_new_tweet/:top_twiitunes_tweet_id/:page_row",
            to controller "PublicTimelineAPI" => "get_new_tweet",
            args => { page => "get_new_tweet" };
connect "public_timeline_api/get_tweet/:last_twiitunes_tweet_id/:page_row",
            to controller "PublicTimelineAPI" => "get_tweet",
            args => { page => "get_tweet" };


#□
1;
