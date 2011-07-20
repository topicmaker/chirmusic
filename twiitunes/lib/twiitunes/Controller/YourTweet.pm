package twiitunes::Controller::YourTweet;

use strict;
use warnings;
use utf8;
use Data::Dumper;

sub _auto {
    my ($self, $c, $args) = @_;

    # ログイン必須
    if ( !$c->user ) {
        $c->res->redirect($c->uri_for('/login'));
        return;
    }

    1;
}


sub index_GET {
    my ($self, $c, $args) = @_;
    $c->render("your_tweet/index.mt");
}

#　
1;
