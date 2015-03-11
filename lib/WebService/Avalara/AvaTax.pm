package WebService::Avalara::AvaTax;

# ABSTRACT: Avalara SOAP interface as compiled Perl methods

use Modern::Perl '2011';    ## no critic (Modules::ProhibitUseQuotedVersion)

# VERSION
use utf8;

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

=cut

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

=method new

Builds a new AvaTax web service client. See the L</ATTRIBUTES> section for
description of its named parameters.

=attr username

The Avalara email address used for authentication. Required.

=cut

has username => ( is => 'ro', isa => EmailAddressLoose, required => 1 );

=attr password

The password used for Avalara authentication. Required.

=cut

has password => ( is => 'ro', isa => Str, required => 1 );

=attr is_production

A boolean value that indicates whether to connect to the production AvaTax
services (true) or development (false). Defaults to false.

=cut

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

=attr debug

When set to true, the L<Log::Report|Log::Report> dispatcher used by
L<XML::Compile|XML::Compile> and friends is set to I<DEBUG> mode.

=cut

has debug => (
    is      => 'ro',
    isa     => Bool,
    default => 0,
    trigger =>
        sub { dispatcher( mode => ( $_[1] ? 'DEBUG' : 'NORMAL' ), 'ALL' ) },
);

=attr user_agent

An instance of an L<LWP::UserAgent|LWP::UserAgent> (sub-)class. You can
use your own subclass to add features such as caching or enhanced logging.

If you do not specify a C<user_agent> then we default to an
L<LWPx::UserAgent::Cached|LWPx::UserAgent::Cached> with its C<ssl_opts>
parameter set to C<< {verify_hostname => 0} >>.

=cut

has user_agent => (
    is      => 'lazy',
    isa     => InstanceOf ['LWP::UserAgent'],
    default => sub {
        LWPx::UserAgent::Cached->new( ssl_opts => { verify_hostname => 0 } );
    },
);

=attr wsdl

After construction, you can retrieve the created
L<XML::Compile::WSDL11|XML::Compile::WSDL11> instance.

Example:

    my $wsdl = $avatax->wsdl;
    my @soap_operations = map { $_->name } $wsdl->operations;

=cut

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

=head1 METHODS

Aside from the L</new> method, available method names are dynamically loaded
from the AvaTax WSDL file's operations and can be passed either a hash or
reference to a hash with the necessary parameters. In scalar context they
return a reference to a hash containing the results of the SOAP call; in list
context they return the results hashref and an
L<XML::Compile::SOAP::Trace|XML::Compile::SOAP::Trace>
object suitable for debugging and exception handling.

=for Pod::Coverage BUILD

=cut

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

=pod

If there is no result then an exception will be thrown.

=cut

        if ( not $answer_ref ) {
            for ( $trace->errors ) { $_->throw }
        }
        return wantarray ? ( $answer_ref, $trace ) : $answer_ref;
    };
}

1;

__END__

=method get_tax

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

=method post_tax

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

=method commit_tax

Example:

    my ( $answer_ref, $trace ) = $avatax->commit_tax(
        DocCode     => 'INV001',
        DocType     => 'SalesInvoice',
        CompanyCode => 'APITrialCompany',
        NewDocCode  => 'INV001-1',
    );

=method cancel_tax

Example:

    my ( $answer_ref, $trace ) = $avatax->cancel_tax(
        CompanyCode => 'APITrialCompany',
        DocType     => 'SalesInvoice',
        DocCode     => 'INV001',
        CancelCode  => 'DocVoided',
    );

=method adjust_tax

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

=method get_tax_history

Example:

    my ( $answer_ref, $trace ) = $avatax->get_tax_history(
        CompanyCode => 'APITrialCompany',
        DocType     => 'SalesInvoice',
        DocCode     => 'INV001',
        DetailLevel => 'Tax',
    );

=method validate

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

=method tax_svc_is_authorized

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

=method address_svc_is_authorized

Example:

    my ( $answer_ref, $trace ) = $avatax->address_svc_is_authorized(
        join ', ' => qw(
            Ping
            IsAuthorized
            Validate
        ),
    );

=method tax_svc_ping

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

=method address_svc_ping

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

=method tax_summary_fetch

Example:

    my ( $answer_ref, $trace ) = $avatax->tax_summary_fetch(
        MerchantCode => 'example',
        StartDate    => '2014-01-01',
        EndDate      => '2014-01-31',
    );

=method apply_payment (DEPRECATED)

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

=method reconcile_tax_history (LEGACY API)

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
