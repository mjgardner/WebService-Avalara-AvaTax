package WebService::Avalara::AvaTax::Service::Address;

# ABSTRACT: Avalara AvaTax address validation service via SOAP

use strict;
use warnings;

# VERSION
use utf8;

=head1 SYNOPSIS

    use WebService::Avalara::AvaTax::Service::Address;

    my $avatax = WebService::Avalara::AvaTax::Service::Address->new(
        username => 'avalara@example.com',
        password => 'sekrit',
    );
    my ( $answer_ref, $trace ) = $avatax->call('Ping');

=head1 DESCRIPTION

This class implements basic support for the
Avalara AvaTax (C<http://developer.avalara.com/api-docs/soap>)
address validation web service using SOAP. Most of its mechanics are in
L<WebService::Avalara::AvaTax::Role::Connection|WebService::Avalara::AvaTax::Role::Connection>,
with defaults for certain attributes as listed below.

=cut

use Moo;
use URI;
use XML::Compile::SOAP11;
use XML::Compile::SOAP12;
use namespace::clean;
with qw(
    WebService::Avalara::AvaTax::Role::Connection
    WebService::Avalara::AvaTax::Role::Service
    WebService::Avalara::AvaTax::Role::Dumper
);

=attr uri

The L<URI|URI> of the WSDL file used to define the web service.
Defaults to C</address/addresssvc.wsdl>, with the URI base either
C<https://avatax.avalara.net/> if
L<is_production|WebService::Avalara::AvaTax::Role::Connection/is_production>
returns true, or C<https://development.avalara.net/> if it returns false.

Note that if
L<use_wss|WebService::Avalara::AvaTax::Role::Connection/use_wss>
is false, the alternate security WSDL file C</address/addresssvcaltsec.wsdl>
will be used instead.

=cut

has '+uri' => (
    default => sub {
        my $self = shift;
        URI->new_abs( '/address/addresssvc'
                . ( $self->use_wss ? q{} : 'altsec' )
                . '.wsdl' => 'https://'
                . ( $self->is_production ? 'avatax' : 'development' )
                . '.avalara.net/' );
    },
);

=attr port

The SOAP port identifier (not to be confused with the TCP/IP port) used in the
WSDL file at L</uri>.
Defaults to C<AddressSvcSoap>.

=cut

has '+port' => ( default =>
        sub { 'AddressSvc' . ( $_[0]->use_wss ? q{} : 'AltSec' ) . 'Soap' },
);

=attr service

The SOAP service name used in the WSDL file at L</uri>.
Defaults to C<AddressSvc>.

=cut

has '+service' => ( default => 'AddressSvc' );

=for Pod::Coverage BUILDARGS

=cut

1;
