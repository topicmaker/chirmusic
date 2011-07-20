package twiitunes::Controller::PublicTimeline;

use strict;
use warnings;
use utf8;
use Data::Dumper;

sub index_GET {
    my ($self, $c, $args) = @_;
    $c->render("public_timeline/index.mt");
}


# 　
1;
