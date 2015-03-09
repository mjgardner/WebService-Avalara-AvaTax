package WebService::Avalara::AvaTax;

# ABSTRACT: Avalara SOAP interface as compiled Perl methods

use Modern::Perl '2011';    ## no critic (Modules::ProhibitUseQuotedVersion)

our $VERSION = '0.001';     # TRIAL VERSION
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

use Const::Fast;
use Package::Stash;
use Moo;
use Types::Standard qw(Bool HashRef InstanceOf);
use namespace::clean;
with 'WebService::Avalara::AvaTax::Role::Connection';

#pod =head1 OTHER METHODS AND ATTRIBUTES
#pod
#pod Because this class consumes the
#pod C<WebService::Avalara::AvaTax::Role::Connection> role, it also has
#pod that role's attributes and methods. Please consult that module for attributes
#pod important for establishing a connection such as C<username> and C<password>.
#pod You can also use other attributes, such as the C<user_agent>
#pod attribute to access the L<LWP::UserAgent|LWP::UserAgent> used to retrieve and
#pod call the AvaTax service, or the C<wsdl> method to access the underlying
#pod L<XML::Compile::WSDL11|XML::Compile::WSDL11> object.
#pod
#pod =for Pod::Coverage BUILD
#pod
#pod =head1 METHODS
#pod
#pod Available method names are dynamically loaded from the AvaTax WSDL file's
#pod operations, and can be passed either a hash or reference to a hash with the
#pod necessary parameters. In scalar context they return a reference to a hash
#pod containing the results of the SOAP call; in list context they return the
#pod results hashref and an L<XML::Compile::SOAP::Trace|XML::Compile::SOAP::Trace>
#pod object suitable for debugging and exception handling.
#pod
#pod As of this writing the following operations are published in the Avalara
#pod AvaTax schema. Consult Avalara's Help Center for full documentation on input
#pod and output parameters for each operation.
#pod
#pod =cut

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
                transport => $self->transport,
                service   => $self->soap_service,
                port      => $self->soap_port,
            );
            $self->_compiled->{$method} = 1;
        }
        my ( $answer_ref, $trace ) = $self->call( $method => @_ );

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

version 0.001

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

Available method names are dynamically loaded from the AvaTax WSDL file's
operations, and can be passed either a hash or reference to a hash with the
necessary parameters. In scalar context they return a reference to a hash
containing the results of the SOAP call; in list context they return the
results hashref and an L<XML::Compile::SOAP::Trace|XML::Compile::SOAP::Trace>
object suitable for debugging and exception handling.

As of this writing the following operations are published in the Avalara
AvaTax schema. Consult Avalara's Help Center for full documentation on input
and output parameters for each operation.

If there is no result then an exception will be thrown.

=head2 get_tax

Example:

    use DateTime;
    use DateTime::Format::XSD;
    my ( $result_ref, $trace ) = $avatax->get_tax(
        CustomerCode => 'ABC4335',
        DocDate      => DateTime::Format::XSD->format_datetime(
            DateTime->new( year => 2014, month => 1, day => 1 ) ),
        CompanyCode  => 'APITrialCompany',
        DocCode      => 'INV001',
        DetailLevel  =>  'Tax',
        Commit       => 0,
        DocType      => 'SalesInvoice',
    );

=head2 post_tax

=head2 commit_tax

=head2 cancel_tax

=head2 adjust_tax

=head2 get_tax_history

=head2 is_authorized

=head2 ping

    use List::Util 1.33 'any';
    my ( $result_ref, $trace ) = $avatax->ping;
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

=head2 validate

=head1 OTHER METHODS AND ATTRIBUTES

Because this class consumes the
C<WebService::Avalara::AvaTax::Role::Connection> role, it also has
that role's attributes and methods. Please consult that module for attributes
important for establishing a connection such as C<username> and C<password>.
You can also use other attributes, such as the C<user_agent>
attribute to access the L<LWP::UserAgent|LWP::UserAgent> used to retrieve and
call the AvaTax service, or the C<wsdl> method to access the underlying
L<XML::Compile::WSDL11|XML::Compile::WSDL11> object.

=for Pod::Coverage BUILD

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

This software is copyright (c) 2015 by ZipRecruiter.  No
license is granted to other entities.

=cut
