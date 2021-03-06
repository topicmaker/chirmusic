# -*- mode:perl -*-
use strict;
use warnings;
use Test::Base;
use Test::More;
use HTTP::Request;
use Data::Dumper;
use Storable qw/ dclone /;
use t::WAFTest::Engine;

filters {
    response => [qw/chomp/],
    uri      => [qw/chomp/],
};

use_ok("Acore::WAF");
use_ok("t::WAFTest");

my $base_config = {
    root => "t",
    cache => {
        class => "t::Cache",
        args  => {
            cache_root => "t/tmp/",
        },
    },
};
t::WAFTest->setup("Cache");
my $ctx = {};
run {
    my $block  = shift;
    my $config = dclone $base_config;
    run_engine_test($config, $block, $ctx);
};

done_testing;

__END__

=== set
--- uri
http://localhost/act/cache_set?value=foo
--- response
Content-Length: 3
Content-Type: text/html; charset=utf-8
Status: 200

foo

=== get
--- uri
http://localhost/act/cache_get
--- response
Content-Length: 3
Content-Type: text/html; charset=utf-8
Status: 200

foo
