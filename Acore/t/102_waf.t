# -*- mode:perl -*-
use strict;
use Test::More;
use t::WAFTest::Engine;

BEGIN {
    use_ok 'Acore::WAF';
    use_ok 'Acore::WAF::Request';
    use_ok 't::WAFTest';
};

my $app = t::WAFTest->new;
my $req = create_request(
    uri    => 'http://example.com/?foo=bar&bar=baz',
    method => "GET",
);
$app->request($req);
$app->config({ include_path => [] });

isa_ok $app => "Acore::WAF";
can_ok $app, qw/ setup path_to handle_request _dispatch dispatch_static
                 serve_static_file serve_acore_document
                 redirect uri_for render render_part dispatch_favicon
                 stash config request response acore log
                 req res error detach welcome_message
                 psgi_application
               /;

is ref $app->psgi_application({}) => "CODE", "psgi_application is CODE ref";
is ref t::WAFTest->psgi_application({}) => "CODE", "psgi_application is CODE ref";

done_testing;
