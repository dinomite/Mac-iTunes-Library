# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Mac-iTunes-Item.t'

#########################
use lib "./lib";
use 5;
use Test::More tests => 7;
BEGIN {
	use_ok('Library');
	use_ok('Item', 'use Item');
};
#########################

# Create a new item
my $library = Mac::iTunes::Library->new();

# Check the very basics
ok(defined($library), 'Create object');
is($library->isa('Mac::iTunes::Library'), 1, 'Object type');

# Parse the sample library
$library->parse_xml('t/iTunes Music Library.xml');

is($library->num(), 18, 'Number of tracks');
is($library->size(), 90103155, 'Library size');
is($library->time(), 4209362, 'Total time');
