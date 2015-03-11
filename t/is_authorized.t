#!/usr/bin/env perl

use Modern::Perl;
use Test::More;
use Const::Fast;
use List::Util 1.33 'all';
use List::MoreUtils 'uniq';
use WebService::Avalara::AvaTax;

const my @AVALARA_ENV     => qw(username password);
const my $AUTHORIZED_LIST => 'IsAuthorized,Ping';

plan skip_all => 'set environment variables ' . join q{ } =>
    map {"AVALARA_\U$_"} @AVALARA_ENV
    if not all { $ENV{"AVALARA_\U$_"} } @AVALARA_ENV;
plan tests => 2;

my $avatax
    = WebService::Avalara::AvaTax->new( map { ( $_ => $ENV{"AVALARA_\U$_"} ) }
        @AVALARA_ENV );

for my $method ( map {"${_}_is_authorized"} qw(tax_svc address_svc) ) {
    my $answer_ref = $avatax->$method($AUTHORIZED_LIST);
    is( $answer_ref->{parameters}{IsAuthorizedResult}{ResultCode},
        'Success', "$method $AUTHORIZED_LIST" );
}
