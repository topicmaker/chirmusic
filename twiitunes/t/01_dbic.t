# -*- mode:perl -*-
use strict;
use lib './lib/';
use lib '../Acore/lib/';
use lib '../extlib/lib/perl5/';
use Test::More;
#use Test::Requires qw/ DBIx::Class::Schema::Loader /;
use Scalar::Util qw/ blessed /;
#use t::WAFTest::Engine;
use Data::Dumper;
use twiitunes;
use MySchema;


BEGIN {
    use_ok "Acore";
    use_ok 'Acore::WAF';
    use_ok 'twiitunes';
};

my $c = twiitunes->new;
$c->config({
    "Model::DBIC" => {
        schema_class => "MySchema",
        connect_info => [
            'dbi:Pg:dbname=twiitunes',
            'twiitunes',
            '',
            { RaiseError => 1, AutoCommit => 0 },
        ]
    },
});


my $schema = $c->model('DBIC')->schema;
isa_ok $schema => "MySchema";

my $account_name    = 1;
my $itunes_trackid  = time;
ok($itunes_trackid, "itunes_trackid : ".$itunes_trackid);

{
    # TwiitunesAccount
    diag("TwiitunesAccount");
    my $account = $schema->resultset("TwiitunesAccount")->create({ name => $account_name });
    ok($account, "account");

    $account = $schema->resultset("TwiitunesAccount")->search({ name => $account_name })->first;
    ok($account, "search account");

    # TwiitunesMusic
    diag("TwiitunesMusic");
    $schema->resultset("TwiitunesMusic")->create({ itunes_trackid => $itunes_trackid });
    my @twiitunes_musics = $schema->resultset("TwiitunesMusic")->search(
        { itunes_trackid => $itunes_trackid },
        { order_by => 'created_on DESC' },
    );
    foreach (@twiitunes_musics) {
        ok($_->itunes_trackid);
    }

    # TwiitunesTweet
    diag("TwiitunesTweet");
    my $twiitunes_music = $twiitunes_musics[0];
    $schema->resultset("TwiitunesTweet")->create({
        twiitunes_music     => $twiitunes_music->id,
        twiitunes_account   => $account->id,
        description         => "12345678901234567890123456789012345678901234567890",
    });
    my $twiitunes_tweet = $schema->resultset("TwiitunesTweet")->search(
        {
            twiitunes_music => $twiitunes_music->id,
            twiitunes_account      => $account->id,
        },
        { order_by => 'created_on ASC' },
    )->first;
    ok($twiitunes_tweet->twiitunes_music, "twiitunes_music");
    ok($twiitunes_tweet->twiitunes_account, "twiitunes_account");
    ok($twiitunes_tweet->get_column("twiitunes_music"));
    ok($twiitunes_tweet->twiitunes_music->itunes_trackid);
    ok($twiitunes_tweet->twiitunes_account->id);

    my @columns = $twiitunes_tweet->result_source->columns;
    ok($_, $_) for @columns;

    my $tweet_length = 10;
    my $twiitunes_tweet_json_hash = $twiitunes_tweet->json_hash({
        tweet_length    => $tweet_length,
    });
    ok($twiitunes_tweet_json_hash, "twiitunes_tweet_json : ".Dumper($twiitunes_tweet_json_hash));
    is(length($twiitunes_tweet_json_hash->{short_description}), $tweet_length, "short_description length");

    # TwiitunesFavorite
    diag("TwiitunesFavorite");
    $schema->resultset("TwiitunesFavorite")->create({
        twiitunes_music     => $twiitunes_music->id,
        twiitunes_account   => $account->id,
    });
    my $twiitunes_favorite = $schema->resultset("TwiitunesFavorite")->search(
        {
            twiitunes_music     => $twiitunes_music->id,
            twiitunes_account   => $account->id,
        },
        {},
    )->first;
    ok($twiitunes_favorite->get_column("twiitunes_music"));
    is($twiitunes_favorite->twiitunes_music->id, $twiitunes_music->id);
    is($twiitunes_favorite->twiitunes_account->id, $account->id);
}

{
    diag("create_twiitunes_music");
    my $twiitunes_music = $schema->create_twiitunes_music({
        itunes_trackid  => "76868031",
        itunes_country  => "JP",
        bitly_long_url  => "http://www.topicmaker.com/",
    });
    ok($twiitunes_music);
    ok(utf8::is_utf8($twiitunes_music->itunes_artistname), "ok is_utf8 : ".$twiitunes_music->itunes_artistname);

    $twiitunes_music = $schema->create_twiitunes_music({
        itunes_trackid  => "XXXXXX",
        itunes_country  => "JP",
        bitly_long_url  => "http://www.topicmaker.com/",
    });
    is($twiitunes_music, undef);

    $twiitunes_music = $schema->create_twiitunes_music({
        itunes_trackid  => "76868031",
        itunes_country  => "JP",
        bitly_long_url  => undef,
    });
    is($twiitunes_music, undef);

}

done_testing;


# 　
