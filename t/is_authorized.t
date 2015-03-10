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
plan tests => 1;

my $avatax
    = WebService::Avalara::AvaTax->new( map { ( $_ => $ENV{"AVALARA_\U$_"} ) }
        @AVALARA_ENV );

my ( $answer_ref, $trace ) = $avatax->is_authorized($AUTHORIZED_LIST);

is( $answer_ref->{parameters}{IsAuthorizedResult}{ResultCode} => 'Success',
    $AUTHORIZED_LIST
);

diag('tested authorized methods:');
for my $method (
    uniq
    split /\s*,\s*/ =>
    $answer_ref->{parameters}{IsAuthorizedResult}{Operations}
    )
{
    $method =~ s/ (?<= [[:alnum:]] ) ( [[:upper:]] ) /_\l$1/xmsg;
    diag( lcfirst $method );
}
diag('see eg/authorized_operations.pl to retrieve full list');
