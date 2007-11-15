# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Mac-iTunes-Item.t'

#########################
use lib "./lib";
use 5;
use Test::More tests => 10;
BEGIN {
	use_ok('Mac::iTunes::Library');
	use_ok('Mac::iTunes::XML');
	use_ok('Mac::iTunes::Item');
};
#########################

# Create a new item
my $library = Mac::iTunes::Library->new();

# Check the very basics
ok( defined($library), 'Create object' );
is( $library->isa('Mac::iTunes::Library'), 1, 'Library Object type' );

# Parse the sample library
$library = Mac::iTunes::XML->parse('t/iTunes_Music_Library.xml');

is( $library->num(), 18, 'Number of tracks' );
is( $library->size(), 90103155, 'Library size' );
is( $library->time(), 4209362, 'Total time' );

my %items = $library->items();
isnt( %items, undef, 'Items hash from items()' );
is( $items{'ATB'}{'Push the Limits'}[0]->playCount(), 5, 'Item playcount' );
