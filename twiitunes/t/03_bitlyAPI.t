# -*- mode:perl -*-
use strict;
use utf8;
use lib './lib';
use lib '../Acore/lib/';
use lib '../extlib/lib/perl5/';
use Test::More;
use Data::Dumper;

use bitlyAPI;
$bitlyAPI::is_debug = 1;    # debug mode



BEGIN {
    use_ok "bitlyAPI";
};

{
    my $json_object = generate_shorten_url({url => "http://www.topicmaker.com/"});
    ok($json_object);
    ok($json_object->{data}->{url}, $json_object->{data}->{url});
}

{
    my $json_object = generate_shorten_url();
    is($json_object, undef);
}

{
    my $json_object = generate_shorten_url({url => "XXXXX"});
    is($json_object, undef);
}

{
    $bitlyAPI::bitly_api_url = "ERR_URL";
    my $json_object = generate_shorten_url({url => "ERR_LONG_URL"});
    is($json_object, undef);
}


done_testing;

#　
