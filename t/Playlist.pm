# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as
# `perl Mac-iTunes-Library-Playlist.t'

#########################
use lib ".";
use 5;
use Test::More tests => 5;
BEGIN { use_ok('Mac::iTunes::Library::Item') };
BEGIN { use_ok('Mac::iTunes::Library::Playlist') };
#########################

# Let's create a few simple items
my @items = (
        Mac::iTunes::Library::Item->new('Track ID' => 3),
        Mac::iTunes::Library::Item->new('Track ID' => 4),
        );
# Create a playlist
my $smartInfo =<< 'EOF';
AQEAAwAAAAIAAAAZAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAA==
EOF

my $smartCriteria =<< 'EOF';
U0xzdAABAAEAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABkAAAABAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABEAAAAAAAAAGQAAAAAAAAAAAAAAAAAAAAB
AAAAAAAAAGQAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAA=
EOF

my $playlist = Mac::iTunes::Library::Playlist->new(
        'Name' => '5 Stars',
        'Playlist ID' => '10073',
        'Playlist Persistent ID' => '2E2D1396AF1DED73',
        'All Items' => 'true',
        'Smart Info' => $smartInfo,
        'Smart Criteria' => $smartCriteria,
        'Playlist Items' => @items,
        );

# Check the very basics
ok(defined($playlist), 'Create object');
is($item->isa('Mac::iTunes::Library::Playlist'), 1, 'Object type');

# Add another item to that playlist
my $item = Mac::iTunes::Library::Item->new( 'Track ID' => 7 );
$playlist->addItem( $item );
is($playlist->item(7), $item, 'Adding or retrieving item');
