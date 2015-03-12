#!/usr/bin/env perl

use Modern::Perl;
use Test::More;
use Test::RequiresInternet ( 'development.avalara.net' => 443 );
use Const::Fast;
use List::Util 1.33 'all';
use WebService::Avalara::AvaTax;

const my @AVALARA_ENV => qw(username password);

plan skip_all => 'set environment variables ' . join q{ } =>
    map {"AVALARA_\U$_"} @AVALARA_ENV
    if not all { $ENV{"AVALARA_\U$_"} } @AVALARA_ENV;
plan tests => 2;

my $avatax = new_ok(
    'WebService::Avalara::AvaTax' =>
        [ map { ( $_ => $ENV{"AVALARA_\U$_"} ) } @AVALARA_ENV ],
    'AvaTax',
);

my $answer_ref = $avatax->ping;
is( $answer_ref->{parameters}{PingResult}{ResultCode}, 'Success', 'ping' );
