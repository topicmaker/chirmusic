package MySchema;
use strict;
use warnings;
use Carp qw/ croak carp /;
use utf8;
use iTunesAPI;
use bitlyAPI;
use Data::Dumper;
use base qw/ DBIx::Class::Schema::Loader /;
__PACKAGE__->loader_options(
    relationships => 1,
    debug         => 0,
    naming        => 'twiitunes',
);


sub create_twiitunes_music {
    my $self = shift;
    my $prms = shift;
    return if !$prms->{itunes_trackid};

    my $twiitunes_music;

    # iTunesAPI
    my $itunes_json_object = search_musictrack_by_trackid({
        trackid     => $prms->{itunes_trackid},
        api_params  => {
            country     => $prms->{itunes_country},
        },
    });
    if ( $itunes_json_object->{resultCount} != 1 ) {
        carp("iTunesAPI search_musictrack_by_trackid error." );
        return;
    }

    # bitlyAPI
    my $bitly_json_object = generate_shorten_url({
        url => $prms->{bitly_long_url},
    });
    if ( !$bitly_json_object ) {
        carp("bitlyAIP generate_shorten_url error." );
        return;
    }

    # create TwiitunesMusic
    my $itn = $itunes_json_object->{results}->[0];

    eval {
        $twiitunes_music = $self->resultset("TwiitunesMusic")->create({
            itunes_trackid          => $itn->{trackId},
            itunes_trackname        => $itn->{trackName},
            itunes_collectionname   => $itn->{collectionName},
            itunes_collectionid     => $itn->{collectionId},
            itunes_artistname       => $itn->{artistName},
            itunes_artistid         => $itn->{artistId},
            itunes_trackviewurl     => $itn->{trackViewUrl},
            itunes_previewurl       => $itn->{previewUrl},
            itune_artworkurl100     => $itn->{artworkUrl100},
            shorten_url             => $bitly_json_object->{data}->{url},
        });
    };
    if ($@) {
        carp("TwiitunesMusic create error : $@" );
        return;
    }

    return $twiitunes_music;
}

1;

# 　
