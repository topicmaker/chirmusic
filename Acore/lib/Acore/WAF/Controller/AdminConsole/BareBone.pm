package Acore::WAF::Controller::AdminConsole::BareBone;

use strict;
use warnings;
use Scalar::Util qw/ blessed /;
use utf8;
use Acore::WAF::Controller::AdminConsole;
use Data::Dumper;
use Acore::WAF::Controller::AdminConsole::BareBone::Model;

use Any::Moose;
with "Acore::WAF::Controller::Role::Locatable";

no Any::Moose;
__PACKAGE__->meta->make_immutable;

my $Model = __PACKAGE__ . "::Model";
sub _auto {
    my ($self, $c, $args) = @_;

    my $parent = "Acore::WAF::Controller::AdminConsole";
    $c->forward( $parent => "_auto", $args );
    $c->forward( $parent => "is_logged_in" );

    my $dsn   = $c->config->{barebone}->{dsn} || $c->config->{dsn};
    my $model = $Model->new({
        dsn             => $dsn->[0],
        username        => $dsn->[1],
        password        => $dsn->[2],
        connect_options => $dsn->[3] || {},
    });
    $c->stash->{model} = $model;
    1;
}

sub table_list {
    my ($self, $c) = @_;

    my @tables = $c->stash->{model}->tables;
    $c->stash->{tables} = \@tables;
    $c->render("admin_console/barebone/table_list.mt");
}

sub _table_info {
    my ($self, $c, $args) = @_;

    my $name  = $args->{name};
    my $model = $c->stash->{model};
    if ($name !~ /\A[a-zA-Z0-9_]+\z/) {
        $c->error( 404 => "table not found" );
    }
    $c->stash->{columns_info} = [ $model->columns_info($name) ];
    $c->stash->{table} = $name;
    $c->stash->{primary_key_info} = $model->primary_key_info($name);
}

sub table_info {
    my ($self, $c, $args) = @_;
    $c->forward( $self => "_table_info", $args );
    $c->render("admin_console/barebone/table_info.mt");
}

sub table_select {
    my ($self, $c, $args) = @_;

    $c->forward( $self => "_table_info", $args );

    require SQL::Abstract;
    my $sql = SQL::Abstract->new;
    my $where = $c->req->param("where");
    my $order = $c->req->param("order_by") || "";
    $order .= " DESC" if $c->req->param("desc");
    my ($stmt, @bind)
        = $sql->select(
            $c->stash->{table},
            [ $c->req->param("cols") ],
            \$where,
            ($order ? \$order : undef),
        );
    $stmt .= sprintf " LIMIT %d", $c->req->param("limit")
        if $c->req->param("limit");

    $c->stash->{sql} = $stmt;
    $c->log->debug("sql: $stmt");

    my $model = $c->stash->{model};
    my $sth   = $model->dbh->prepare($stmt);
    $sth->execute(@bind);
    $c->stash->{result} = $sth;

    if ($c->req->param('csv')) {
        $c->forward( $self => "_table_select_csv" );
    }
    else {
        # html output
        $c->render("admin_console/barebone/table_info.mt");
        $c->fillform;
    }
}

sub table_row {
    my ($self, $c, $args) = @_;

    $c->forward( $self => "_table_info", $args );
    my $model = $c->stash->{model};
    my $query = {};
    my @pkey  = keys %{ $c->stash->{primary_key_info} };
    for my $key ( @pkey ) {
        $c->error(404, "key param '$key' is not defined" )
            unless defined $c->req->param($key);
        $query->{$key} = $c->req->param($key);
    }

    my $result = $model->search(
        $c->stash->{table},
        $query,
        { select => "*", limit => 1, row_class => "DBIx::Skinny::Row" },
    );
    my $row = $result->first;
    $c->error(404, "no row") unless $row;

    my $data = $row->{row_data};
    for my $col ( keys %{ $row->{row_data} } ) {
        $data->{$col} = Encode::decode_utf8($data->{$col});
    }

    require Acore::WAF::View::JSON;
    my $view = Acore::WAF::View::JSON->new;
    $c->forward( $view => "process", $row->{row_data} );
}

sub _table_select_csv {
    my ($self, $c) = @_;

    my $result   = $c->stash->{result};
    my @cols     = $c->req->param("cols");
    my $filename = $c->stash->{table} . ".csv";

    $c->res->header(
        "Content-Type"        => "text/csv; charset=utf-8",
        "Content-Disposition" => "attachment; filename=$filename",
    );

    my $res_handler
        = Acore::WAF::Controller::AdminConsole::BareBone::CSV
            ->new(\@cols, $result);

    $c->res->body($res_handler);
}


package Acore::WAF::Controller::AdminConsole::BareBone::CSV;

sub new {
    my $class = shift;
    bless {
        cols   => $_[0],
        result => $_[1],
        count  => 0,
    }, $class;
}

sub getline {
    my $self = shift;
    my @data;
    if ( $self->{count}++ == 0 ) {
        @data = @{ $self->{cols} };
    }
    else {
        my $row = $self->{result}->fetchrow_hashref;
        return unless $row;
        for my $col (@{ $self->{cols} }) {
            my $col_data = $row->{$col};
            $col_data =~ s{"}{""}g;
            push @data, $col_data;
        }
    }
    return join(",", map { qq{"$_"} } @data) . "\x0D\x0A";
}

sub close {
    my $self = shift;
    delete $self->{result};
    1;
}

1;
