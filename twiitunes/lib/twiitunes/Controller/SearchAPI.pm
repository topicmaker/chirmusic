package twiitunes::Controller::SearchAPI;

use strict;
use warnings;
use utf8;
use Data::Dumper;
use iTunesAPI;


sub _auto {
    my ($self, $c, $args) = @_;

    if ( $c->debug ) {
        $iTunesAPI::is_debug = 1;
    }

    1;
}

sub search_itunes_by_keyword {
    my ($self, $c, $args) = @_;

    # validate
    my $keyword = $args->{keyword};
    if (length($keyword) > $c->config->{search_validate}->{keyword}->{length} ) {
        $c->log->error('keyword error. length too long : ' . $keyword );
        return $c->forward( $c->view("JSON") => "process", {} );
    }

    my $page = $args->{page};
    my $pageregex = $c->config->{search_validate}->{page}->{regex};
    if ( $page !~ /$pageregex/o ) {
        $c->log->warning('page regex error : ' . $page );
        $page = 1;
    }
    if ( ( $page <= 0 ) || ($c->config->{search_validate}->{page}->{max} < $page) ) {
        $c->log->warning('page max value error : ' . $page );
        $page = 1;
    }

    my @result;
    my $page_row = $c->is_smartphone() ? $c->config->{search_itunes}->{page_row}->{smartphone}
                                       : $c->config->{search_itunes}->{page_row}->{default};
    my $itunes_json_object  = search_musictrack_by_term({
                                    term        => $keyword,
                                    api_params  => {
                                        country     => $c->is_lang_jp(),
                                        limit       => $page * $page_row,
                                    },
                                });

    if ($itunes_json_object->{resultCount} >= 1 ) {
        @result = splice(@{ $itunes_json_object->{results} }, (($page - 1) * $page_row), $page_row);
    }
    else {
        $c->log->info("search itunes count <= 0. keyword: $keyword");
    }

    $c->forward( $c->view("JSON") => "process", \@result );
}


# 　
1;
