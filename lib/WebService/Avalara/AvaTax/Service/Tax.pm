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

use Moo;
use URI;
use XML::Compile::SOAP11;
use XML::Compile::SOAP12;
use namespace::clean;
with 'WebService::Avalara::AvaTax::Role::Connection';

=attr uri

The L<URI|URI> of the WSDL file used to define the web service.
Defaults to C</tax/taxsvc.wsdl>, with the URI base either
L<https://avatax.avalara.net/> if
L<is_production|WebService::Avalara::AvaTax::Role::Connection/is_production>
returns true, or L<https://development.avalara.net/> if it returns false.

=cut

has '+uri' => (
    default => sub {
        URI->new_abs( '/tax/taxsvc.wsdl' => 'https://'
                . ( $_[0]->is_production ? 'avatax' : 'development' )
                . '.avalara.net/' );
    },
);

=attr port

The SOAP port identifier (not to be confused with the TCP/IP port) used in the
WSDL file at L</uri>.
Defaults to C<AddressSvcSoap>.

=cut

has '+port' => ( default => 'TaxSvcSoap' );

=attr service

The SOAP service name used in the WSDL file at L</uri>.
Defaults to C<AddressSvc>.

=cut

has '+service' => ( default => 'TaxSvc' );

1;
