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
use File::ShareDir 1.00 'dist_dir';
use Moo::Role;
use Package::Stash;
use Path::Tiny;
use Types::Path::Tiny qw(Dir Path);
use Types::Standard qw(Bool Str);
use XML::Compile::Dumper;
use namespace::clean;

=attr recompile

A boolean value you can set at construction to signal that the generated
class files for this service should be deleted and recompiled.
Defaults to false.

=cut

has recompile => ( is => 'ro', isa => Bool, default => 0 );

=attr dump_dir

The directory in which to save and look for the generated class files. Defaults
to the F<share> directory for the C<WebService-Avalara-AvaTax> distribution.

=cut

has dump_dir => ( is => 'lazy', isa => Dir, coerce => 1 );

sub _build_dump_dir {
    my $self     = shift;
    my $dump_dir = Path::Tiny->new( dist_dir('WebService-Avalara-AvaTax') );
    $dump_dir = -w "$dump_dir" ? $dump_dir : Path::Tiny->tempdir;
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
    default => sub { ref(shift) . '::Client' },
);

=attr clients

This role wraps around the builder for the C<clients> attribute to either read
in the generated class file (if it already exists) or generate it and then
add it to the symbol table.

=cut

around _build_clients => sub {
    my ( $orig, $self, @params ) = @_;

    my $package   = $self->_package_name;
    my $dump_file = $self->dump_dir->child( $self->dump_file_name );
    my $stash     = Package::Stash->new($package);

    if ( $dump_file->is_file and not $self->recompile ) {
        ## no critic (BuiltinFunctions::ProhibitStringyEval)
        # not sure if this is the right way to do it
        if ( eval( $dump_file->slurp ) and not $EVAL_ERROR ) {
            return { map { ( $_ => $stash->get_symbol("&$_") ) }
                    $stash->list_all_symbols('CODE') };
        }
    }

    my %clients = %{ $self->$orig(@params) };

    my $dumper = XML::Compile::Dumper->new(
        package  => $package,
        filename => "$dump_file",
    );
    $dumper->freeze(%clients);
    $dumper->close;
    while ( my ( $operation_name, $client ) = each %clients ) {
        $stash->add_symbol(
            "&$operation_name" => $client,
            filename           => "$dump_file",
        );
    }

    return \%clients;
};

1;
