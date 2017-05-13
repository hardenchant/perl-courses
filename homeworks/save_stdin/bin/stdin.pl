#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

my $file = "a.out";
GetOptions('file=s' => \$file);
my $count_sigint = 0;
$SIG{INT} = sub {
	unless ($count_sigint) {
		print STDERR "Double Ctrl+C for exit";
	}
	else {
		close(STDIN);
	}
	$count_sigint++;
};
open (my $fh, ">", $file) or die $!;
print "Get ready\n";

my $olds = select $fh;
my ($size, $lines, $middle_length) = (0, 0, 0);

while (my $line = <>) {
	print $line;
	$lines++;
	chomp $line;
	$size += length $line;
}
close $fh;
select $olds;
$middle_length = $lines ? int $size/$lines : 0;

print "$size $lines $middle_length\n";