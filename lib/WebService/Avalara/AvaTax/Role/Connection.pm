package WebService::Avalara::AvaTax::Role::Connection;

# ABSTRACT: Wrapper for Avalara AvaTax web services

use Modern::Perl '2011';    ## no critic (Modules::ProhibitUseQuotedVersion)

# VERSION
use utf8;

=head1 SYNOPSIS

    use Moo;
    with 'WebService::Avalara::AvaTax::Role::Connection';

=head1 DESCRIPTION

This role integrates
L<Avalara AvaTax web services|http://developer.avalara.com/api-docs/soap>.

=cut

use Const::Fast;
use English '-no_match_vars';
use Log::Report;
use LWPx::UserAgent::Cached;
use Scalar::Util 'blessed';
use Sys::Hostname;
use Types::Standard qw(Bool InstanceOf Str);
use URI;
use XML::Compile::SOAP::WSS;
use XML::Compile::SOAP11;
use XML::Compile::SOAP12;
use XML::Compile::WSDL11;
use XML::Compile::Transport::SOAPHTTP;
use MooX::Types::MooseLike::Email 'EmailAddressLoose';
use Moo::Role;

=attr username

The Avalara email address used for authentication. Required.

=cut

has username => ( is => 'ro', isa => EmailAddressLoose, required => 1 );

=attr password

The password used for Avalara authentication. Required.

=cut

has password => ( is => 'ro', isa => Str, required => 1 );

=attr soap_service

The SOAP service name for AvaTax. Defaults to C<TaxSvc>.

=cut

has soap_service => ( is => 'ro', isa => Str, default => 'TaxSvc' );

=attr soap_port

The SOAP service name for AvaTax. Defaults to C<TaxSvcSoap>.

=cut

has soap_port => ( is => 'ro', isa => Str, default => 'TaxSvcSoap' );

has _wss => (
    is      => 'ro',
    isa     => InstanceOf ['XML::Compile::SOAP::WSS'],
    default => sub { XML::Compile::SOAP::WSS->new },
);

has _auth => ( is => 'lazy', isa => InstanceOf ['XML::Compile::WSS'] );

sub _build__auth {
    my $self = shift;
    my $wss  = $self->_wss;
    return $wss->basicAuth( map { ( $_ => $self->$_ ) }
            qw(username password) );
}

=attr endpoint

A L<URI|URI> object indicating the AvaTax WSDL file to load. Defaults to
L<https://development.avalara.net/tax/taxsvc.wsdl>. For production API access
one should set this to L<https://avatax.avalara.net/tax/taxsvc.wsdl>.

=cut

has endpoint => (
    is     => 'lazy',
    isa    => InstanceOf ['URI'],
    coerce => sub {
        defined blessed( $_[0] )
            && $_[0]->isa('URI') ? $_[0] : URI->new( $_[0] );
    },
    default =>
        sub { URI->new('https://development.avalara.net/tax/taxsvc.wsdl') },
);

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

=attr transport

An L<XML::Compile::Transport::SOAPHTTP|XML::Compile::Transport::SOAPHTTP>
object used to make SOAP calls. By default it uses C<user_agent> along with
C<wsdl>'s C<endPoint> for the address, and adds a handler for C<POST>s to
the endpoint to add the appropriate C<SOAPAction> HTTP header.

=cut

has transport =>
    ( is => 'lazy', isa => InstanceOf ['XML::Compile::Transport::SOAPHTTP'] );

sub _build_transport {
    my $self = shift;
    my $wss  = $self->_wss;
    my $wsdl = $self->wsdl;
    my $auth = $self->_auth;

    my $user_agent  = $self->user_agent;
    my %soap_params = (
        service => $self->soap_service,
        port    => $self->soap_port,
    );
    my $endpoint_uri = URI->new( $wsdl->endPoint(%soap_params) );
    $user_agent->add_handler(
        request_prepare => sub {
            $_[0]->header( SOAPAction =>
                    $wsdl->operation( $self->_operation_name, %soap_params )
                    ->soapAction, );
        },
        (   m_method => 'POST',
            map { ( "m_$_" => $endpoint_uri->$_ ) } qw(scheme host_port path),
        ),
    );
    return XML::Compile::Transport::SOAPHTTP->new(
        address    => $endpoint_uri,
        user_agent => $self->user_agent,
    );
}

has _operation_name => ( is => 'rw', isa => Str, default => q{} );

=method call

Given an operation name and parameters, makes a SOAP call.

=cut

sub call {
    my ( $self, $operation, @params ) = @_;
    $self->_operation_name($operation);
    return $self->wsdl->call(
        $operation => {
            Profile => {
                Client => "$PROGRAM_NAME," . ( $main::VERSION // q{} ),
                Adapter => __PACKAGE__ . q{,} . ( $VERSION // q{} ),
                Machine => hostname(),
            },
            parameters => {@params},
        },
    );
}

=attr user_agent

An instance of an L<LWP::UserAgent|LWP::UserAgent> (sub-)class. You can
use your own subclass to add features such as caching or enhanced logging.

If you do not specify a C<user_agent> then we default to an
L<LWPx::UserAgent::Cached|LWPx::UserAgent::Cached> with its C<ssl_opts>
parameter set to C<< {verify_hostname => 0} >>.

=cut

has user_agent => (
    is      => 'lazy',
    isa     => InstanceOf ['LWP::UserAgent'],
    default => sub {
        LWPx::UserAgent::Cached->new( ssl_opts => { verify_hostname => 0 } );
    },
);

has wsdl => ( is => 'lazy', isa => InstanceOf ['XML::Compile::WSDL11'] );

sub _build_wsdl {
    my $self = shift;
    return XML::Compile::WSDL11->new(
        $self->user_agent->get( $self->endpoint )->content );
}

1;
