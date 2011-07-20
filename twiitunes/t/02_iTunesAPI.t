# -*- mode:perl -*-
use strict;
use utf8;
use lib './lib';
use lib '../Acore/lib/';
use lib '../extlib/lib/perl5/';
use Test::More;
use Data::Dumper;

use iTunesAPI;
$iTunesAPI::is_debug = 1;    # debug mode



BEGIN {
    use_ok "iTunesAPI";
};

{
    my $json_object = search_musictrack_by_term({term => "くるり"});
    ok($json_object);
    is(($json_object->{results}->[0]->{trackViewUrl} =~ m{^http://itunes.apple.com/us.*}), 1);
    ok($json_object->{results}->[0]->{$_}, $json_object->{results}->[0]->{$_}) for (qw/trackViewUrl previewUrl artworkUrl100/);
##    diag(Dumper($json_object));

    $json_object = search_musictrack_by_term({
        term        => "   Michael　　　Jackson   　　",
        api_params  => {
            country     => "JP",    # japan の itunes store URLを取得
            limit       => 3,
        },
    });
##    diag(Dumper($json_object));
    ok($json_object);
    is($json_object->{resultCount}, 3);
    is(($json_object->{results}->[0]->{trackViewUrl} =~ m{^http://itunes.apple.com/jp.*}), 1);
}

{
    my $json_object = search_musictrack_by_trackid({trackid => "258173484"});
    ok($json_object);
    is(($json_object->{results}->[0]->{trackViewUrl} =~ m{^http://itunes.apple.com/us.*}), 1);
##    diag(Dumper($json_object));

    $json_object = search_musictrack_by_trackid({
        trackid     => "258173484",
        api_params  => {
            country     => "JP",
        },
    });
##    diag(Dumper($json_object));
    ok($json_object);
    is($json_object->{resultCount}, 1);     # 1件のみ返る仕様
    is(($json_object->{results}->[0]->{trackViewUrl} =~ m{^http://itunes.apple.com/jp.*}), 1);
}



done_testing;

#　
