package WebService::Avalara::AvaTax::Service::Tax;

# ABSTRACT: Avalara AvaTax tax engine service via SOAP

use Modern::Perl '2011';    ## no critic (Modules::ProhibitUseQuotedVersion)

# VERSION
use utf8;

=head1 SYNOPSIS

    use WebService::Avalara::AvaTax::Service::Tax;

    my $avatax = WebService::Avalara::AvaTax::Service::Tax->new(
        username => 'avalara@example.com',
        password => 'sekrit',
    );
    my ( $answer_ref, $trace ) = $avatax->call('Ping');

=head1 DESCRIPTION

This class implements basic support for the
L<Avalara AvaTax|http://developer.avalara.com/api-docs/soap>
tax engine service using SOAP. Most of its mechanics are in
L<WebService::Avalara::AvaTax::Role::Connection|WebService::Avalara::AvaTax::Role::Connection>,
with defaults for certain attributes as listed below.

=cut

use File::ShareDir::ProjectDistDir 'dist_file';
use Moo;
use URI;
use XML::Compile::SOAP11;
use XML::Compile::SOAP12;
use XML::Compile::WSDL11;
use namespace::clean;
with qw(
    WebService::Avalara::AvaTax::Role::Connection
    WebService::Avalara::AvaTax::Role::Service
);

=attr uri

The L<URI|URI> of the WSDL file used to define the web service.
Defaults to C</tax/taxsvc.wsdl>, with the URI base either
L<https://avatax.avalara.net/> if
L<is_production|WebService::Avalara::AvaTax::Role::Connection/is_production>
returns true, or L<https://development.avalara.net/> if it returns false.

Note that if
L<use_wss|WebService::Avalara::AvaTax::Role::Connection/use_wss>
is false, the alternate security WSDL file C</tax/taxsvcaltsec.wsdl>
will be used instead.

=cut

has '+uri' => (
    default => sub {
        my $self = shift;
        URI->new_abs( '/tax/taxsvc'
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
        sub { 'TaxSvc' . ( $_[0]->use_wss ? q{} : 'AltSec' ) . 'Soap' }, );

=attr service

The SOAP service name used in the WSDL file at L</uri>.
Defaults to C<AddressSvc>.

=cut

has '+service' => ( default => 'TaxSvc' );

=head1 WORKAROUNDS FOR INCORRECT AVALARA RESPONSES

As of this writing the Avalara SOAP API returns responses that are
inconsistent with the WSDL document provided. Specifically, the C<TaxIncluded>
and C<GeocodeType> fields in the C<GetTaxResponse> are wrongly placed in their
sequences of fields. This module adds an overlay to the Avalara tax service
WSDL file that attempts to work around these problems so that the responses
may be successfully parsed.

=cut

has '+wsdl' => (
    default => sub {
        my $self = shift;
        my $wsdl = XML::Compile::WSDL11->new(
            $self->user_agent->get( $self->uri )->content );
        $wsdl->addWSDL(
            dist_file( 'WebService-Avalara-AvaTax', 'taxsvc_patch.wsdl' ) );
        return $wsdl;
    },
);

1;
