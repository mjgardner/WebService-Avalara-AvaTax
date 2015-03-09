package WebService::Avalara::AvaTax::Role::Connection;

# ABSTRACT: Wrapper for Avalara AvaTax web services

use Modern::Perl '2011';    ## no critic (Modules::ProhibitUseQuotedVersion)

our $VERSION = '0.003';     # TRIAL VERSION
use utf8;

#pod =head1 SYNOPSIS
#pod
#pod     use Moo;
#pod     with 'WebService::Avalara::AvaTax::Role::Connection';
#pod
#pod =head1 DESCRIPTION
#pod
#pod This role integrates
#pod L<Avalara AvaTax web services|http://developer.avalara.com/api-docs/soap>.
#pod
#pod =cut

use Const::Fast;
use English '-no_match_vars';
use Log::Report;
use LWPx::UserAgent::Cached;
use Scalar::Util 'blessed';
use Sys::Hostname;
use Types::Standard qw(Bool InstanceOf Str);
use URI;
use XML::Compile::SOAP::WSS;
use XML::Compile::SOAP11;
use XML::Compile::SOAP12;
use XML::Compile::WSDL11;
use XML::Compile::Transport::SOAPHTTP;
use MooX::Types::MooseLike::Email 'EmailAddressLoose';
use Moo::Role;

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

#pod =attr soap_service
#pod
#pod The SOAP service name for AvaTax. Defaults to C<TaxSvc>.
#pod
#pod =cut

has soap_service => ( is => 'ro', isa => Str, default => 'TaxSvc' );

#pod =attr soap_port
#pod
#pod The SOAP service name for AvaTax. Defaults to C<TaxSvcSoap>.
#pod
#pod =cut

has soap_port => ( is => 'ro', isa => Str, default => 'TaxSvcSoap' );

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

#pod =attr endpoint
#pod
#pod A L<URI|URI> object indicating the AvaTax WSDL file to load. Defaults to
#pod L<https://development.avalara.net/tax/taxsvc.wsdl>. For production API access
#pod one should set this to L<https://avatax.avalara.net/tax/taxsvc.wsdl>.
#pod
#pod =cut

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

#pod =attr transport
#pod
#pod An L<XML::Compile::Transport::SOAPHTTP|XML::Compile::Transport::SOAPHTTP>
#pod object used to make SOAP calls. By default it uses C<user_agent> along with
#pod C<wsdl>'s C<endPoint> for the address, and adds a handler for C<POST>s to
#pod the endpoint to add the appropriate C<SOAPAction> HTTP header.
#pod
#pod =cut

has transport =>
    ( is => 'lazy', isa => InstanceOf ['XML::Compile::Transport::SOAPHTTP'] );

sub _build_transport {
    my $self = shift;
    my $wss  = $self->_wss;
    my $wsdl = $self->wsdl;
    my $auth = $self->_auth;

    my $user_agent  = $self->user_agent;
    my %soap_params = (
        service => $self->soap_service,
        port    => $self->soap_port,
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

#pod =method call
#pod
#pod Given an operation name and parameters, makes a SOAP call.
#pod
#pod =cut

sub call {
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

has wsdl => ( is => 'lazy', isa => InstanceOf ['XML::Compile::WSDL11'] );

sub _build_wsdl {
    my $self = shift;
    return XML::Compile::WSDL11->new(
        $self->user_agent->get( $self->endpoint )->content );
}

1;

__END__

=pod

=encoding UTF-8

=for :stopwords Mark Gardner ZipRecruiter cpan testmatrix url annocpan anno bugtracker rt
cpants kwalitee diff irc mailto metadata placeholders metacpan

=head1 NAME

WebService::Avalara::AvaTax::Role::Connection - Wrapper for Avalara AvaTax web services

=head1 VERSION

version 0.003

=head1 SYNOPSIS

    use Moo;
    with 'WebService::Avalara::AvaTax::Role::Connection';

=head1 DESCRIPTION

This role integrates
L<Avalara AvaTax web services|http://developer.avalara.com/api-docs/soap>.

=head1 ATTRIBUTES

=head2 username

The Avalara email address used for authentication. Required.

=head2 password

The password used for Avalara authentication. Required.

=head2 soap_service

The SOAP service name for AvaTax. Defaults to C<TaxSvc>.

=head2 soap_port

The SOAP service name for AvaTax. Defaults to C<TaxSvcSoap>.

=head2 endpoint

A L<URI|URI> object indicating the AvaTax WSDL file to load. Defaults to
L<https://development.avalara.net/tax/taxsvc.wsdl>. For production API access
one should set this to L<https://avatax.avalara.net/tax/taxsvc.wsdl>.

=head2 debug

When set to true, the L<Log::Report|Log::Report> dispatcher used by
L<XML::Compile|XML::Compile> and friends is set to I<DEBUG> mode.

=head2 transport

An L<XML::Compile::Transport::SOAPHTTP|XML::Compile::Transport::SOAPHTTP>
object used to make SOAP calls. By default it uses C<user_agent> along with
C<wsdl>'s C<endPoint> for the address, and adds a handler for C<POST>s to
the endpoint to add the appropriate C<SOAPAction> HTTP header.

=head2 user_agent

An instance of an L<LWP::UserAgent|LWP::UserAgent> (sub-)class. You can
use your own subclass to add features such as caching or enhanced logging.

If you do not specify a C<user_agent> then we default to an
L<LWPx::UserAgent::Cached|LWPx::UserAgent::Cached> with its C<ssl_opts>
parameter set to C<< {verify_hostname => 0} >>.

=head1 METHODS

=head2 call

Given an operation name and parameters, makes a SOAP call.

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
