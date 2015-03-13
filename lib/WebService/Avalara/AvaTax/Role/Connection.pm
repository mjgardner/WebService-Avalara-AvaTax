package WebService::Avalara::AvaTax::Role::Connection;

# ABSTRACT: Common attributes and methods for AvaTax

use Modern::Perl '2011';    ## no critic (Modules::ProhibitUseQuotedVersion)

# VERSION
use utf8;

=head1 SYNOPSIS

    use Moo;
    with 'WebService::Avalara::AvaTax::Role::Connection';

=head1 DESCRIPTION

This role factors out the common attributes and methods used by the
L<Avalara AvaTax|http://developer.avalara.com/api-docs/soap>
web service interface.

=cut

use Log::Report;
use LWP::UserAgent;
use LWPx::UserAgent::Cached;
use Moo::Role;
use MooX::Types::MooseLike::Email 'EmailAddressLoose';
use Mozilla::CA;
use Types::Standard qw(Bool InstanceOf Str);
use Types::URI 'Uri';
use URI;
use XML::Compile::SOAP::WSS;
use XML::Compile::Transport::SOAPHTTP;
use XML::Compile::WSDL11;
use XML::Compile::WSS;
use namespace::clean;

=attr username

The Avalara email address used for authentication. Required.

=cut

has username => ( is => 'ro', isa => EmailAddressLoose, required => 1 );

=attr password

The password used for Avalara authentication. Required.

=cut

has password => ( is => 'ro', isa => Str, required => 1 );

=attr is_production

A boolean value that indicates whether to connect to the production AvaTax
services (true) or development (false). Defaults to false.

=cut

has is_production => ( is => 'ro', isa => Bool, default => 0 );

=attr uri

The L<URI|URI> of the WSDL file used to define the web service.
Consumer classes are expected to set this attribute.
As a convenience this can also be set with anything that
L<Types::URI|Types::URI> can coerce into a C<Uri>.

=cut

has uri => ( is => 'lazy', isa => Uri, coerce => 1 );

=attr port

The SOAP port identifier (not to be confused with the TCP/IP port) used in the
WSDL file at L</uri>.
Consumer classes are expected to set this attribute.

=cut

has port => ( is => 'ro', isa => Str );

=attr service

The SOAP service name used in the WSDL file at L</uri>.
Consumer classes are expected to set this attribute.

=cut

has service => ( is => 'ro', isa => Str );

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
the C<HTTPS_CA_FILE> environment variable to the contents of
L<Mozilla::CA::SSL_ca_file|Mozilla::CA/SSL_ca_file> in order to correctly
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

=attr wsdl

After construction, you can retrieve the created
L<XML::Compile::WSDL11|XML::Compile::WSDL11> instance.

Example:

    my $wsdl = $avatax->wsdl;
    my @soap_operations = map { $_->name } $wsdl->operations;

=cut

has wsdl => (
    is       => 'lazy',
    isa      => InstanceOf ['XML::Compile::WSDL11'],
    init_arg => undef,
    default  => sub {
        XML::Compile::WSDL11->new(
            $_[0]->user_agent->get( $_[0]->uri )->content );
    },
);

has _wss => (
    is       => 'ro',
    isa      => InstanceOf ['XML::Compile::SOAP::WSS'],
    default  => sub { XML::Compile::SOAP::WSS->new },
    init_arg => undef,
);

has _auth => (
    is       => 'lazy',
    isa      => InstanceOf ['XML::Compile::WSS'],
    init_arg => undef,
);

sub _build__auth {
    my $self = shift;
    my $wss  = $self->_wss;
    return $wss->basicAuth( map { ( $_ => $self->$_ ) }
            qw(username password) );
}

has _current_operation_name => ( is => 'rw', isa => Str, default => q{} );

has _transport => (
    is       => 'lazy',
    isa      => InstanceOf ['XML::Compile::Transport::SOAPHTTP'],
    init_arg => undef,
);

sub _build__transport {
    my $self = shift;

    my $wss  = $self->_wss;
    my $wsdl = $self->wsdl;
    my $auth = $self->_auth;

    my %soap_params  = map { ( $_ => $self->$_ ) } qw(port service);
    my $endpoint_uri = URI->new( $wsdl->endPoint(%soap_params) );
    my $user_agent   = $self->user_agent;

    $user_agent->add_handler(
        request_prepare => sub {
            $_[0]->header(
                SOAPAction =>
                    $wsdl->operation( $self->_current_operation_name,
                    %soap_params )->soapAction,
            );
        },
        (   m_method => 'POST',
            map { ( "m_$_" => $endpoint_uri->$_ ) } qw(scheme host_port path),
        ),
    );

    return XML::Compile::Transport::SOAPHTTP->new(
        address    => $endpoint_uri,
        user_agent => $user_agent,
    );
}

1;
