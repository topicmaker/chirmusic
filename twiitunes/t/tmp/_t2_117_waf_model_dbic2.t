# -*- mode:perl -*-
use strict;
use Test::More;
use Test::Requires qw/ DBIx::Class::Schema::Loader /;
use Scalar::Util qw/ blessed /;
use t::WAFTest::Engine;
use Data::Dumper;

BEGIN {
    use_ok "Acore";
    use_ok 'Acore::WAF';
    use_ok 't::WAFTest';
};

my $dbh = do "t/connect_db.pm";
$dbh->do("CREATE TABLE foo (id integer primary key, foo text)");
$dbh->do("CREATE TABLE tap (id integer primary key, code text, name text)");


my $c = t::WAFTest->new;
my $req = create_request(
    uri    => 'http://example.com/',
    method => "GET",
);
$c->request($req);
$c->config({
    include_path => [],
    dsn => [
         'dbi:SQLite:dbname=t/tmp/test.sqlite',
         '',
         '',
         { RaiseError => 1, AutoCommit => 1 },
    ],
    "Model::DBIC" => {
        schema_class => "t::MySchema",
    },
});

{
    my $schema = $c->model('DBIC')->schema;
    isa_ok $schema => "t::MySchema";
    my $foo = $schema->resultset("Foo")->create({ foo => "FOO2" });
    ok $foo;
    is $foo->foo => "FOO2";
    my $id = $foo->id;

    is $schema->storage->dbh => $c->acore->dbh, "same dbh";
}




#########################################
{
    my $schema = $c->model('DBIC')->schema;
    isa_ok $schema => "t::MySchema";
    
    my $foo = $schema->resultset("Tap")->create({ code => "D100" });
    $schema->resultset("Tap")->create({ code => "D200" });
    $schema->resultset("Tap")->create({ code => "D300" });
    
#    my $foo = $schema->resultset("Tap")->create({ code => "D100" });
    ok $foo;
    is $foo->code => "D100";
    my $id = $foo->id;
    
    my @taps = $c->model('DBIC')->resultset("Tap")->search(
        {},
        { order_by => 'code DESC' },
    );
    foreach (@taps) {
        warn ">code>>",$_->code;
    }

    is $schema->storage->dbh => $c->acore->dbh, "same dbh";
}







done_testing;
