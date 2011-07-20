package twiitunes::Model::Account;
use strict;
use warnings;
use Any::Moose;
use utf8;
use Acore::Authentication::Password;        # 必要

extends 'Acore::User';

has "twitter_screen_name"       => ( is => "rw" );
has "twitter_profile_image_url" => ( is => "rw" );


1;
