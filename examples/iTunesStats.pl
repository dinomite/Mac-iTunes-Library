#!/usr/bin/perl -w
=head1 NAME

examples/iTunesStats.pl

=head1 SYNOPSIS

perl iTunesStats.pl /path/to/itunes/music/library.xml num_top_items

=head1 DESCRIPTION

Parse iTunes XML libraries and print some aggregate statistics.

=cut

use warnings;
use strict;

use lib '../lib';
use Item;
use Library;
use XML;

my $usage = "iTunesStats.pl library.xml number\n";

die $usage if (scalar(@ARGV) != 2);
my $file = $ARGV[0];
my $topNum = $ARGV[1];

# Make a new Library
my $library = Mac::iTunes::Library->new();
$library = Mac::iTunes::XML->parse($file);

# This parses the library XML file without using Mac::iTunes::Library's built-in
# parser that employs XML::Parser
#### Open the library
###open IN, "<$file" or die "Couldn't open library for reading: $!";
###
#### Loop control; are we inside an item?
###my $inside = undef;
###my $item = undef;
#### Gather data about a item, build a new one, add it to the library
###my $line = <IN>;
###while (defined $line) {
###	chomp $line;
###	# Stop when we hit playlists
###	last if ( $line =~ m/^\t<key>Playlists<\/key>$/ );
###
###	# When we hit a new song key, loop to find the information we want
###	if (defined $inside) {
###		# Breakout when we reach the end of this item
###		if ( $line =~ m/^\t\t<\/dict>$/ ) {
###			# End of the item; add it to the library and move on
###			$library->add($item);
###			$item = undef;
###			$inside = undef;
###			next;
###		}
###
###		# Get the item's attributes
###		$item = handleLine($line, $item);
###	} elsif ($line =~ /^\t\t<key>\d*<\/key>$/ ) {
###		$item = Mac::iTunes::Item->new();
###		$inside = 1;
###	}
###
###	$line = <IN>
###} #for
###close IN;

# Make some numbers
my $librarySize = $library->size()/(1024**2);
my $numTracks = $library->num();

my $totalTime = $library->time()/1000;
my $days = int($totalTime/60/60/24);
my $hours = int($totalTime/60/60%24);
my $minutes = int($totalTime/60%60);
my $seconds = $totalTime%60;
my $averageTime = ($totalTime/$library->num());
my $averageMinutes = int($averageTime/60);
my $averageSeconds = int($averageTime%60);

# Total tracks
print "Number of tracks: " . $numTracks . "\n";

# Size
printf "Total size: %.2f MB\t\t", $librarySize;
printf "Average size: %.2f MB\n", $librarySize/$numTracks;

# Time
print "Total time: ${days}d ${hours}h ${minutes}m ${seconds}s\t";
print "Average time: ${averageMinutes}m${averageSeconds}s\n";

# Artists
print "\nMost popular artists, by number of tracks:\n";
&top($topNum, $library->artist());

# Artists, playcount
print "\nMost popular artists, by playcount:\n";
&top($topNum, $library->partist());

# Genres
print "\nMost popular genres, by number of tracks:\n";
&top($topNum, $library->genre());

# Genres, playcount
print "\nMost popular genres, by playcount:\n";
&top($topNum, $library->pgenre());


# Print the top n of a string->int hash
sub top {
	my($num, %hash) = @_;

	my %reverse;
	foreach my $artist ( keys %hash ) {
		my $count = $hash{$artist};

		if (exists $reverse{$count}) {
			unshift @{$reverse{ $count }}, $artist;
		} else {
			$reverse{ $count } = [$artist];
		}
	} #foreach

	# Sort the reverse keyset and print the $topNum
	my @sorted = sort by_number keys(%reverse);
	my $count = 0;
	foreach my $numTracks (@sorted) {
		last if ($count == $topNum);
		my @artists = @{$reverse{$numTracks}};
		print "\t$numTracks\t";

		for (my $x = 0; $x < scalar(@artists); $x++) {
			print ", " if ($x > 0);
			print $artists[$x];
		} #for

		print "\n";

		$count++;
	} #foreach
} #top

sub by_number {
	# Sort subroutine; expect $a and $b
	if ($a > $b) { -1 } elsif ($a < $b) { 1 } else { 0 }
} #by_number

# Handle a line within a <dict> item, adding the attribute to the passed
# iTunesItem object
#
# params:	($line, $item)
# returns:	$item
sub handleLine {
	my $line = shift;
	my $item = shift;
	return Carp::carp("Not enough arguments") unless (defined $item);

	if ($line =~ /<key>Track ID<\/key><integer>(\d*)<\/integer>/) {
		$item->trackID($1);
	} elsif($line =~ /<key>Name<\/key><string>(.*)<\/string>/) {
		$item->name($1);
	} elsif($line =~ /<key>Artist<\/key><string>(.*)<\/string>/) {
		$item->artist($1);
	} elsif($line =~ /<key>Genre<\/key><string>(.*)<\/string>/) {
		$item->genre($1);
	} elsif($line =~ /<key>Kind<\/key><string>(.*)<\/string>/) {
		$item->kind($1);
	} elsif($line =~ /<key>Size<\/key><integer>(\d.*)<\/integer>/) {
		$item->size($1);
	} elsif($line =~ /<key>Total Time<\/key><integer>(\d*)<\/integer>/) {
		$item->totalTime($1);
	} elsif($line =~ /<key>Year<\/key><integer>(\d*)<\/integer>/) {
		$item->year($1);
	} elsif($line =~ /<key>Date Modified<\/key><date>(.*)<\/date>/) {
		$item->dateModified($1);
	} elsif($line =~ /<key>Date Added<\/key><date>(.*)<\/date>/) {
		$item->dateAdded($1);
	} elsif($line =~ /<key>Bit Rate<\/key><integer>(\d*)<\/integer>/) {
		$item->bitRate($1);
	} elsif($line =~ /<key>Sample Rate<\/key><integer>(\d*)<\/integer>/) {
		$item->sampleRate($1);
	} elsif($line =~ /<key>Play Count<\/key><integer>(\d*)<\/integer>/) {
		$item->playCount($1);
	} elsif($line =~ /<key>Play Date<\/key><integer>(-\d*)<\/integer>/) {
		$item->playDate($1);
	} elsif($line =~ /<key>Play Date UTC<\/key><date>(.*)<\/date>/) {
		$item->playDateUTC($1);
	} elsif($line =~ /<key>Rating<\/key><integer>(\d*)<\/integer>/) {
		$item->rating($1);
	} elsif($line =~ /<key>Persistent ID<\/key><string>(.*)<\/string>/) {
		$item->persistentID($1);
	} elsif($line =~ /<key>Track Type<\/key><string>(.*)<\/string>/) {
		$item->trackType($1);
	} elsif($line =~ /<key>Location<\/key><string>(.*)<\/string>/) {
		$item->location($1);
	} elsif($line =~ /<key>File Folder Count<\/key><integer>(\d*)<\/integer>/) {
		$item->fileFolderCount($1);
	} elsif($line =~
			/<key>Library Folder Count<\/key><integer>(\d*)<\/integer>/) {
		$item->libraryFolderCount($1);
	}

	return $item;
} #handleLine

=head1 SEE ALSO

L<Mac::iTunes>

=head1 AUTHOR

Drew Stephens, <lt>drewgstephens@gmail.com<gt>, http://dinomite.net

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Drew Stephens

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
