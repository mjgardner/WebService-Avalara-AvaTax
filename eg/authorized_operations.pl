#!/usr/bin/env perl

use Modern::Perl;
use Const::Fast;
use List::Util 1.33 'all';
use List::MoreUtils 'uniq';
use WebService::Avalara::AvaTax;

const my @AVALARA_ENV => qw(username password);

my $avatax
    = WebService::Avalara::AvaTax->new( map { ( $_ => $ENV{"AVALARA_\U$_"} ) }
        @AVALARA_ENV );

my ( $answer_ref, $trace )
    = $avatax->is_authorized( join q{, } => uniq map { $_->name }
        $avatax->wsdl->operations );

if ( 'Success' eq $answer_ref->{parameters}{IsAuthorizedResult}{ResultCode} )
{
    say "$ENV{AVALARA_USERNAME} authorized for all SOAP operations";
}

say
    "$ENV{AVALARA_USERNAME} expires $answer_ref->{parameters}{IsAuthorizedResult}{Expires}";

say "Authorized methods:";
for my $method (
    uniq
    split /\s*,\s*/ =>
    $answer_ref->{parameters}{IsAuthorizedResult}{Operations}
    )
{
    $method =~ s/ (?<= [[:alnum:]] ) ( [[:upper:]] ) /_\l$1/xmsg;
    say lcfirst $method;
}
