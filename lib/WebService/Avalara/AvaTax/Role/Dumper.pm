package WebService::Avalara::AvaTax::Role::Dumper;

# ABSTRACT: Dump and restore compiled SOAP clients for AvaTax

use Modern::Perl '2011';    ## no critic (Modules::ProhibitUseQuotedVersion)

# VERSION
use utf8;

=head1 SYNOPSIS

    use Moo;
    with 'WebService::Avalara::AvaTax::Role::Dumper';

=head1 DESCRIPTION

This role handles the dumping of compiled SOAP client code to storage,
and then restoring it later to save time without having to recompile.

=cut

use English '-no_match_vars';
use Moo::Role;
use Package::Stash;
use Path::Tiny 0.018;
use Types::Path::Tiny qw(Dir Path);
use Types::Standard qw(Bool Str);
use XML::Compile::Dumper;
use namespace::clean;

=attr use_wss

This role overrides the value of the
L<use_wss attribute from WebService::Avalara::AvaTax::Role::Connection|WebService::Avalara::AvaTax::Role::Connection/use_wss>
to false, since L<XML::Compile::WSS|XML::Compile::WSS> does not seem to
work cleanly with L<XML::Compile::Dumper|XML::Compile::Dumper>.

=cut

around BUILDARGS => sub {
    return { @_[ 2 .. $#_ ], use_wss => 0 };
};

=cut

=attr recompile

A boolean value you can set at construction to signal that the generated
class files for this service should be deleted and recompiled.
Defaults to false.

=cut

has recompile => ( is => 'ro', isa => Bool, default => 0 );

=attr dump_dir

The directory in which to save and look for the generated class files.
Defaults to a temporary directory provided by
L<Path::Tiny::tempdir|Path::Tiny>.

=head1 CAVEATS

The generated class files in the L</dump_dir> directory will be read and
executed, therefore it is B<critical> that this directory is in a secure
location on the file system that cannot be written to by untrusted users
or processes!

=cut

has dump_dir => ( is => 'lazy', isa => Dir, coerce => 1 );

sub _build_dump_dir {
    my $self = shift;
    my $dump_dir = Path::Tiny->tempdir( TEMPLATE => 'AvalaraDumpXXXXX' );
    unshift @INC => "$dump_dir";
    return $dump_dir;
}

=attr dump_file_name

The path to the file in L</dump_dir> used to save/read the generated classes.
Defaults to F<< lib/I<package-name-converted-to-path.pm> >>.

=cut

has dump_file_name => ( is => 'lazy', isa => Path, coerce => 1 );

sub _build_dump_file_name {
    my $self     = shift;
    my $dump_dir = $self->dump_dir;

    my $dump_file = $self->_package_name;
    $dump_file =~ s/ :: /\//xmsg;
    $dump_file = Path::Tiny->new("lib/$dump_file.pm");

    $dump_dir->child($dump_file)->parent->mkpath;
    return $dump_file;
}

has _package_name => (
    is      => 'lazy',
    isa     => Str,
    default => sub { ref( $_[0] ) . q{::} . $_[0]->service },
);

=attr clients

This role wraps around the builder for the C<clients> attribute to either read
in the generated class file (if it already exists) or generate it and then
add it to the symbol table.

=cut

around _build_clients => sub {
    my ( $orig, $self, @params ) = @_;

    my $package = $self->_package_name;
    my $path    = $self->dump_dir->child( $self->dump_file_name );

    if ( $path->is_file and not $self->recompile ) {
        require "$path";    ## no critic (Modules::RequireBarewordIncludes)
        my $stash = Package::Stash->new($package);
        return { map { ( $_ => $stash->get_symbol("&$_") ) }
                $stash->list_all_symbols('CODE') };
    }

    my %clients = %{ $self->$orig(@params) };
    $self->_write_dump_file( "$path", $package, %clients );
    return \%clients;
};

sub _write_dump_file {
    my ( $self, $path, $package, %clients ) = @_;

    my $dumper = XML::Compile::Dumper->new(
        package => ( $package || $self->_package_name ),
        filename => "$path",
    );

    my $dump_fh = $dumper->file;
    $dump_fh->print(<<'END_PERL');
use URI::https;
use LWPx::UserAgent::Cached;
use HTTP::Config;
use Mozilla::CA;
use XML::Compile::WSDL11;
use XML::Compile::SOAP11;

BEGIN { $ENV{HTTPS_CA_FILE} = Mozilla::CA::SSL_ca_file() }
END_PERL
    $dump_fh->print( 'use ' . ref($self) . ";\n" );

    $dumper->freeze(%clients);
    $dumper->close;

    local @ARGV         = ("$path");
    local $INPLACE_EDIT = '.bak';
    while (<>) { / weaken [(] [\$] s [)] /xms or print }
    Path::Tiny->new("$path$INPLACE_EDIT")->remove;

    return;
}

1;
