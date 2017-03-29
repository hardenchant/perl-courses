#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;


my $file = "out.a";
GetOptions('file=s' => \$file);
my $count_sigint = 0;
$SIG{INT} = sub{
	unless($count_sigint){
		print STDERR "Double Ctrl+C for exit\n";
	}
	else{
		close(STDIN);
	}
	$count_sigint++;
};
open(my $fh, ">", $file) or die $!;
select($fh);
do {
	print <>;
} while(!eof() && !$count_sigint);
close $fh;