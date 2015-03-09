#!/usr/bin/env perl

use Modern::Perl;
use Const::Fast;
use WebService::Avalara::AvaTax;

const my @AVALARA_ENV => qw(username password);
const my %SOAP_PARAMS => ( service => 'TaxSvc', port => 'TaxSvcSoap' );
my $avatax
    = WebService::Avalara::AvaTax->new( map { ( $_ => $ENV{"AVALARA_\U$_"} ) }
        @AVALARA_ENV );

say $avatax->wsdl->explain( $_, PERL => 'INPUT', recurse => 1, %SOAP_PARAMS )
    for map { $_->name } $avatax->wsdl->operations;
