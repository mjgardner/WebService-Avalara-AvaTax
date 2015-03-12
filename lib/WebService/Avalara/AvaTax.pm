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
L<XML::Compile::WSDL11|XML::Compile::WSDL11>
to compile and execute against the specified Avalara AvaTax service;
subsequent calls can vary the parameters but will use the same compiled code.

=cut

use Carp;
use Const::Fast;
use English '-no_match_vars';
use Moo;
use Package::Stash;
use Scalar::Util 'blessed';
use Sys::Hostname;
use Types::Standard qw(ArrayRef Bool HashRef InstanceOf Str);
use WebService::Avalara::AvaTax::Service::Address;
use WebService::Avalara::AvaTax::Service::Tax;
use namespace::clean;
with 'WebService::Avalara::AvaTax::Role::Connection';

=method new

Builds a new AvaTax web service client. Since this class consumes the
L<WebService::Avalara::AvaTax::Role::Connection|WebService::Avalara::AvaTax::Role::Connection>
role, please consult that module's documentation for a full list of attributes
that can be set at construction.

=cut

=attr services

This module is really just a convenience wrapper around instances of
L<WebService::Avalara::AvaTax::Service::Address|WebService::Avalara::AvaTax::Service::Address>
and
L<WebService::Avalara::AvaTax::Service::Tax|WebService::Avalara::AvaTax::Service::Tax>
modules. As such this attribute is used to keep an array reference to
instances of both classes, with the following attributes from L</new>
passed to both:

=over

=item L<username|WebService::Avalara::AvaTax::Role::Connection/username>

=item L<password|WebService::Avalara::AvaTax::Role::Connection/password>

=item L<is_production|WebService::Avalara::AvaTax::Role::Connection/is_production>

=item L<user_agent|WebService::Avalara::AvaTax::Role::Connection/user_agent>

=item L<debug|WebService::Avalara::AvaTax::Role::Connection/debug>

=back

=cut

has services => (
    is       => 'lazy',
    isa      => ArrayRef,
    init_arg => undef,
    default  => sub {
        [ map { $_[0]->_new_service($_) } qw(Address Tax) ];
    },
);

sub _new_service {
    my $self  = shift;
    my $class = __PACKAGE__ . '::Service::' . shift;
    return $class->new(
        map { ( $_ => $self->$_ ) }
            qw(username password is_production user_agent debug),
    );
}

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

Aside from the L</new> method, L</services> attribute and
other attributes and methods consumed from
L<WebService::Avalara::AvaTax::Role::Connection|WebService::Avalara::AvaTax::Role::Connection>,
available method names are dynamically loaded from each
L</services>'
L<wsdl|WebService::Avalara::AvaTax::Role::Connection/wsdl>
attribute and can be passed either a hash or reference to a hash with the
necessary parameters. In scalar context they return a reference to a hash
containing the results of the SOAP call; in list context they return the
results hashref and an
L<XML::Compile::SOAP::Trace|XML::Compile::SOAP::Trace>
object suitable for debugging and exception handling.

=for Pod::Coverage BUILD

=cut

sub BUILD {
    my $self = shift;

    for my $service ( @{ $self->services } ) {
        my %soap_params = map { ( $_ => $service->$_ ) } qw(port service);

        $service->wsdl->compileCalls(
            transport => $service->_transport,
            %soap_params,
        );
        for my $operation ( $service->wsdl->operations(%soap_params) ) {

            # normalize operation name into a Perl method name
            my $method_name = $operation->name;
            $method_name =~ s/ (?<= [[:alnum:]] ) ( [[:upper:]] ) /_\l$1/xmsg;
            $method_name = lcfirst $method_name;

            $self->_stash->add_symbol(
                "&$method_name" => _method_closure( $service, $operation ) );
        }
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
    my ( $service, $operation ) = @_;
    return sub {
        my ( $self, @parameters ) = @_;

        my $wsdl = $service->wsdl;
        $service->_current_operation_name( $operation->name );

        my ( $answer_ref, $trace ) = $wsdl->call(
            $operation->name => {
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

=method is_authorized

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

=method ping

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
cash-basis accounting in general) is no longer supported, and will not work
on new or existing accounts, but remains in the TaxSvc WSDL and some
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
