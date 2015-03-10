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

use Const::Fast;
use Package::Stash;
use Moo;
use Types::Standard qw(Bool HashRef InstanceOf);
use namespace::clean;
with 'WebService::Avalara::AvaTax::Role::Connection';

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

=method new

Builds a new AvaTax web service client. Takes the following parameters, which
are also available as instance methods.

=over

=item username

The Avalara email address used for authentication. Required.

=item password

The password used for Avalara authentication. Required.

=item endpoint

A string or L<URI|URI> object indicating the AvaTax WSDL file to load.
Defaults to L<https://development.avalara.net/tax/taxsvc.wsdl>.
For production API access one should set this to
L<https://avatax.avalara.net/tax/taxsvc.wsdl>.

=item user_agent

An instance of an L<LWP::UserAgent|LWP::UserAgent> (sub-)class. You can
use your own subclass to add features such as caching or enhanced logging.

If you do not specify a C<user_agent> then we default to an
L<LWPx::UserAgent::Cached|LWPx::UserAgent::Cached> with its C<ssl_opts>
parameter set to C<< {verify_hostname => 0} >>.

=item debug

When set to true, the L<Log::Report|Log::Report> dispatcher used by
L<XML::Compile|XML::Compile> and friends is set to I<DEBUG> mode.

=back

=attr wsdl

After construction, you can retrieve the created
L<XML::Compile::WSDL11|XML::Compile::WSDL11> instance.

Example:

    my $wsdl = $avatax->wsdl;
    my @soap_operations = map { $_->name } $wsdl->operations;

=method call

Given an operation name and parameters, makes a SOAP call. The operation will
also receive a C<Profile> parameter containing information about the program,
machine and version of this module making the call.

=for Pod::Coverage BUILD

=head1 METHODS

Aside from the C<new> and C<call> methods, available method names are
dynamically loaded from the AvaTax WSDL file's operations and can be passed
either a hash or reference to a hash with the necessary parameters. In scalar
context they return a reference to a hash containing the results of the SOAP
call; in list context they return the results hashref and an
L<XML::Compile::SOAP::Trace|XML::Compile::SOAP::Trace>
object suitable for debugging and exception handling.

As of this writing the following operations are published in the Avalara
AvaTax schema. Consult
L<Avalara's developer site|http://developer.avalara.com/>
for full documentation on input and output parameters for each operation.

=cut

sub BUILD {
    my $self = shift;
    for my $operation ( map { $_->name } $self->wsdl->operations ) {
        my $method = $operation;
        $method =~ s/ (?<= [[:alnum:]] ) ( [[:upper:]] ) /_\l$1/xmsg;
        $method = lcfirst $method;
        $self->_stash->add_symbol(
            "&$method" => _method_closure($operation) );
    }
    return;
}

has _compiled => ( is => 'rw', isa => HashRef [Bool], default => sub { {} } );
has _stash => (
    is      => 'lazy',
    isa     => InstanceOf ['Package::Stash'],
    default => sub { Package::Stash->new(__PACKAGE__) },
);

sub _method_closure {
    my $method = shift;
    return sub {
        my $self = shift;
        my $wsdl = $self->wsdl;
        if ( not $self->_compiled->{$method} ) {
            $wsdl->compileCall(
                $method,
                transport => $self->_transport,
                service   => $self->_soap_service,
                port      => $self->_soap_port,
            );
            $self->_compiled->{$method} = 1;
        }
        my ( $answer_ref, $trace ) = $self->call( $method => @_ );

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
        GetTaxRequest => {
            CustomerCode => 'ABC4335',
            DocDate      => '2014-01-01',
            CompanyCode  => 'APITrialCompany',
            DocCode      => 'INV001',
            DetailLevel  =>  'Tax',
            Commit       => 0,
            DocType      => 'SalesInvoice',
        },
    );

=method post_tax

Example:

    my ( $answer_ref, $trace ) = $avatax->post_tax(
        PostTaxRequest => {
            CompanyCode => 'APITrialCompany',
            DocType     => 'SalesInvoice',
            DocCode     => 'INV001',
            Commit      => 0,
            DocDate     => '2014-01-01',
            TotalTax    => '14.27',
            TotalAmount => 175,
            NewDocCode  => 'INV001-1',
        },
    );

=method commit_tax

Example:

    my ( $answer_ref, $trace ) = $avatax->commit_tax(
        CommitTaxRequest => {
            DocCode     => 'INV001',
            DocType     => 'SalesInvoice',
            CompanyCode => 'APITrialCompany',
            NewDocCode  => 'INV001-1',
        },
    );

=method cancel_tax

Example:

    my ( $answer_ref, $trace ) = $avatax->cancel_tax(
        CancelTaxRequest => {
            CompanyCode => 'APITrialCompany',
            DocType     => 'SalesInvoice',
            DocCode     => 'INV001',
            CancelCode  => 'DocVoided',
        },
    );

=method adjust_tax

Example:

    my ( $answer_ref, $trace ) = $avatax->adjust_tax(
        AdjustTaxRequest => {
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
                Addresses => {BaseAddress => [
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
                Lines => {Line => [
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
        },
    );

=method get_tax_history

Example:

    my ( $answer_ref, $trace ) = $avatax->get_tax_history(
        GetTaxHistoryRequest => {
            CompanyCode => 'APITrialCompany',
            DocType     => 'SalesInvoice',
            DocCode     => 'INV001',
            DetailLevel => 'Tax',
        },
    );

=method is_authorized

Example:

    my ( $answer_ref, $trace ) = $avatax->is_authorized(
        Operations => join ', ' => qw(
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
    my ( $answer_ref, $trace ) = $avatax->ping( Message => 'ignored' );
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

=method reconcile_tax_history

Example:

    my ( $answer_ref, $trace ) = $avatax->reconcile_tax_history(
        ReconcileTaxHistoryRequest => {
            CompanyCode => 'APITrialCompany',
            LastDocId   => 'example',
            Reconciled  => 1,
            StartDate   => '2014-01-01',
            EndDate     => '2014-01-31',
            DocStatus   => 'Temporary',
            DocType     => 'SalesOrder',
            LastDocCode => 'example',
            PageSize    => 10,
        },
    );

=method apply_payment

Example:

    my ( $answer_ref, $trace ) = $avatax->apply_payment(
        ApplyPaymentRequest => {
            DocId       => 'example',
            CompanyCode => 'APITrialCompany',
            DocType     => 'SalesInvoice',
            DocCode     => 'INV001',
            PaymentDate => '2014-01-01',
        },
    );

=method tax_summary_fetch

Example:

    my ( $answer_ref, $trace ) = $avatax->tax_summary_fetch(
        TaxSummaryFetchRequest => {
            MerchantCode => 'example',
            StartDate    => '2014-01-01',
            EndDate      => '2014-01-31',
        },
    );
