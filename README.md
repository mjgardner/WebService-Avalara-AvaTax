# NAME

WebService::Avalara::AvaTax - Avalara SOAP interface as compiled Perl methods

# VERSION

version 0.008

# SYNOPSIS

    use WebService::Avalara::AvaTax;
    my $avatax = WebService::Avalara::AvaTax->new(
        username => 'avalara@example.com',
        password => 'sekrit',
    );
    my $answer_ref = $avatax->ping;

# DESCRIPTION

This class provides a Perl method API for
[Avalara AvaTax](http://developer.avalara.com/api-docs/soap)
web services. The first call to any AvaTax SOAP operation uses
[XML::Compile::WSDL11](https://metacpan.org/pod/XML::Compile::WSDL11)
to compile and execute against the specified Avalara AvaTax service;
subsequent calls can vary the parameters but will use the same compiled code.

# METHODS

Aside from the ["new"](#new) method, ["services"](#services) attribute and
other attributes and methods consumed from
[WebService::Avalara::AvaTax::Role::Connection](https://metacpan.org/pod/WebService::Avalara::AvaTax::Role::Connection),
available method names are dynamically loaded from each
["services"](#services)'
[wsdl](https://metacpan.org/pod/WebService::Avalara::AvaTax::Role::Connection#wsdl)
attribute and can be passed either a hash or reference to a hash with the
necessary parameters. In scalar context they return a reference to a hash
containing the results of the SOAP call; in list context they return the
results hashref and an
[XML::Compile::SOAP::Trace](https://metacpan.org/pod/XML::Compile::SOAP::Trace)
object suitable for debugging and exception handling.

## new

Builds a new AvaTax web service client. Since this class consumes the
[WebService::Avalara::AvaTax::Role::Connection](https://metacpan.org/pod/WebService::Avalara::AvaTax::Role::Connection)
role, please consult that module's documentation for a full list of attributes
that can be set at construction.

## get\_tax

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

## post\_tax

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

## commit\_tax

Example:

    my ( $answer_ref, $trace ) = $avatax->commit_tax(
        DocCode     => 'INV001',
        DocType     => 'SalesInvoice',
        CompanyCode => 'APITrialCompany',
        NewDocCode  => 'INV001-1',
    );

## cancel\_tax

Example:

    my ( $answer_ref, $trace ) = $avatax->cancel_tax(
        CompanyCode => 'APITrialCompany',
        DocType     => 'SalesInvoice',
        DocCode     => 'INV001',
        CancelCode  => 'DocVoided',
    );

## adjust\_tax

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

## get\_tax\_history

Example:

    my ( $answer_ref, $trace ) = $avatax->get_tax_history(
        CompanyCode => 'APITrialCompany',
        DocType     => 'SalesInvoice',
        DocCode     => 'INV001',
        DetailLevel => 'Tax',
    );

## validate

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

## is\_authorized

Both
[WebService::Avalara::AvaTax::Service::Address](https://metacpan.org/pod/WebService::Avalara::AvaTax::Service::Address)
and
[WebService::Avalara::AvaTax::Service::Tax](https://metacpan.org/pod/WebService::Avalara::AvaTax::Service::Tax)
provide `IsAuthorized` operations. However, since the latter is loaded last,
only its version is called when you call this method. If you need to
specifically call a particular service's `IsAuthorized`, use the
[call](https://metacpan.org/pod/XML::Compile::WSDL11#Compilers)
method on its
[wsdl](https://metacpan.org/pod/WebService::Avalara::AvaTax::Role::Connection#wsdl)
attribute.

Example:

    my ( $answer_ref, $trace ) = $avatax->is_authorized(
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

## ping

Both
[WebService::Avalara::AvaTax::Service::Address](https://metacpan.org/pod/WebService::Avalara::AvaTax::Service::Address)
and
[WebService::Avalara::AvaTax::Service::Tax](https://metacpan.org/pod/WebService::Avalara::AvaTax::Service::Tax)
provide `Ping` operations. However, since the latter is loaded last,
only its version is called when you call this method. If you need to
specifically call a particular service's `Ping`, use the
[call](https://metacpan.org/pod/XML::Compile::WSDL11#Compilers)
method on its
[wsdl](https://metacpan.org/pod/WebService::Avalara::AvaTax::Role::Connection#wsdl)
attribute.

Example:

    use List::Util 1.33 'any';
    my ( $answer_ref, $trace ) = $avatax->ping;
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

## tax\_summary\_fetch

Example:

    my ( $answer_ref, $trace ) = $avatax->tax_summary_fetch(
        MerchantCode => 'example',
        StartDate    => '2014-01-01',
        EndDate      => '2014-01-31',
    );

## apply\_payment (DEPRECATED)

From [Avalara API documentation](http://developer.avalara.com/api-docs/soap/applypayment):

> The ApplyPayment method of the TaxSvc was originally designed to update an
> existing document record with a PaymentDate value. This function (and
> cash-basis accounting in general) is no longer supported, and will not work
> on new or existing accounts, but remains in the TaxSvc WSDL and some
> automatically built adaptors for backwards compatibility.

Example:

    my ( $answer_ref, $trace ) = $avatax->apply_payment(
        DocId       => 'example',
        CompanyCode => 'APITrialCompany',
        DocType     => 'SalesInvoice',
        DocCode     => 'INV001',
        PaymentDate => '2014-01-01',
    );

## reconcile\_tax\_history (LEGACY API)

From [Avalara API documentation](http://developer.avalara.com/api-docs/soap/reconciletaxhistory):

> The ReconcileTaxHistory method of the TaxSvc was designed to allow users to
> pull a range of documents for reconciliation against a document of record
> (i.e. in the ERP), and then flag the reconciled documents as completed. Those
> flagged documents would then be omitted from subsequent ReconcileTaxHistory
> calls. This method no longer changes the "reconciled" document flag, but can
> be used to retrieve ranges of document data (much like the AccountSvc
> [DocumentFetch](http://developer.avalara.com/api-docs/soap/accountsvc/document-elements)),
> and remains in the TaxSvc WSDL and some automatically built
> adaptors for backwards compatibility.

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

# ATTRIBUTES

## services

This module is really just a convenience wrapper around instances of
[WebService::Avalara::AvaTax::Service::Address](https://metacpan.org/pod/WebService::Avalara::AvaTax::Service::Address)
and
[WebService::Avalara::AvaTax::Service::Tax](https://metacpan.org/pod/WebService::Avalara::AvaTax::Service::Tax)
modules. As such this attribute is used to keep an array reference to
instances of both classes, with the following attributes from ["new"](#new)
passed to both:

- [username](https://metacpan.org/pod/WebService::Avalara::AvaTax::Role::Connection#username)
- [password](https://metacpan.org/pod/WebService::Avalara::AvaTax::Role::Connection#password)
- [is\_production](https://metacpan.org/pod/WebService::Avalara::AvaTax::Role::Connection#is_production)
- [user\_agent](https://metacpan.org/pod/WebService::Avalara::AvaTax::Role::Connection#user_agent)
- [debug](https://metacpan.org/pod/WebService::Avalara::AvaTax::Role::Connection#debug)

# SEE ALSO

- [Avalara Developer Network](http://developer.avalara.com/)

    Official source for Avalara developer information, including API
    references, technical articles and more.

- [Business::Tax::Avalara](https://metacpan.org/pod/Business::Tax::Avalara)

    An alternative that uses Avalara's REST API.

- [XML::Compile::SOAP](https://metacpan.org/pod/XML::Compile::SOAP) and [XML::Compile::WSDL11](https://metacpan.org/pod/XML::Compile::WSDL11)

    Part of the [XML::Compile](https://metacpan.org/pod/XML::Compile) suite
    and the basis for this distribution. It's helpful to understand these in
    order to debug or extend this module.

If there is no result then an exception will be thrown.

# SUPPORT

## Perldoc

You can find documentation for this module with the perldoc command.

    perldoc WebService::Avalara::AvaTax

## Websites

The following websites have more information about this module, and may be of help to you. As always,
in addition to those websites please use your favorite search engine to discover more resources.

- MetaCPAN

    A modern, open-source CPAN search engine, useful to view POD in HTML format.

    [http://metacpan.org/release/WebService-Avalara-AvaTax](http://metacpan.org/release/WebService-Avalara-AvaTax)

- Search CPAN

    The default CPAN search engine, useful to view POD in HTML format.

    [http://search.cpan.org/dist/WebService-Avalara-AvaTax](http://search.cpan.org/dist/WebService-Avalara-AvaTax)

- AnnoCPAN

    The AnnoCPAN is a website that allows community annotations of Perl module documentation.

    [http://annocpan.org/dist/WebService-Avalara-AvaTax](http://annocpan.org/dist/WebService-Avalara-AvaTax)

- CPAN Ratings

    The CPAN Ratings is a website that allows community ratings and reviews of Perl modules.

    [http://cpanratings.perl.org/d/WebService-Avalara-AvaTax](http://cpanratings.perl.org/d/WebService-Avalara-AvaTax)

- CPAN Forum

    The CPAN Forum is a web forum for discussing Perl modules.

    [http://cpanforum.com/dist/WebService-Avalara-AvaTax](http://cpanforum.com/dist/WebService-Avalara-AvaTax)

- CPANTS

    The CPANTS is a website that analyzes the Kwalitee ( code metrics ) of a distribution.

    [http://cpants.cpanauthors.org/dist/WebService-Avalara-AvaTax](http://cpants.cpanauthors.org/dist/WebService-Avalara-AvaTax)

- CPAN Testers

    The CPAN Testers is a network of smokers who run automated tests on uploaded CPAN distributions.

    [http://www.cpantesters.org/distro/W/WebService-Avalara-AvaTax](http://www.cpantesters.org/distro/W/WebService-Avalara-AvaTax)

- CPAN Testers Matrix

    The CPAN Testers Matrix is a website that provides a visual overview of the test results for a distribution on various Perls/platforms.

    [http://matrix.cpantesters.org/?dist=WebService-Avalara-AvaTax](http://matrix.cpantesters.org/?dist=WebService-Avalara-AvaTax)

- CPAN Testers Dependencies

    The CPAN Testers Dependencies is a website that shows a chart of the test results of all dependencies for a distribution.

    [http://deps.cpantesters.org/?module=WebService::Avalara::AvaTax](http://deps.cpantesters.org/?module=WebService::Avalara::AvaTax)

## Bugs / Feature Requests

Please report any bugs or feature requests through the web
interface at
[https://github.com/mjgardner/WebService-Avalara-AvaTax/issues](https://github.com/mjgardner/WebService-Avalara-AvaTax/issues).
You will be automatically notified of any progress on the
request by the system.

## Source Code

The code is open to the world, and available for you to hack on. Please feel free to browse it and play
with it, or whatever. If you want to contribute patches, please send me a diff or prod me to pull
from your repository :)

[https://github.com/mjgardner/WebService-Avalara-AvaTax](https://github.com/mjgardner/WebService-Avalara-AvaTax)

    git clone git://github.com/mjgardner/WebService-Avalara-AvaTax.git

# AUTHOR

Mark Gardner <mjgardner@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by ZipRecruiter.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
