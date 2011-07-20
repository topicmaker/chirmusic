package twiitunes::Controller::RootIndex;

use strict;
use warnings;
use utf8;
use Data::Dumper;

sub index_GET {
    my ($self, $c) = @_;
    $c->log->info("config name:" . $c->config->{name});
    $c->render("root/index.mt");
}

#　
1;
