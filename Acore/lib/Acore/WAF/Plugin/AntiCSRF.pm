package Acore::WAF::Plugin::AntiCSRF;

use strict;
use warnings;
use Any::Moose "::Role";

our $base    = qq{anti_csrf};
our $VERSION = '0.21.1';
my $sha256_hex;

BEGIN {
    eval "use Digest::SHA;";  ## no critic
    if ($@) {
        require Digest::SHA::PurePerl;
        $sha256_hex = sub { Digest::SHA::PurePerl::sha256_hex($_[0]) };
    }
    else {
        $sha256_hex = sub { Digest::SHA::sha256_hex($_[0]) };
    }
};

before _dispatch => sub {
    my $c = shift;
    $c->config->{$base}->{param} ||= 'onetime_token';
};

sub onetime_token {
    my $c = shift;
    unless ( $c->session->get("onetime_token") ) {
        my $token = $sha256_hex->( $c->session->session_id . rand() . time );
        $c->session->set("onetime_token" => $token);
    }

    return $c->session->get("onetime_token");
}

sub csrf_proof {
    my $c = shift;
    my $config = $c->config;

    if ( $c->req->method ne 'POST' ){
        $c->log->error(__PACKAGE__. qq{: POST method is required.});
        return;
    }

    my $name  = $config->{anti_csrf}->{param};
    my $value = $c->req->param($name) || '';
    my $match = $c->session->get("onetime_token");

    if ( $value eq '' || $value ne $match ) {
        $c->log->error(__PACKAGE__. qq{: CSRF detected. "$value" is not match "$match".});
        return;
    }
    $c->req->param($name, undef);   # for no fill in form.
    1;
}

1;

__END__

=head1 NAME

 Acore::WAF::Plugin::AntiCSRF - Acore::WAF Plugin for CSRF protection

=head1 SYNOPSIS

  package AcoreApp;
  extends 'Acore::WAF';
  my @plugins = qw/
      Session
      AntiCSRF
  /;
  __PACKAGE__->setup(@plugins);


  Text::MicroTemplate
  <form action="<?= $c->uri_for('/foo/bar') ?>" method="post">
    <input type="hidden" name="<?= $c->config->{anti_csrf}->{param} ?>" value="<?= $c->onetime_token ?>">
    ....
  </form>

  Template::Toolkit
  <form action="[% base | html %]foo/bar/" method="post">
    <input type="hidden" name="[% c.config.anti_csrf.param | html %]" value="[% c.onetime_token | html %]">
    ....
  </form>


  package AcoreApp::Controller::Foo;

  sub bar_POST {
    my ($self, $c) = @_;

    unless ( $c->csrf_proof ) { # post method required
         # CSRF detected!
         return;
    }

  }



=head1 DESCRIPTION

This module is Acore::WAF Plugin for CSRF protection.

=head1 CONFIG

  anti_csrf:
    param: param_name     # for hidden's name

=head1 FUNCTIONS

=head2 onetime_token

Returns token for CSRF protection.

  $c->onetime_token();

=head2 csrf_proof

Check onetime_token.

Returns 1 if OK.

=cut

=head1 AUTHOR

FUJIWARA Shunichiro, C<< <fujiwara at topicmaker.com> >>

=cut
