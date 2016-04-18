package WebService::Avalara::AvaTax::Role::Service;

# ABSTRACT: Common attributes and methods for AvaTax services

use strict;
use warnings;

# VERSION
use utf8;

=head1 SYNOPSIS

    use Moo;
    with 'WebService::Avalara::AvaTax::Role::Service';

=head1 DESCRIPTION

This role factors out the common attributes and methods used by the
Avalara AvaTax (C<http://developer.avalara.com/api-docs/soap>)
web service interface.

=cut

use Moo::Role;
use Types::Standard qw(Bool CodeRef HashRef InstanceOf Str);
use Types::URI 'Uri';
use URI;
use XML::Compile::SOAP::WSS;
use XML::Compile::Transport::SOAPHTTP;
use XML::Compile::WSDL11;
use XML::Compile::WSS;
use namespace::clean;

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

has port => ( is => 'lazy', isa => Str );

=attr service

The SOAP service name used in the WSDL file at L</uri>.
Consumer classes are expected to set this attribute.

=cut

has service => ( is => 'ro', isa => Str );

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

has clients => (
    is       => 'lazy',
    isa      => HashRef [CodeRef],
    init_arg => undef,
);

sub _build_clients {
    my $self = shift;

    my ( $wss, $auth );
    if ( $self->use_wss ) { $wss = XML::Compile::SOAP::WSS->new }
    my $wsdl = $self->wsdl;
    if ( $self->use_wss ) {
        $auth = $wss->basicAuth( map { ( $_ => $self->$_ ) }
                qw(username password) );
    }

    my %soap_params = map { ( $_ => $self->$_ ) } qw(port service);
    my %client_params = (
        transporter => $self->_transport->compileClient,
        %soap_params,
    );
    return {
        map { ( $_ => $wsdl->compileClient( $_, %client_params ) ) }
        map { $_->name } $wsdl->operations(%soap_params),
    };
}

has _current_operation_name => ( is => 'rw', isa => Str, default => q{} );

has _transport =>
    ( is => 'lazy', isa => InstanceOf ['XML::Compile::Transport'] );

sub _build__transport {
    my $self = shift;

    my %soap_params  = map { ( $_ => $self->$_ ) } qw(port service);
    my $wsdl         = $self->wsdl;
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
