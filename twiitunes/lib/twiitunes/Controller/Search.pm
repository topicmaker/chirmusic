package twiitunes::Controller::Search;

use strict;
use warnings;
use utf8;
use Data::Dumper;

sub list_GET {
    my ($self, $c) = @_;
    $c->render("search/list.mt");
}


# 　
1;
