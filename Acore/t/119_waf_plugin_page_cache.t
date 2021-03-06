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
    log => {
        level => "debug"
    },
    cache => {
        class => "t::Cache",
        args  => {
            cache_root => "t/tmp/",
        },
    },
    page_cache => {
        path_regexp => "^act/page_cache_enabled",
        expires     => 3,
    },
};
t::WAFTest->setup("Cache", "PageCache");
run {
    my $block  = shift;
    my $config = dclone $base_config;
    run_engine_test($config, $block);
};

done_testing;

__END__

=== disabled
--- uri
http://localhost/act/page_cache_disabled
--- response
Content-Length: 9
Content-Type: text/html; charset=utf-8
Status: 200

no-cached

=== get
--- uri
http://localhost/act/page_cache_enabled
--- response
Content-Length: 11
Content-Type: text/html; charset=utf-8
Last-Modified: Fri, 13 Feb 2009 23:31:30 GMT
Status: 200
X-PageCache: miss

page-cached

=== get (cached)
--- uri
http://localhost/act/page_cache_enabled
--- response
Content-Length: 11
Content-Type: text/html; charset=utf-8
Last-Modified: Fri, 13 Feb 2009 23:31:30 GMT
Status: 200
X-PageCache: hit

page-cached

=== get (if-modified-since)
--- uri
http://localhost/act/page_cache_enabled
--- request
If-Modified-Since: Fri, 13 Feb 2009 23:31:30 GMT
--- response
Content-Type: text/html; charset=utf-8
Last-Modified: Fri, 13 Feb 2009 23:31:30 GMT
Status: 304
X-PageCache: hit

=== get (if-modified-since no match)
--- uri
http://localhost/act/page_cache_enabled
--- request
If-Modified-Since: Fri, 13 Feb 2009 23:31:10 GMT
--- response
Content-Length: 11
Content-Type: text/html; charset=utf-8
Last-Modified: Fri, 13 Feb 2009 23:31:30 GMT
Status: 200
X-PageCache: hit

page-cached

=== get (cache miss)
--- wait
4
--- uri
http://localhost/act/page_cache_enabled
--- response
Content-Length: 11
Content-Type: text/html; charset=utf-8
Last-Modified: Fri, 13 Feb 2009 23:31:30 GMT
Status: 200
X-PageCache: miss

page-cached

=== get (cache hit)
--- uri
http://localhost/act/page_cache_enabled
--- response
Content-Length: 11
Content-Type: text/html; charset=utf-8
Last-Modified: Fri, 13 Feb 2009 23:31:30 GMT
Status: 200
X-PageCache: hit

page-cached

=== get (age)
--- uri
http://localhost/act/page_cache_enabled_age
--- response
Cache-Control: max-age=2
Content-Length: 11
Content-Type: text/html; charset=utf-8
Status: 200
X-PageCache: miss

page-cached

=== get (age cache hit)
--- uri
http://localhost/act/page_cache_enabled_age
--- response
Cache-Control: max-age=2
Content-Length: 11
Content-Type: text/html; charset=utf-8
Status: 200
X-PageCache: hit

page-cached

=== get (age cache expired)
--- wait
3
--- uri
http://localhost/act/page_cache_enabled_age
--- response
Cache-Control: max-age=2
Content-Length: 11
Content-Type: text/html; charset=utf-8
Status: 200
X-PageCache: miss

page-cached

=== get (no-cache)
--- uri
http://localhost/act/page_cache_enabled_but_no_cache
--- response
Cache-Control: no-cache, no-store
Content-Length: 11
Content-Type: text/html; charset=utf-8
Status: 200
X-PageCache: miss,no-store

page-cached

=== get (no-cache)
--- uri
http://localhost/act/page_cache_enabled_but_no_cache
--- response
Cache-Control: no-cache, no-store
Content-Length: 11
Content-Type: text/html; charset=utf-8
Status: 200
X-PageCache: miss,no-store

page-cached

