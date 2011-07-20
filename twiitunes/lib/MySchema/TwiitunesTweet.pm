package MySchema::TwiitunesTweet;
use strict;
use warnings;
use Any::Moose;
use utf8;
use Data::Dumper;

sub json_hash {
    my ($self, $prms) = @_;
    my $tweet_length  = $prms->{tweet_length};

    my %data;
    $data{$_} = $self->get_column($_) for $self->result_source->columns;
    $data{short_description} = substr($self->get_column("description"), 0, $tweet_length);

    foreach my $rel_column (qw/ twiitunes_music twiitunes_account /) {
        undef $data{$rel_column};
        $data{$rel_column}->{$_} = $self->$rel_column->get_column($_)
            for $self->$rel_column->result_source->columns;
    }

    my $twiitunes_tweets_count = $self->result_source->schema->resultset("TwiitunesTweet")->search(
        { twiitunes_music => $self->twiitunes_music->id }, {},
    )->count;
    $data{tweets_count} = $twiitunes_tweets_count;

    \%data;
}

#　
1;
