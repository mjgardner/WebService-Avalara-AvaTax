# NAME

WebService::Avalara::AvaTax - Avalara SOAP interface as compiled Perl methods

# VERSION

version 0.003

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
[XML::Compile::WSDL11](https://metacpan.org/pod/XML::Compile::WSDL11) to compile and execute against the
specified Avalara AvaTax service; subsequent calls can vary the
parameters but will use the same compiled code.

# METHODS

Available method names are dynamically loaded from the AvaTax WSDL file's
operations, and can be passed either a hash or reference to a hash with the
necessary parameters. In scalar context they return a reference to a hash
containing the results of the SOAP call; in list context they return the
results hashref and an [XML::Compile::SOAP::Trace](https://metacpan.org/pod/XML::Compile::SOAP::Trace)
object suitable for debugging and exception handling.

As of this writing the following operations are published in the Avalara
AvaTax schema. Consult Avalara's Help Center for full documentation on input
and output parameters for each operation.

If there is no result then an exception will be thrown.

## get\_tax

Example:

    use DateTime;
    use DateTime::Format::XSD;
    my ( $answer_ref, $trace ) = $avatax->get_tax(
        CustomerCode => 'ABC4335',
        DocDate      => DateTime::Format::XSD->format_datetime(
            DateTime->new( year => 2014, month => 1, day => 1 ) ),
        CompanyCode  => 'APITrialCompany',
        DocCode      => 'INV001',
        DetailLevel  =>  'Tax',
        Commit       => 0,
        DocType      => 'SalesInvoice',
    );

## post\_tax

Example:

    use DateTime;
    use DateTime::Format::XSD;
    my ( $answer_ref, $trace ) = $avatax->post_tax(
        CompanyCode => 'APITrialCompany',
        DocType     => 'SalesInvoice',
        DocCode     => 'INV001',
        Commit      => 0,
        DocDate     => DateTime::Format::XSD->format_datetime(
            DateTime->new(year => 2014, month => 1, day => 1) ),
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

## get\_tax\_history

Example:

    my ( $answer_ref, $trace ) = $avatax->get_tax_history(
        CompanyCode => 'APITrialCompany',
        DocType     => 'SalesInvoice',
        DocCode     => 'INV001',
        DetailLevel => 'Tax',
    );

## is\_authorized

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

## ping

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

## reconcile\_tax\_history

## apply\_payment

## tax\_summary\_fetch

# OTHER METHODS AND ATTRIBUTES

Because this class consumes the
`WebService::Avalara::AvaTax::Role::Connection` role, it also has
that role's attributes and methods. Please consult that module for attributes
important for establishing a connection such as `username` and `password`.
You can also use other attributes, such as the `user_agent`
attribute to access the [LWP::UserAgent](https://metacpan.org/pod/LWP::UserAgent) used to retrieve and
call the AvaTax service, or the `wsdl` method to access the underlying
[XML::Compile::WSDL11](https://metacpan.org/pod/XML::Compile::WSDL11) object.

# SEE ALSO

- [Business::Tax::Avalara](https://metacpan.org/pod/Business::Tax::Avalara)

    An alternative that uses Avalara's REST API.

- [XML::Compile::SOAP](https://metacpan.org/pod/XML::Compile::SOAP) and [XML::Compile::WSDL11](https://metacpan.org/pod/XML::Compile::WSDL11)

    Part of the [XML::Compile](https://metacpan.org/pod/XML::Compile) suite
    and the basis for this distribution. It's helpful to understand these in
    order to debug or extend this module.

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

This software is copyright (c) 2015 by ZipRecruiter.  No
license is granted to other entities.
