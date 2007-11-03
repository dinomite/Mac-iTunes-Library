# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Mac-iTunes-Item.t'

#########################
use lib ".";
use 5;
use Test::More tests => 24;
BEGIN { use_ok('Item') };
#########################

# Define the values for a item in a hash
my %values = (
	'Track ID' => 1,
	'Name' => 'Track Name',
	'Artist' => 'Artist Name',
	'Genre' => 'Genre Name',
	'Kind' => 'MPEG audio file',
	'Size' => 31337,
	'Total Time' => 31337,
	'Year' => '2007',
	'Date Modified' => '2007-01-01T01:01:01Z',
	'Date Added' => '2007-01-01T01:01:01Z',
	'Bit Rate' => 128,
	'Sample Rate' => 44100,
	'Play Count' => 1,
	'Play Date' => -1167613261,
	'Play Date UTC' => '2007-01-01T01:01:01Z',
	'Rating' => 50,
	'Persistent ID' => 'DAC2FC501CCA2031',
	'Track Type' => 'File',
	'Location' => 'file://localhost/Users/dinomite/Music/Artist%20Name/Track%20Name.mp3',
	'File Folder Count' => 4,
	'Library Folder Count' => 1
);

# Create a new item
my $rec = Mac::iTunes::Item->new(%values);

# Check the very basics
ok(defined($rec), 'Create object');
is($rec->isa('Mac::iTunes::Item'), 1, 'Object type');

# Make sure data is stored properly
is($rec->trackID(), $values{'Track ID'}, 'Get Track ID');
is($rec->name(), $values{'Name'}, 'Get Name');
is($rec->artist(), $values{'Artist'}, 'Get Artist');
is($rec->genre(), $values{'Genre'}, 'Get Genre');
is($rec->kind(), $values{'Kind'}, 'Get Kind');
is($rec->size(), $values{'Size'}, 'Get Size');
is($rec->totalTime(), $values{'Total Time'}, 'Get Total Time');
is($rec->year(), $values{'Year'}, 'Get Year');
is($rec->dateModified(), $values{'Date Modified'}, 'Get Date Modified');
is($rec->dateAdded(), $values{'Date Added'}, 'Get Added');
is($rec->bitRate(), $values{'Bit Rate'}, 'Get Bit Rate');
is($rec->sampleRate(), $values{'Sample Rate'}, 'Get Sample Rate');
is($rec->playCount(), $values{'Play Count'}, 'Get Play Count');
is($rec->playDate(), $values{'Play Date'}, 'Get Play Date');
is($rec->playDateUTC(), $values{'Play Date UTC'}, 'Get Play Date UTC');
is($rec->rating(), $values{'Rating'}, 'Get Rating');
is($rec->persistentID(), $values{'Persistent ID'}, 'Get Persistent ID');
is($rec->trackType(), $values{'Track Type'}, 'Get Track Type');
is($rec->location(), $values{'Location'}, 'Get Location');
is($rec->fileFolderCount(), $values{'File Folder Count'}, 'Get File Folder Count');
is($rec->libraryFolderCount(), $values{'Library Folder Count'}, 'Get Total Time');
