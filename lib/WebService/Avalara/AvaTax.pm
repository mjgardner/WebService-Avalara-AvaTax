package WebService::Avalara::AvaTax;

# ABSTRACT: Avalara SOAP interface as compiled Perl methods

use Modern::Perl '2011';    ## no critic (Modules::ProhibitUseQuotedVersion)

our $VERSION = '0.007';     # TRIAL VERSION
use utf8;

#pod =head1 SYNOPSIS
#pod
#pod     use WebService::Avalara::AvaTax;
#pod     my $avatax = WebService::Avalara::AvaTax->new(
#pod         username => 'avalara@example.com',
#pod         password => 'sekrit',
#pod     );
#pod     my $answer_ref = $avatax->ping;
#pod
#pod =head1 DESCRIPTION
#pod
#pod This class provides a Perl method API for
#pod L<Avalara AvaTax|http://developer.avalara.com/api-docs/soap>
#pod web services. The first call to any AvaTax SOAP operation uses
#pod L<XML::Compile::WSDL11|XML::Compile::WSDL11> to compile and execute against the
#pod specified Avalara AvaTax service; subsequent calls can vary the
#pod parameters but will use the same compiled code.
#pod
#pod =cut

use Carp;
use Const::Fast;
use English '-no_match_vars';
use Log::Report;
use LWPx::UserAgent::Cached;
use Moo;
use MooX::Types::MooseLike::Email 'EmailAddressLoose';
use Package::Stash;
use Scalar::Util 'blessed';
use Sys::Hostname;
use Types::Standard qw(ArrayRef Bool HashRef InstanceOf Str);
use Types::URI 'Uri';
use URI;
use XML::Compile::SOAP::WSS;
use XML::Compile::SOAP11;
use XML::Compile::SOAP12;
use XML::Compile::WSDL11;
use XML::Compile::Transport::SOAPHTTP;
use MooX::Struct EndpointLocator => [
    wsdl_uri => [ is => 'ro', isa => Uri, required => 1, coerce => 1 ],
    port     => [ is => 'ro', isa => Str, required => 1 ],
    service  => [ is => 'ro', isa => Str, required => 1 ],
];
use namespace::clean;

#pod =method new
#pod
#pod Builds a new AvaTax web service client. See the L</ATTRIBUTES> section for
#pod description of its named parameters.
#pod
#pod =attr username
#pod
#pod The Avalara email address used for authentication. Required.
#pod
#pod =cut

has username => ( is => 'ro', isa => EmailAddressLoose, required => 1 );

#pod =attr password
#pod
#pod The password used for Avalara authentication. Required.
#pod
#pod =cut

has password => ( is => 'ro', isa => Str, required => 1 );

#pod =attr is_production
#pod
#pod A boolean value that indicates whether to connect to the production AvaTax
#pod services (true) or development (false). Defaults to false.
#pod
#pod =cut

has is_production => ( is => 'ro', isa => Bool, default => 0 );

{
    ## no critic (Subroutines::ProhibitCallsToUndeclaredSubs)
    ## no critic (Modules::RequireExplicitInclusion)
    has _endpoints =>
        ( is => 'lazy', isa => ArrayRef [ InstanceOf [EndpointLocator] ] );
    const my %SOAP_PARAMS => (
        address => { port => 'AddressSvcSoap', service => 'AddressSvc' },
        tax     => { port => 'TaxSvcSoap',     service => 'TaxSvc' },
    );

    sub _build__endpoints {
        my $self = shift;
        my $uri_base
            = 'https://'
            . ( $self->is_production ? 'avatax' : 'development' )
            . '.avalara.net';
        return [
            map { EndpointLocator->new($_) } (
                {   wsdl_uri => "$uri_base/address/addresssvc.wsdl",
                    %{ $SOAP_PARAMS{address} },
                },
                {   wsdl_uri => "$uri_base/tax/taxsvc.wsdl",
                    %{ $SOAP_PARAMS{tax} },
                },
            ),
        ];
    }
}

#pod =attr debug
#pod
#pod When set to true, the L<Log::Report|Log::Report> dispatcher used by
#pod L<XML::Compile|XML::Compile> and friends is set to I<DEBUG> mode.
#pod
#pod =cut

has debug => (
    is      => 'ro',
    isa     => Bool,
    default => 0,
    trigger =>
        sub { dispatcher( mode => ( $_[1] ? 'DEBUG' : 'NORMAL' ), 'ALL' ) },
);

#pod =attr user_agent
#pod
#pod An instance of an L<LWP::UserAgent|LWP::UserAgent> (sub-)class. You can
#pod use your own subclass to add features such as caching or enhanced logging.
#pod
#pod If you do not specify a C<user_agent> then we default to an
#pod L<LWPx::UserAgent::Cached|LWPx::UserAgent::Cached> with its C<ssl_opts>
#pod parameter set to C<< {verify_hostname => 0} >>.
#pod
#pod =cut

has user_agent => (
    is      => 'lazy',
    isa     => InstanceOf ['LWP::UserAgent'],
    default => sub {
        LWPx::UserAgent::Cached->new( ssl_opts => { verify_hostname => 0 } );
    },
);

#pod =attr wsdl
#pod
#pod After construction, you can retrieve the created
#pod L<XML::Compile::WSDL11|XML::Compile::WSDL11> instance.
#pod
#pod Example:
#pod
#pod     my $wsdl = $avatax->wsdl;
#pod     my @soap_operations = map { $_->name } $wsdl->operations;
#pod
#pod =cut

has wsdl => (
    is       => 'lazy',
    isa      => InstanceOf ['XML::Compile::WSDL11'],
    init_arg => undef,
);

sub _build_wsdl {
    my $self = shift;
    my $wsdl = XML::Compile::WSDL11->new;
    for ( map { $_->wsdl_uri } @{ $self->_endpoints } ) {
        $wsdl->addWSDL( $self->user_agent->get($_)->content );
    }
    return $wsdl;
}

has _wss => (
    is      => 'ro',
    isa     => InstanceOf ['XML::Compile::SOAP::WSS'],
    default => sub { XML::Compile::SOAP::WSS->new },
);

has _auth => ( is => 'lazy', isa => InstanceOf ['XML::Compile::WSS'] );

sub _build__auth {
    my $self = shift;
    my $wss  = $self->_wss;
    return $wss->basicAuth( map { ( $_ => $self->$_ ) }
            qw(username password) );
}

has _transports => (
    is      => 'lazy',
    isa     => ArrayRef [ InstanceOf ['XML::Compile::Transport::SOAPHTTP'] ],
    default => sub {
        [ map { $_[0]->_make_transport($_) } @{ $_[0]->_endpoints } ];
    },
);

sub _make_transport {
    my ( $self, $endpoint_locator ) = @_;

    my $wss  = $self->_wss;
    my $wsdl = $self->wsdl;
    my $auth = $self->_auth;

    my %soap_params  = map { $_ => $endpoint_locator->$_ } qw(port service);
    my $endpoint_uri = URI->new( $wsdl->endPoint(%soap_params) );
    my $user_agent   = $self->user_agent;

    $user_agent->add_handler(
        request_prepare => sub {
            $_[0]->header( SOAPAction =>
                    $wsdl->operation( $self->_operation_name, %soap_params )
                    ->soapAction );
        },
        (   m_method => 'POST',
            map { ( "m_$_" => $endpoint_uri->$_ ) } qw(scheme host_port path),
        ),
    );

    return XML::Compile::Transport::SOAPHTTP->new(
        address    => $endpoint_uri,
        user_agent => $self->user_agent,
    );
}

has _operation_name => ( is => 'rw', isa => Str, default => q{} );

#pod =head1 SEE ALSO
#pod
#pod =over
#pod
#pod =item L<Avalara Developer Network|http://developer.avalara.com/>
#pod
#pod Official source for Avalara developer information, including API
#pod references, technical articles and more.
#pod
#pod =item L<Business::Tax::Avalara|Business::Tax::Avalara>
#pod
#pod An alternative that uses Avalara's REST API.
#pod
#pod =item L<XML::Compile::SOAP|XML::Compile::SOAP> and L<XML::Compile::WSDL11|XML::Compile::WSDL11>
#pod
#pod Part of the L<XML::Compile|XML::Compile> suite
#pod and the basis for this distribution. It's helpful to understand these in
#pod order to debug or extend this module.
#pod
#pod =back
#pod
#pod =head1 METHODS
#pod
#pod Aside from the L</new> method, available method names are dynamically loaded
#pod from the AvaTax WSDL file's operations and can be passed either a hash or
#pod reference to a hash with the necessary parameters. In scalar context they
#pod return a reference to a hash containing the results of the SOAP call; in list
#pod context they return the results hashref and an
#pod L<XML::Compile::SOAP::Trace|XML::Compile::SOAP::Trace>
#pod object suitable for debugging and exception handling.
#pod
#pod =for Pod::Coverage BUILD
#pod
#pod =cut

sub BUILD {
    my $self = shift;

    # compile operations
    my @operations;
    for my $index ( 0 .. $#{ $self->_endpoints } ) {
        my %soap_params
            = map { ( $_ => $self->_endpoints->[$index]->$_ ) }
            qw(port service);
        $self->wsdl->compileCalls(
            long_names => 1,
            transport  => $self->_transports->[$index],
            %soap_params,
        );
        push @operations => $self->wsdl->operations(%soap_params);
    }

    # stash methods
    for my $operation (@operations) {
        my $method_name
            = ( 2 > grep { $_->name eq $operation->name } @operations )
            ? $operation->name
            : $operation->longName;
        $method_name =~ s/[#]//xms;
        $method_name =~ s/ (?<= [[:alnum:]] ) ( [[:upper:]] ) /_\l$1/xmsg;
        $method_name = lcfirst $method_name;
        $self->_stash->add_symbol(
            "&$method_name" => _method_closure($operation) );
    }
    return;
}

has _stash => (
    is      => 'lazy',
    isa     => InstanceOf ['Package::Stash'],
    default => sub { Package::Stash->new(__PACKAGE__) },
);

const my %OPERATION_PARAMETER => (
    Ping         => 'Message',
    IsAuthorized => 'Operations',
    map { ( $_ => "${_}Request" ) }
        qw(
        GetTax
        GetTaxHistory
        PostTax
        CommitTax
        CancelTax
        ReconcileTaxHistory
        AdjustTax
        ApplyPayment
        TaxSummaryFetch
        Validate
        ),
);

sub _method_closure {
    my $operation = shift;
    return sub {
        my ( $self, @parameters ) = @_;
        my $wsdl = $self->wsdl;

        $self->_operation_name( $operation->name );
        my ( $answer_ref, $trace ) = $wsdl->call(
            $operation->serviceName . q{#}
                . $operation->name => {
                Profile => {
                    Client => "$PROGRAM_NAME," . ( $main::VERSION // q{} ),
                    Adapter => __PACKAGE__ . q{,} . ( $VERSION // q{} ),
                    Machine => hostname(),
                },
                parameters => {
                    $OPERATION_PARAMETER{ $operation->name } =>
                        @parameters % 2
                    ? "@parameters"
                    : {@parameters},
                },
                },
        );

        #pod =pod
        #pod
        #pod If there is no result then an exception will be thrown.
        #pod
        #pod =cut

        if ( not $answer_ref ) {
            for ( $trace->errors ) { $_->throw }
        }
        return wantarray ? ( $answer_ref, $trace ) : $answer_ref;
    };
}

1;

__END__

=pod

=encoding UTF-8

=for :stopwords Mark Gardner ZipRecruiter cpan testmatrix url annocpan anno bugtracker rt
cpants kwalitee diff irc mailto metadata placeholders metacpan

=head1 NAME

WebService::Avalara::AvaTax - Avalara SOAP interface as compiled Perl methods

=head1 VERSION

version 0.007

=head1 SYNOPSIS

    use WebService::Avalara::AvaTax;
    my $avatax = WebService::Avalara::AvaTax->new(
        username => 'avalara@example.com',
        password => 'sekrit',
    );
    my $answer_ref = $avatax->ping;

=head1 DESCRIPTION

This class provides a Perl method API for
L<Avalara AvaTax|http://developer.avalara.com/api-docs/soap>
web services. The first call to any AvaTax SOAP operation uses
L<XML::Compile::WSDL11|XML::Compile::WSDL11> to compile and execute against the
specified Avalara AvaTax service; subsequent calls can vary the
parameters but will use the same compiled code.

=head1 METHODS

Aside from the L</new> method, available method names are dynamically loaded
from the AvaTax WSDL file's operations and can be passed either a hash or
reference to a hash with the necessary parameters. In scalar context they
return a reference to a hash containing the results of the SOAP call; in list
context they return the results hashref and an
L<XML::Compile::SOAP::Trace|XML::Compile::SOAP::Trace>
object suitable for debugging and exception handling.

=head2 new

Builds a new AvaTax web service client. See the L</ATTRIBUTES> section for
description of its named parameters.

=head2 get_tax

Example:

    my ( $answer_ref, $trace ) = $avatax->get_tax(
        CustomerCode => 'ABC4335',
        DocDate      => '2014-01-01',
        CompanyCode  => 'APITrialCompany',
        DocCode      => 'INV001',
        DetailLevel  =>  'Tax',
        Commit       => 0,
        DocType      => 'SalesInvoice',
    );

=head2 post_tax

Example:

    my ( $answer_ref, $trace ) = $avatax->post_tax(
        CompanyCode => 'APITrialCompany',
        DocType     => 'SalesInvoice',
        DocCode     => 'INV001',
        Commit      => 0,
        DocDate     => '2014-01-01',
        TotalTax    => '14.27',
        TotalAmount => 175,
        NewDocCode  => 'INV001-1',
    );

=head2 commit_tax

Example:

    my ( $answer_ref, $trace ) = $avatax->commit_tax(
        DocCode     => 'INV001',
        DocType     => 'SalesInvoice',
        CompanyCode => 'APITrialCompany',
        NewDocCode  => 'INV001-1',
    );

=head2 cancel_tax

Example:

    my ( $answer_ref, $trace ) = $avatax->cancel_tax(
        CompanyCode => 'APITrialCompany',
        DocType     => 'SalesInvoice',
        DocCode     => 'INV001',
        CancelCode  => 'DocVoided',
    );

=head2 adjust_tax

Example:

    my ( $answer_ref, $trace ) = $avatax->adjust_tax(
        AdjustmentReason      => 4,
        AdjustmentDescription => 'Transaction Adjusted for Testing',
        GetTaxRequest => {
            CustomerCode => 'ABC4335',
            DocDate      => '2014-01-01',
            CompanyCode  => 'APITrialCompany',
            DocCode      => 'INV001',
            DetailLevel  => 'Tax',
            Commit       => 0,
            DocType      => 'SalesInvoice',
            # BusinessIdentificationNo => '234243',
            # CustomerUsageType        => 'G',
            # ExemptionNo              => '12345',
            # Discount                 => 50,
            # LocationCode             => '01',
            # TaxOverride => [
            #    {   TaxOverrideType => 'TaxDate',
            #        Reason          => 'Adjustment for return',
            #        TaxDate         => '2013-07-01',
            #        TaxAmount       => 0,
            #    },
            # ],
            # ServiceMode => 'Automatic',
            PurchaseOrderNo     => 'PO123456',
            ReferenceCode       => 'ref123456',
            PosLaneCode         => '09',
            CurrencyCode        => 'USD',
            ExchangeRate        => '1.0',
            ExchangeRateEffDate => '2013-01-01',
            SalespersonCode     => 'Bill Sales',
            Addresses => { BaseAddress => [
                {   AddressCode => '01',
                    Line1       => '45 Fremont Street',
                    City        => 'San Francisco',
                    Region      => 'CA',
                },
                {   AddressCode => '02',
                    Line1       => '118 N Clark St',
                    Line2       => 'Suite 100',
                    Line3       => 'ATTN Accounts Payable',
                    City        => 'Chicago',
                    Region      => 'IL',
                    Country     => 'US',
                    PostalCode  => '60602',
                },
                {   AddressCode => '03',
                    Latitude    => '47.627935',
                    Longitude   => '-122.51702',
                },
            ] },
            Lines => { Line => [
                {   No              => '01',
                    ItemCode        => 'N543',
                    Qty             => 1,
                    Amount          => 10,
                    TaxCode         => 'NT',
                    Description     => 'Red Size 7 Widget',
                    OriginCode      => '01',
                    DestinationCode => '02',
                    # CustomerUsageType => 'L',
                    # ExemptionNo       => '12345',
                    # Discounted        => 1,
                    # TaxIncluded       => 1,
                    # TaxOverride => {
                    #     TaxOverrideType => 'TaxDate',
                    #     Reason          => 'Adjustment for return',
                    #     TaxDate         => '2013-07-01',
                    #     TaxAmount       => 0,
                    # },
                    Ref1 => 'ref123',
                    Ref2 => 'ref456',
                },
                {   No              => '02',
                    ItemCode        => 'T345',
                    Qty             => 3,
                    Amount          => 150,
                    OriginCode      => '01',
                    DestinationCode => '03',
                    Description     => 'Size 10 Green Running Shoe',
                    TaxCode         => 'PC30147',
                },
                {   No              => '02-FR',
                    ItemCode        => 'FREIGHT',
                    Qty             => 1,
                    Amount          => 15,
                    OriginCode      => '01',
                    DestinationCode => '03',
                    Description     => 'Shipping Charge',
                    TaxCode         => 'FR',
                },
            ] },
        },
    );

=head2 get_tax_history

Example:

    my ( $answer_ref, $trace ) = $avatax->get_tax_history(
        CompanyCode => 'APITrialCompany',
        DocType     => 'SalesInvoice',
        DocCode     => 'INV001',
        DetailLevel => 'Tax',
    );

=head2 validate

Example:

    my ( $answer_ref, $trace ) = $avatax->validate(
        Address => {
            Line1      => '118 N Clark St',
            Line2      => 'Suite 100',
            Line3      => 'ATTN Accounts Payable',
            City       => 'Chicago',
            Region     => 'IL',
            PostalCode => '60602',
        },
        Coordinates => 1,
        Taxability  => 1,
        TextCase    => 'Upper',
    );

=head2 tax_svc_is_authorized

Example:

    my ( $answer_ref, $trace ) = $avatax->tax_svc_is_authorized(
        join ', ' => qw(
            Ping
            IsAuthorized
            GetTax
            PostTax
            GetTaxHistory
            CommitTax
            CancelTax
            AdjustTax
        ),
    );

=head2 address_svc_is_authorized

Example:

    my ( $answer_ref, $trace ) = $avatax->address_svc_is_authorized(
        join ', ' => qw(
            Ping
            IsAuthorized
            Validate
        ),
    );

=head2 tax_svc_ping

Example:

    use List::Util 1.33 'any';
    my ( $answer_ref, $trace ) = $avatax->tax_svc_ping;
    for my $code ( $result_ref->{parameters}{PingResult}{ResultCode} ) {
        if ( $code eq 'Success' ) { say $code; last }
        if ( $code eq 'Warning' ) {
            warn $result_ref->{parameters}{PingResult}{Messages};
            last;
        }
        if ( any {$code eq $_} qw(Error Exception) ) {
            die $result_ref->{parameters}{PingResult}{Messages};
        }
    }

=head2 address_svc_ping

Example:

    use List::Util 1.33 'any';
    my ( $answer_ref, $trace ) = $avatax->address_svc_ping;
    for my $code ( $result_ref->{parameters}{PingResult}{ResultCode} ) {
        if ( $code eq 'Success' ) { say $code; last }
        if ( $code eq 'Warning' ) {
            warn $result_ref->{parameters}{PingResult}{Messages};
            last;
        }
        if ( any {$code eq $_} qw(Error Exception) ) {
            die $result_ref->{parameters}{PingResult}{Messages};
        }
    }

=head2 tax_summary_fetch

Example:

    my ( $answer_ref, $trace ) = $avatax->tax_summary_fetch(
        MerchantCode => 'example',
        StartDate    => '2014-01-01',
        EndDate      => '2014-01-31',
    );

=head2 apply_payment (DEPRECATED)

From L<Avalara API documentation|http://developer.avalara.com/api-docs/soap/applypayment>:

=over

The ApplyPayment method of the TaxSvc was originally designed to update an
existing document record with a PaymentDate value. This function (and
cash-basis accounting in general) is no longer supported, and will not work on
new or existing accounts, but remains in the TaxSvc WSDL and some
automatically built adaptors for backwards compatibility.

=back

Example:

    my ( $answer_ref, $trace ) = $avatax->apply_payment(
        DocId       => 'example',
        CompanyCode => 'APITrialCompany',
        DocType     => 'SalesInvoice',
        DocCode     => 'INV001',
        PaymentDate => '2014-01-01',
    );

=head2 reconcile_tax_history (LEGACY API)

From L<Avalara API documentation|http://developer.avalara.com/api-docs/soap/reconciletaxhistory>:

=over

The ReconcileTaxHistory method of the TaxSvc was designed to allow users to
pull a range of documents for reconciliation against a document of record
(i.e. in the ERP), and then flag the reconciled documents as completed. Those
flagged documents would then be omitted from subsequent ReconcileTaxHistory
calls. This method no longer changes the "reconciled" document flag, but can
be used to retrieve ranges of document data (much like the AccountSvc
L<DocumentFetch|http://developer.avalara.com/api-docs/soap/accountsvc/document-elements>),
and remains in the TaxSvc WSDL and some automatically built
adaptors for backwards compatibility.

=back

Example:

    my ( $answer_ref, $trace ) = $avatax->reconcile_tax_history(
        CompanyCode => 'APITrialCompany',
        LastDocId   => 'example',
        Reconciled  => 1,
        StartDate   => '2014-01-01',
        EndDate     => '2014-01-31',
        DocStatus   => 'Temporary',
        DocType     => 'SalesOrder',
        LastDocCode => 'example',
        PageSize    => 10,
    );

=head1 ATTRIBUTES

=head2 username

The Avalara email address used for authentication. Required.

=head2 password

The password used for Avalara authentication. Required.

=head2 is_production

A boolean value that indicates whether to connect to the production AvaTax
services (true) or development (false). Defaults to false.

=head2 debug

When set to true, the L<Log::Report|Log::Report> dispatcher used by
L<XML::Compile|XML::Compile> and friends is set to I<DEBUG> mode.

=head2 user_agent

An instance of an L<LWP::UserAgent|LWP::UserAgent> (sub-)class. You can
use your own subclass to add features such as caching or enhanced logging.

If you do not specify a C<user_agent> then we default to an
L<LWPx::UserAgent::Cached|LWPx::UserAgent::Cached> with its C<ssl_opts>
parameter set to C<< {verify_hostname => 0} >>.

=head2 wsdl

After construction, you can retrieve the created
L<XML::Compile::WSDL11|XML::Compile::WSDL11> instance.

Example:

    my $wsdl = $avatax->wsdl;
    my @soap_operations = map { $_->name } $wsdl->operations;

=head1 SEE ALSO

=over

=item L<Avalara Developer Network|http://developer.avalara.com/>

Official source for Avalara developer information, including API
references, technical articles and more.

=item L<Business::Tax::Avalara|Business::Tax::Avalara>

An alternative that uses Avalara's REST API.

=item L<XML::Compile::SOAP|XML::Compile::SOAP> and L<XML::Compile::WSDL11|XML::Compile::WSDL11>

Part of the L<XML::Compile|XML::Compile> suite
and the basis for this distribution. It's helpful to understand these in
order to debug or extend this module.

=back

=for Pod::Coverage BUILD

If there is no result then an exception will be thrown.

=head1 SUPPORT

=head2 Perldoc

You can find documentation for this module with the perldoc command.

  perldoc WebService::Avalara::AvaTax

=head2 Websites

The following websites have more information about this module, and may be of help to you. As always,
in addition to those websites please use your favorite search engine to discover more resources.

=over 4

=item *

MetaCPAN

A modern, open-source CPAN search engine, useful to view POD in HTML format.

L<http://metacpan.org/release/WebService-Avalara-AvaTax>

=item *

Search CPAN

The default CPAN search engine, useful to view POD in HTML format.

L<http://search.cpan.org/dist/WebService-Avalara-AvaTax>

=item *

AnnoCPAN

The AnnoCPAN is a website that allows community annotations of Perl module documentation.

L<http://annocpan.org/dist/WebService-Avalara-AvaTax>

=item *

CPAN Ratings

The CPAN Ratings is a website that allows community ratings and reviews of Perl modules.

L<http://cpanratings.perl.org/d/WebService-Avalara-AvaTax>

=item *

CPAN Forum

The CPAN Forum is a web forum for discussing Perl modules.

L<http://cpanforum.com/dist/WebService-Avalara-AvaTax>

=item *

CPANTS

The CPANTS is a website that analyzes the Kwalitee ( code metrics ) of a distribution.

L<http://cpants.cpanauthors.org/dist/WebService-Avalara-AvaTax>

=item *

CPAN Testers

The CPAN Testers is a network of smokers who run automated tests on uploaded CPAN distributions.

L<http://www.cpantesters.org/distro/W/WebService-Avalara-AvaTax>

=item *

CPAN Testers Matrix

The CPAN Testers Matrix is a website that provides a visual overview of the test results for a distribution on various Perls/platforms.

L<http://matrix.cpantesters.org/?dist=WebService-Avalara-AvaTax>

=item *

CPAN Testers Dependencies

The CPAN Testers Dependencies is a website that shows a chart of the test results of all dependencies for a distribution.

L<http://deps.cpantesters.org/?module=WebService::Avalara::AvaTax>

=back

=head2 Bugs / Feature Requests

Please report any bugs or feature requests through the web
interface at
L<https://github.com/mjgardner/WebService-Avalara-AvaTax/issues>.
You will be automatically notified of any progress on the
request by the system.

=head2 Source Code

The code is open to the world, and available for you to hack on. Please feel free to browse it and play
with it, or whatever. If you want to contribute patches, please send me a diff or prod me to pull
from your repository :)

L<https://github.com/mjgardner/WebService-Avalara-AvaTax>

  git clone git://github.com/mjgardner/WebService-Avalara-AvaTax.git

=head1 AUTHOR

Mark Gardner <mjgardner@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by ZipRecruiter.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
