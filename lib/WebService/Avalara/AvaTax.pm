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
                transport => $self->transport,
                service   => $self->soap_service,
                port      => $self->soap_port,
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

=method post_tax

=method commit_tax

=method cancel_tax

=method adjust_tax

=method get_tax_history

=method is_authorized

=method ping

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

=method validate
