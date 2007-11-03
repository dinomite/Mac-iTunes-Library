package Mac::iTunes::Library;

use 5;
use warnings;
use strict;
use Carp;

use XML::Parser;

require Exporter;
our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
# This allows declaration	use Mac::iTunes::Item ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw() ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw( );

our $VERSION = '0.01';

=head1 NAME

Mac::iTunes::Library - Perl extension for representing an iTunes library

=head1 SYNOPSIS

  use Mac::iTunes::Library;

  my $library = Mac::iTunes::Library->new();
  my $item = Mac::iTunes::Item->new(
  		'Track ID' => 1,
		'Name' => 'The Fooiest Song',
		'Artist' => 'The Bar Band',
		);
  $library->add($item);
  print "This library has only " . $library->items() . "item.\n";

=head1 DESCRIPTION

A data structure for representing an iTunes library.

The library keeps track of the number of tracks by each artist
(a hash of Artist => num_tracks) and the number of songs in each genre
(Genre => num_tracks).  Additionally, the total playcounts for each artist
(Artist => playcount_of_all_songs) and genre (Genre => playcount_of_all_songs)
are tallied.  Finally, all of the items in the library are available, sorted
by artist.

=head1 EXPORT

None by default.

=head1 METHODS

=head2 new()

Creates a new Mac::iTunes::Library object that can store Mac::iTunes::Item
objects.

=cut

sub new {
	my $class = shift;
	my $self = {
		Num => 0,			# Number of tracks in this library
		Size => 0,			# Size of all tracks
		Time => 0,			# Length of all tracks in milliseconds
		Artist => {},		# Artist counts in tracks
		PArtists => {},		# Artists counts by playcount
		Genre => {},		# Genre counts by tracks
		PGenre => {},		# Genre counts by playcount
		Type => {},			# Track types, file or URL
		Items => {}
	};

	bless $self, $class;
	return $self;
} #new

# Clean up
sub DESTROY {
	# Nothing to do.
} #DESTROY

=head2 num()

Get the number of tracks in the library

=cut

sub num {
	my $self = shift;
	return $self->{'Num'};
} #num

# Increment the number of tracks in the library
sub _num {
	my $self = shift;
	$self->{'Num'} += 1;
} #_num

=head2 size()

Get the total size of the library

=cut

sub size {
	my $self = shift;
	return $self->{Size};
} #size

# Add to the library's total size
sub _size {
	my $self = shift;
	my $num = shift;
	$self->{Size} += $num;
} #_size

=head2 time()

Get the total time of the library

=cut

sub time {
	my $self = shift;
	return $self->{Time};
} #time

# Add to the library's total time
sub _time {
	my $self = shift;
	my $time = shift;
	$self->{Time} += $time if (defined $time);
} #_time

=head2 artist()

Get the number of tracks for this artist.

=cut

sub artist {
	my $self = shift;
	return %{$self->{Artist}};
} #artist

# Increment the track count for the given artist
# ($artist)
sub _artist {
	my $self = shift;
	my $artist = shift;
	$self->{Artist}{ $artist } += 1;
} #artist

=head2 partist()

Get the number of plays (playcount) for this artist.

=cut

sub partist {
	my $self = shift;
	return %{$self->{PArtists}};
} #partist

# Increment the playcount for the given artist by a given amount
# ($artist, $num)
sub _partist {
	my $self = shift;
	my ($artist, $num) = @_;
	return unless ( (defined $num) and (defined $artist) );
	$self->{PArtists}{ $artist } += $num;
} #partist

=head2 genre()

Get the number of tracks in this genre.

=cut

sub genre {
	my $self = shift;
	return %{$self->{Genre}};
} #genre

# Incrment the track count for the given genre
# ($genre)
sub _genre {
	my $self = shift;
	my $genre = shift;
	$self->{Genre}{ $genre } += 1;
} #_genre

=head2 pgenre()

Get the number of plays (playcount) for this genre.

=cut

sub pgenre {
	my $self = shift;
	return %{$self->{PGenre}};
} #pgenre

# Increment the playcount for the given genre by a given amount
# ($genre, $playcount)
sub _pgenre {
	my $self = shift;
	my ($genre, $num) = @_;
	return unless ( (defined $num)  and (defined $genre) );
	$self->{PGenre}{ $genre } += $num;
} #_pgenre

=head2 type()

Get the hash of item types in the library

=cut

sub type {
	my $self = shift;
	return %{$self->{Type}};
} #type

# Increment the count of items of the given type
sub _type {
	my $self = shift;
	my $type = shift;
	$self->{Type}{ $type } += 1;
} #_type

=head2 add( Mac::iTunes::Item )

Add an item to the library

=cut

sub add {
	my $self = shift;
	my $item = shift;
	return carp "Not enough arguments." unless (defined $item);

	my $artist = $item->artist();
	my $name = $item->name();
	my $genre = $item->genre();
	my $playCount = $item->playCount();

	# Deal with possible null values
	$artist = 'Unknown' unless (defined $artist);
	$name = 'Unknown' unless (defined $name);
	$genre = 'Unknown' unless (defined $genre);
	$playCount = 0 unless (defined $playCount);

	# Tally up the item's data
	$self->_artist($artist);
	$self->_genre($genre);
	$self->_num();
	$self->_size($item->size()) if (defined $item->size());	# Streams = null
	$self->_time($item->totalTime());
	$self->_partist($item->artist(), $item->playCount());
	$self->_pgenre($item->genre(), $item->playCount());
	$self->_type($item->trackType());

	# Finally, add it to our collection of item
	if (exists $self->{'item'}{$artist}) {
		if (exists $self->{'item'}{$artist}{$name}) {
			push @{$self->{'item'}{$artist}{$name}}, $item;
		} else {
			# First occurrence of this title
			$self->{'item'}{$artist}{$name} = [$item];
		}
	} else {
		# First occurrence of this artist
		$self->{'item'}{$artist}{$name} = [$item];
	}
} #add

1;

=head1 SEE ALSO

Nothing.

=head1 AUTHOR

Drew Stephens, <lt>drewgstephens@gmail.com<gt>, http://dinomite.net

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Drew Stephens

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
__END__
