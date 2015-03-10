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
use English '-no_match_vars';
use Log::Report;
use LWPx::UserAgent::Cached;
use Moo;
use MooX::Types::MooseLike::Email 'EmailAddressLoose';
use Package::Stash;
use Scalar::Util 'blessed';
use Sys::Hostname;
use Types::Standard qw(Bool HashRef InstanceOf Str);
use URI;
use XML::Compile::SOAP::WSS;
use XML::Compile::SOAP11;
use XML::Compile::SOAP12;
use XML::Compile::WSDL11;
use XML::Compile::Transport::SOAPHTTP;
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

=attr endpoint

A L<URI|URI> object indicating the AvaTax WSDL file to load. Defaults to
L<https://development.avalara.net/tax/taxsvc.wsdl>. For production API access
one should set this to L<https://avatax.avalara.net/tax/taxsvc.wsdl>.

=cut

has endpoint => (
    is     => 'lazy',
    isa    => InstanceOf ['URI'],
    coerce => sub {
        defined blessed( $_[0] )
            && $_[0]->isa('URI') ? $_[0] : URI->new( $_[0] );
    },
    default =>
        sub { URI->new('https://development.avalara.net/tax/taxsvc.wsdl') },
);

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
    return XML::Compile::WSDL11->new(
        $self->user_agent->get( $self->endpoint )->content );
}

has _soap_service => ( is => 'ro', isa => Str, default => 'TaxSvc' );
has _soap_port    => ( is => 'ro', isa => Str, default => 'TaxSvcSoap' );

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

has _transport =>
    ( is => 'lazy', isa => InstanceOf ['XML::Compile::Transport::SOAPHTTP'] );

sub _build__transport {
    my $self = shift;
    my $wss  = $self->_wss;
    my $wsdl = $self->wsdl;
    my $auth = $self->_auth;

    my $user_agent  = $self->user_agent;
    my %soap_params = (
        service => $self->_soap_service,
        port    => $self->_soap_port,
    );
    my $endpoint_uri = URI->new( $wsdl->endPoint(%soap_params) );
    $user_agent->add_handler(
        request_prepare => sub {
            $_[0]->header( SOAPAction =>
                    $wsdl->operation( $self->_operation_name, %soap_params )
                    ->soapAction, );
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

sub _call {
    my ( $self, $operation, @params ) = @_;
    $self->_operation_name($operation);
    return $self->wsdl->call(
        $operation => {
            Profile => {
                Client => "$PROGRAM_NAME," . ( $main::VERSION // q{} ),
                Adapter => __PACKAGE__ . q{,} . ( $VERSION // q{} ),
                Machine => hostname(),
            },
            parameters => {@params},
        },
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
        my ( $answer_ref, $trace ) = $self->_call( $method => @_ );

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
