package iTunesAPI;

use strict;
use warnings;
use Carp qw/ croak carp /;
use utf8;
use Data::Dumper;
use URI;
use Unicode::Escape;
use JSON::Syck;
$JSON::Syck::ImplicitUnicode = 1;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(search_musictrack_by_term search_musictrack_by_trackid);

our $VERSION = 0.1;
our $is_debug = 0;


sub search_musictrack_by_term {
    my $prms = shift;
    return if !$prms->{term};

    utf8::decode($prms->{term});
    my $term = $prms->{term};
    $term =~ s/　+|\s+/ /g;

    my $uri = URI->new('http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsSearch');

    my %uri_params;
    $uri_params{entity}     = "musicTrack";
    $uri_params{term}       = $term;
    map { $uri_params{$_} = $prms->{api_params}->{$_} } keys %{$prms->{api_params}}
        if $prms->{api_params};
    $uri->query_form(%uri_params);
    carp("query uri : " . $uri->as_string) if $is_debug;

    return _request_itunes_api($uri->as_string);
}

sub search_musictrack_by_trackid {
    my $prms = shift;
    return if !$prms->{trackid};

    utf8::decode($prms->{trackid});
    my $uri = URI->new('http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsLookup');

    my %uri_params;
    $uri_params{entity}     = "musicTrack";
    $uri_params{limit}      = 1;
    $uri_params{id}         = $prms->{trackid};
    map { $uri_params{$_} = $prms->{api_params}->{$_} } keys %{$prms->{api_params}}
        if $prms->{api_params};
    $uri->query_form(%uri_params);
    carp("query uri : " . $uri->as_string) if $is_debug;

    return _request_itunes_api($uri->as_string);
}

sub _request_itunes_api {
    my $uri_string = shift;

    require LWP::UserAgent;
    my $ua      = LWP::UserAgent->new;
    my $ua_res  = $ua->get($uri_string);
    if ( ! $ua_res->is_success ) {
        carp("iTunes API error : " . $ua_res->status_line);
        return;
    }

    my $json_object = JSON::Syck::Load(Unicode::Escape::unescape($ua_res->decoded_content));
    if ($json_object->{resultCount} >= 1) {
        foreach my $j (@{$json_object->{results}}) {
            $j->{$_} =~ s/\\// for (qw/trackViewUrl previewUrl artworkUrl100/);
        }
    }

    return $json_object;
}

1;
