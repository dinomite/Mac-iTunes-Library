package Mac::iTunes::Library::Item;

use 5.006;
use warnings;
use strict;
use Carp;

require Exporter;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ( 'all' => [ qw() ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw( );

our $VERSION = '0.02';

my $dateRegex = '\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z';

=head1 NAME

Mac::iTunes::Library::Item - Perl extension for representing an item
(song, URL, video) within an iTunes library.

=head1 SYNOPSIS

  use Mac::iTunes::Library::Item;

  my $item = Mac::iTunes::Item->new(
  		'Track ID' => 1,
		'Name' => 'The Fooiest Song',
		'Artist' => 'The Bar Band',
		);
  $item->genre('Ska');
  print "We are the " . $item->artist() . " and we play " .
  $item->genre() . " music\n";
  print "Enjoy our hit song " . $item->name() . "\n";

=head1 DESCRIPTION

A data structure for representing an item (song, URL, video) within an iTunes
library.  Use this along with Mac::iTunes::Library to create an iTunes library
from which other information can be gleaned.

=head1 EXPORT

None by default.


=head1 METHODS

=head2 new()

Creates a new Mac::iTunes::Item object that can store all of the data of an
iTunes library item.

	my $rec = Mac::iTunes::Item->new();

The constructor can also be called initializing any number of the attributes of
an item

	my $rec = Mac::iTunes::Item->new(
		'Track ID' => '73',
		'Name' => 'Josie',
		'Artist' => 'blink-182',
		'Genre' => 'Pop Punk',
		'Kind' => 'MPEG audio file',
		'Size' => 31337,
		'Total Time' => 31337,
		'Year' => '2007',
		'Date Modified' => '2007-01-01T01:01:01Z',
		'Date Added' => '2007-01-01T01:01:01Z',
		'Bit Rate' => 256,
		'Sample Rate' => 44100,
		'Play Count' => 1,
		'Play Date' => -1167613261,
		'Play Date UTC' => '2007-01-01T01:01:01Z',
		'Rating' => 50,
		'Persistent ID' => 'DAC2FC501CCA2031',
		'Track Type' => 'File',
		'Location' => 'file://localhost/Users/dinomite/Music/blink-182/Dude%20Ranch/Josie.mp3',
		'File Folder Count' => 4,
		'Library Folder Count' => 1
	);

=cut

sub new {
	my $class = shift;
	my %params = @_;

	my $self = {
		'Track ID' => undef,
		'Name' => undef,
		'Artist' => undef,
		'Genre' => undef,
		'Kind' => undef,
		'Size' => undef,
		'Total Time' => undef,
		'Year' => undef,
		'Date Modified' => undef,
		'Date Added' => undef,
		'Bit Rate' => undef,
		'Sample Rate' => undef,
		'Play Count' => undef,
		'Play Date' => undef,
		'Play Date UTC' => undef,
		'Rating' => undef,
		'Persistent ID' => undef,
		'Track Type' => undef,
		'Location' => undef,
		'File Folder Count' => undef,
		'Library Folder Count' => undef,
	};

	bless $self, $class;

	# Deal with parameters
	if ( exists( $params{'Track ID'} ) ) {
		trackID( $self, $params{'Track ID'} );
	} if ( exists( $params{'Name'} ) ) {
		name( $self, $params{'Name'} );
	} if ( exists( $params{'Artist'} ) ) {
		artist( $self, $params{'Artist'} );
	} if ( exists( $params{'Genre'} ) ) {
		genre( $self, $params{'Genre'} );
	} if ( exists( $params{'Kind'} ) ) {
		kind( $self, $params{'Kind'} );
	} if ( exists( $params{'Size'} ) ) {
		size( $self, $params{'Size'} );
	} if ( exists( $params{'Total Time'} ) ) {
		totalTime( $self, $params{'Total Time'} );
	} if ( exists( $params{'Year'} ) ) {
		year( $self, $params{'Year'} );
	} if ( exists( $params{'Date Modified'} ) ) {
		dateModified( $self, $params{'Date Modified'} );
	} if ( exists( $params{'Date Added'} ) ) {
		dateAdded( $self, $params{'Date Added'} );
	} if ( exists( $params{'Bit Rate'} ) ) {
		bitRate( $self, $params{'Bit Rate'} );
	} if ( exists( $params{'Sample Rate'} ) ) {
		sampleRate( $self, $params{'Sample Rate'} );
	} if ( exists( $params{'Play Count'} ) ) {
		playCount( $self, $params{'Play Count'} );
	} if ( exists( $params{'Play Date'} ) ) {
		playDate( $self, $params{'Play Date'} );
	} if ( exists( $params{'Play Date UTC'} ) ) {
		playDateUTC( $self, $params{'Play Date UTC'} );
	} if ( exists( $params{'Rating'} ) ) {
		rating( $self, $params{'Rating'} );
	} if ( exists( $params{'Persistent ID'} ) ) {
		persistentID( $self, $params{'Persistent ID'} );
	} if ( exists( $params{'Track Type'} ) ) {
		trackType( $self, $params{'Track Type'} );
	} if ( exists( $params{'Location'} ) ) {
		location( $self, $params{'Location'} );
	} if ( exists( $params{'File Folder Count'} ) ) {
		fileFolderCount( $self, $params{'File Folder Count'} );
	} if ( exists( $params{'Library Folder Count'} ) ) {
		libraryFolderCount( $self, $params{'Library Folder Count'} );
	}

	return $self;
} #new

# Clean up
sub DESTROY {
# Nothing to do.
} #DESTROY

=head2 $rec->trackID( $id )

Get/set the Track ID attribute for this item.

=cut

sub trackID {
	my $self = shift;

	if (@_) {
		my $id = shift;
		return carp "$id isn't a valid Track ID" unless ($id =~ /\d*/);
		$self->{'Track ID'} = $id;
	}

	return $self->{'Track ID'};
} #trackID

# Get/set the Name for this item
sub name {
	my $self = shift;

	if (@_) {
		my $name = shift;
		return carp "$name isn't a valid Name" unless ($name =~ /.*/);
		$self->{'Name'} = $name;
	}

	return $self->{'Name'};
} #name

=head2 $rec->artist( $artist )

Get/set the Artist attribute for this item.

=cut

sub artist {
	my $self = shift;

	if (@_) {
		my $artist = shift;
		return carp "$artist isn't a valid Artist" unless ($artist =~ /.*/);
		$self->{'Artist'} = $artist;
	}

	return $self->{'Artist'};
} #artist

=head2 $rec->genre( $genre )

Get/set the Genre attribute for this item.

=cut

sub genre {
	my $self = shift;

	if (@_) {
		my $genre = shift;
		return carp "$genre isn't a valid Genre" unless ($genre =~ /.*/);
		$self->{'Genre'} = $genre;
	}

	return $self->{'Genre'};
} #genre

=head2 $rec->kind( $kind )

Get/set the Kind ("MPEG audio file", etc.) attribute for this item.

=cut

sub kind {
	my $self = shift;

	if (@_) {
		my $kind = shift;
		return carp "$kind isn't a valid Kind"
			unless ($kind =~ /(MPEG|AAC|MPEG-4|Audible) ?(audio|video)? (file|stream)/);
		$self->{'Kind'} = $kind;
	}

	return $self->{'Kind'};
} #kind

=head2 $rec->size( $size )

Get/set the Size attribute for this item.

=cut

sub size {
	my $self = shift;

	if (@_) {
		my $size = shift;
		return carp "$size isn't a valid Size" unless ($size =~ /\d*/);
		$self->{'Size'} = $size;
	}

	return $self->{'Size'};
} #size

=head2 $rec->totalTime( $totalTime )

Get/set the Total Time attribute for this item.

=cut

sub totalTime {
	my $self = shift;

	if (@_) {
		my $totalTime = shift;
		return carp "$totalTime isn't a valid Total Time"
			unless ($totalTime =~ /\d*/);
		$self->{'Total Time'} = $totalTime;
	}

	return $self->{'Total Time'};
} #totalTime

=head2 $rec->year( $year )

Get/set the Year attribute for this item.

=cut

sub year {
	my $self = shift;

	if (@_) {
		my $year = shift;
		return carp "$year isn't a valid Year" unless ($year =~ /\d{4}/);
		$self->{'Year'} = $year;
	}

	return $self->{'Year'};
} #year

=head2 $rec->dateModified( $dateModified )

Get/set the Date Modified attribute for this item.

=cut

sub dateModified {
	my $self = shift;

	if (@_) {
		my $dateModified = shift;
		return carp "$dateModified isn't a valid Date Modified"
			unless ($dateModified =~ /$dateRegex/);
		$self->{'Date Modified'} = $dateModified;
	}

	return $self->{'Date Modified'};
} #dateModified

=head2 $rec->dateAdded( $dateAdded )

Get/set the Date Added attribute for this item.

=cut

sub dateAdded {
	my $self = shift;

	if (@_) {
		my $dateAdded = shift;
		return carp "$dateAdded isn't a valid Date Added"
			unless ($dateAdded =~ /$dateRegex/);
		$self->{'Date Added'} = $dateAdded;
	}

	return $self->{'Date Added'};
} #dateAdded

=head2 $rec->dateAdded( $dateAdded )

Get/set the Date Added attribute for this item.

=cut

sub bitRate {
	my $self = shift;

	if (@_) {
		my $bitRate = shift;
		return carp "$bitRate isn't a valid Bit Rate"
			unless ($bitRate =~ /\d{2,3}/);
		$self->{'Bit Rate'} = $bitRate;
	}

	return $self->{'Bit Rate'};
} #bitRate

=head2 $rec->sampleRate( $sampleRate )

Get/set the Sample Rate attribute for this item.

=cut

sub sampleRate {
	my $self = shift;

	if (@_) {
		my $sampleRate = shift;
		return carp "$sampleRate isn't a valid Sample Rate"
			unless ($sampleRate =~ /\d{5}/);
		$self->{'Sample Rate'} = $sampleRate;
	}

	return $self->{'Sample Rate'};
} #sampleRate

=head2 $rec->playCount( $playCount )

Get/set the Play Count attribute for this item.

=cut

sub playCount {
	my $self = shift;

	if (@_) {
		my $playCount = shift;
		return carp "$playCount isn't a valid Play Count"
			unless ($playCount =~ /\d{1,2}/);
		$self->{'Play Count'} = $playCount;
	}

	return $self->{'Play Count'};
} #playCount

=head2 $rec->playDate( $playDate )

Get/set the Play Date attribute for this item.

=cut

sub playDate {
	my $self = shift;

	if (@_) {
		my $playDate = shift;
		return carp "$playDate isn't a valid Play Date"
			unless ($playDate =~ /-\d{10}/);
		$self->{'Play Date'} = $playDate;
	}

	return $self->{'Play Date'};
} #playDate

=head2 $rec->playDateUTC( $playDateUTC )

Get/set the Play Date UTC attribute for this item.

=cut

sub playDateUTC {
	my $self = shift;

	if (@_) {
		my $playDateUTC = shift;
		return carp "$playDateUTC isn't a valid Play Date UTC"
			unless ($playDateUTC =~ /$dateRegex/);
		$self->{'Play Date UTC'} = $playDateUTC;
	}

	return $self->{'Play Date UTC'};
} #playDateUTC

=head2 $rec->rating( $rating )

Get/set the Rating attribute for this item.

=cut

sub rating {
	my $self = shift;

	if (@_) {
		my $rating = shift;
		return carp "$rating isn't a valid Rating"
			unless ($rating =~ /\d{1,3}/);
		$self->{'Rating'} = $rating;
	}

	return $self->{'Rating'};
} #rating

=head2 $rec->persistentID( $persistentID )

Get/set the Persistent ID attribute for this item.

=cut

sub persistentID {
	my $self = shift;

	if (@_) {
		my $persistentID = shift;
		return carp "$persistentID isn't a valid Persistent ID"
			unless ($persistentID =~ /\w{16}/);
		$self->{'Persistent ID'} = $persistentID;
	}

	return $self->{'Persistent ID'};
} #persistentID

=head2 $rec->trackType( $trackType )

Get/set the Track Type attribute for this item.

=cut

sub trackType {
	my $self = shift;

	if (@_) {
		my $trackType = shift;
		return carp "$trackType isn't a valid Track Type"
			unless ($trackType =~ /(File|URL)/);
		$self->{'Track Type'} = $trackType;
	}

	return $self->{'Track Type'};
} #trackType

=head2 $rec->location( $location )

Get/set the Location attribute for this item.

=cut

sub location {
	my $self = shift;

	if (@_) {
		my $location = shift;
		return carp "$location isn't a valid Location"
			unless ($location =~ /.*/);
		$self->{'Location'} = $location;
	}

	return $self->{'Location'};
} #location

=head2 $rec->fileFolderCount( $fileFolderCount )

Get/set the File Folder Count attribute for this item.

=cut
# Get/set the File Folder Count for this item
sub fileFolderCount {
	my $self = shift;

	if (@_) {
		my $fileFolderCount = shift;
		return carp "$fileFolderCount isn't a valid File Folder Count"
			unless ($fileFolderCount =~ /\d*/);
		$self->{'File Folder Count'} = $fileFolderCount;
	}

	return $self->{'File Folder Count'};
} #fileFolderCount

=head2 $rec->libraryFolderCount( $libraryFolderCount )

Get/set the Library Folder Count attribute for this item.

=cut

sub libraryFolderCount {
	my $self = shift;

	if (@_) {
		my $libraryFolderCount = shift;
		return carp "$libraryFolderCount isn't a valid Library Folder Count"
			unless ($libraryFolderCount =~ /\d*/);
		$self->{'Library Folder Count'} = $libraryFolderCount;
	}

	return $self->{'Library Folder Count'};
} #libraryFolderCount

1;

=head1 SEE ALSO

L<Mac::iTunes>, L<Mac::iTunes::Library>

=head1 AUTHOR

Drew Stephens, <lt>drewgstephens@gmail.com<gt>, http://dinomite.net

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Drew Stephens

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
__END__
