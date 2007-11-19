package Mac::iTunes::XML;

use 5.006;
use warnings;
use strict;
use Carp;

use Mac::iTunes::Library;
use XML::Parser;

require Exporter;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ( 'all' => [ qw() ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw( );

our $VERSION = '0.01_01';

=head1 NAME

Mac::iTunes::XML - Perl extension for parsing an iTunes XML library

=head1 SYNOPSIS

  use Mac::iTunes::XML;

  my $library = Mac::iTunes::XML->parse( 'iTunes Music Library.xml' );
  print "This library has only " . $library->num() . "item.\n";

=head1 DESCRIPTION

Tools for dealing with iTunes XML libraries.

=head1 EXPORT

None by default.

=head1 METHODS

=head2 parse()

Parses an iTunes XML library and returns a Mac::iTunes::Library object.

=cut

sub parse {
	my $self = shift;
	my $xmlFile = shift;
	our $library = Mac::iTunes::Library->new();

	# Keep track of where we are
	our @stack;
	our ($item, $curKey, $characters, $inTracks, $inPlaylists) = undef;

	my $parser = XML::Parser->new( Handlers =>
					{
						Start => \&start_element,
						End => \&end_element,
						Char => \&characters,
					});
	$parser->parsefile( $xmlFile );
	return $library;

	### Parser start element
	sub start_element {
		my ($expat, $element, %attrs) = @_;

		# Don't deal with playlists yet
		return if ($inPlaylists);
		
		# Keep a trail of our depth
		push @stack, $element;
		my $depth = scalar(@stack);

		if ( $depth == 0 ) {		# plist version
		} elsif ( $depth == 1 ) {	# dict
		} elsif ( $depth == 2 ) {
		} elsif ( $depth == 3 ) {
		} elsif ( $depth == 4 ) {
			# We hit a new item in the XML; create a new object
			$item = Mac::iTunes::Library::Item->new() if ($element eq 'dict');
		}
	} #start_element


	### Parser end element
	sub end_element {
		my ($expat, $element) = @_;

		# Don't deal with playlists yet
		return if ($inPlaylists);

		# Prune the trail
		my $depth = scalar(@stack);
		pop @stack;

		if ( $depth == 0 ) {		# plist version
		} elsif ( $depth == 1 ) {	# dict
		} elsif ( $depth == 2 ) {
		} elsif ( $depth == 3 ) {
			$inTracks = 0 if ($element eq 'dict');
			$inPlaylists = 0 if ($element eq 'array');
		} elsif ( $depth == 4 ) {
			# Ending an item; add it to the library and clean up
			if ( $item ) {
				$library->add($item);
			}

			$item = undef if ($element eq 'dict');
		} elsif ( $depth == 5 ) {
			if ( $element =~ /(integer|string|date)/ ) {
				$item->{$curKey} = $characters;
				$characters = undef;
			}
		}
	} #end_element


	### Parser element contents
	sub characters {
		my ($expat, $string) = @_;
		my $depth = scalar(@stack);

		return if ($inPlaylists);

		if ( $depth == 0 ) {		# plist version
		} elsif ( $depth == 1 ) {	# dict
		} elsif ( $depth == 2 ) {
		} elsif ( $depth == 3 ) {
			if ( $stack[$#stack] eq 'key' ) {
				if ( $string eq 'Tracks' ) {
					$inTracks = 1;
				} elsif ( $string eq 'Playlists' ) {
					$inPlaylists = 1;
				}
			}
		} elsif ( $depth == 4 ) {
		} elsif ( $depth == 5 ) {
			if ( $stack[$#stack] eq 'key' ) {
				# Grab the key's name
				$curKey = $string;
			} elsif ( $stack[$#stack] =~ /(integer|string|date)/ ) {
				# Set the item's value for the previously grabbed key
				$characters .= $string;
			}
		}
	} #characters
} #parse

# Clean up
sub DESTROY {
	# Nothing to do.
} #DESTROY

1;

=head1 SEE ALSO

L<Mac::iTunes>, L<Mac::iTunes::Item>, L<Mac::iTunes::Library>

=head1 AUTHOR

Drew Stephens, <lt>drewgstephens@gmail.com<gt>, http://dinomite.net

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Drew Stephens

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
__END__
