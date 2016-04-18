#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::RequiresInternet ( 'development.avalara.net' => 443 );
use Test::File::ShareDir::Module 1.000000 {
    'WebService::Avalara::AvaTax::Service::Tax' => 'shares/ServiceTax/'
};
use Const::Fast;
use List::Util 1.33 'all';
use List::MoreUtils 'uniq';
use WebService::Avalara::AvaTax;

const my @AVALARA_ENV     => qw(username password);
const my $AUTHORIZED_LIST => 'IsAuthorized,Ping';

plan skip_all => 'set environment variables ' . join q{ } =>
    map {"AVALARA_\U$_"} @AVALARA_ENV
    if not all { $ENV{"AVALARA_\U$_"} } @AVALARA_ENV;
plan tests => 1;

my $avatax
    = WebService::Avalara::AvaTax->new( map { ( $_ => $ENV{"AVALARA_\U$_"} ) }
        @AVALARA_ENV );

my ( $answer_ref, $trace ) = $avatax->is_authorized($AUTHORIZED_LIST);
is( $answer_ref->{ResultCode}, 'Success', "is_authorized $AUTHORIZED_LIST" )
    or do {
    explain $answer_ref;
    diag $trace->request->as_string
        if ref $trace->request and $trace->request->isa('HTTP::Request');
    diag $trace->responseDOM->toString(1)
        if ref $trace->responseDOM
        and $trace->responseDOM->isa('XML::LibXML::Document');
    };
