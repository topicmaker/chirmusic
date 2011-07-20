package bitlyAPI;

use strict;
use warnings;
use Carp qw/ croak carp /;
use utf8;
use Data::Dumper;
use URI;
use JSON::Syck;
$JSON::Syck::ImplicitUnicode = 1;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(generate_shorten_url);

our $VERSION    = 0.1;
our $is_debug   = 0;

# bit.ly account
our $bitly_api_url  = "http://api.bit.ly/v3/shorten";
our $login          = "chirmusic";
our $api_key        = "R_ec38c49bb67e7fdcbc006873cd2a45d0";


sub generate_shorten_url {
    my $prms = shift;
    return if !$prms->{url};

    utf8::decode($prms->{url});
    my $uri = URI->new($bitly_api_url);
    $uri->query_form(
        login   => $login,
        apiKey  => $api_key,
        format  => "json",
        longUrl => $prms->{url},
    );
    carp("query uri : " . $uri->as_string) if $is_debug;

    require LWP::UserAgent;
    my $ua      = LWP::UserAgent->new;
    my $ua_res  = $ua->get($uri->as_string);
    if ( ! $ua_res->is_success ) {
        carp("bit.ly API access error : " . $ua_res->status_line);
        return;
    }

    my $json_object = JSON::Syck::Load($ua_res->decoded_content);
    if ( ($json_object->{status_code} eq '200') && ($json_object->{status_txt} eq 'OK') ) {
        $json_object->{data}->{url} =~ s/\\//g;
        return $json_object;
    }
    else {
        carp("bit.ly API data error : " . Dumper($json_object));
        return;
    }
}


1;
