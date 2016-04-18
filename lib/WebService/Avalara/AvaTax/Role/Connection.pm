package WebService::Avalara::AvaTax::Role::Connection;

# ABSTRACT: Common attributes and methods for AvaTax

use strict;
use warnings;

# VERSION
use utf8;

=head1 SYNOPSIS

    use Moo;
    with 'WebService::Avalara::AvaTax::Role::Connection';

=head1 DESCRIPTION

This role factors out the common attributes and methods used by the
Avalara AvaTax (C<http://developer.avalara.com/api-docs/soap>)
web service interface.

=cut

use Log::Report;
use LWP::UserAgent;
use LWPx::UserAgent::Cached;
use Moo::Role;
use Mozilla::CA;
use Types::Standard qw(Bool InstanceOf Str);
use namespace::clean;

=attr username

The Avalara AvaTax Admin Console user name. Usually an email address. Required.

=cut

has username => ( is => 'ro', isa => Str, required => 1 );

=attr password

The password used for Avalara authentication. Required.

=cut

has password => ( is => 'ro', isa => Str, required => 1 );

=attr use_wss

A boolean value that indicates whether or not to use WSS security tokens in
the SOAP header or to use those specified in Avalara's alternate security WSDL.
Defaults to true. Normally you should leave this alone unless your application
does not work correctly with WSS.

=cut

has use_wss => ( is => 'rwp', isa => Bool, default => 1 );

=attr is_production

A boolean value that indicates whether to connect to the production AvaTax
services (true) or development (false). Defaults to false.

=cut

has is_production => ( is => 'ro', isa => Bool, default => 0 );

=attr debug

When set to true, the L<Log::Report|Log::Report> dispatcher used by
L<XML::Compile|XML::Compile> and friends is set to I<DEBUG> mode.

=cut

has debug => (
    is      => 'ro',
    isa     => Bool,
    default => 0,
    trigger =>
        sub { dispatcher( mode => ( $_[1] ? 'DEBUG' : 'NORMAL' ), 'ALL' ) },
);

=attr user_agent

An instance of an L<LWP::UserAgent|LWP::UserAgent> (sub-)class. You can
use your own subclass to add features such as caching or enhanced logging.

If you do not specify a C<user_agent> then we default to an instance of
L<LWPx::UserAgent::Cached|LWPx::UserAgent::Cached>. Note that we also set
the C<HTTPS_CA_FILE> environment variable to the result from
L<Mozilla::CA::SSL_ca_file|Mozilla::CA> in order to correctly
resolve certificate names.

=cut

BEGIN {
    ## no critic (Subroutines::ProhibitCallsToUnexportedSubs)
    ## no critic (Variables::RequireLocalizedPunctuationVars)
    $ENV{HTTPS_CA_FILE} = Mozilla::CA::SSL_ca_file();
}
has user_agent => (
    is      => 'lazy',
    isa     => InstanceOf ['LWP::UserAgent'],
    default => sub { LWPx::UserAgent::Cached->new },
);

1;
