# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Mac-iTunes-Item.t'

=head1 SVN INFO

$Revision$
$Date$
$Author$

=head1 AUTHOR

Mark Grimes <mgrimes@cpan.org>, http://www.peculiarities.com

=cut

#########################
use lib ".";
use 5;
use Test::More tests => 5;
BEGIN { use_ok('Mac::iTunes::Library::XML') };
#########################

my $lib = Mac::iTunes::Library::XML->parse('t/iTunes_Music_Library.xml');

my %playlists = $lib->playlists;
is( scalar keys %playlists, 2, 'playlist count' );
my $playlist = $playlists{10073};
ok( $playlist, 'found expected playlist' );
is( $playlist->name, '5 Stars', '... has the right name' );
is( scalar $playlist->items, 17, '... has the right track count' );
