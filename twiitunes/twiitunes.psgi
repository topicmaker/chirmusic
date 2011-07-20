#!/usr/bin/perl
# -*- mode:perl -*-
use strict;
use warnings;
use lib qw( lib );
use twiitunes;
use Acore::WAF::ConfigLoader;
use Plack::Builder;

my $config = Acore::WAF::ConfigLoader->new->load(
    $ENV{'TWIITUNES_CONFIG_FILE'} || "config/twiitunes.yaml",
    $ENV{'TWIITUNES_CONFIG_LOCAL'},
);
builder {
    # enable Plack::Middlewares here
    enable "Static",
        path => qr{^/static/}, root => "./";
    enable "Static",
        path => qr{^/admin_console/static/}, root => "../Acore/assets/";

    # ReverseProxy
    enable "ReverseProxy";
    enable sub {
       my $app = shift;
       sub {
           my $env = shift;
           $env->{SCRIPT_NAME} = $config->{rp_script_name};
           $app->($env);
       };
    };

    twiitunes->psgi_application($config);
};

__END__

=head1 Run on Plack

  $ plackup twiitunes.psgi

