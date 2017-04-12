package Local::MatrixMultiplier;

use strict;
use warnings;

sub mult {
	my ($mat_a, $mat_b, $max_child) = @_;
	my $res = [];

	my ($read, $write);
	pipe ($read, $write);

	my $potoks = 1;	#2
	my @procs;
	
	my @arr = (1,2,3,4,5,6,7,8,9,10);
	
	for (1..$potoks){
		if (my $ppid = fork()){
			push @procs, $ppid;
		}
		else
		{
			close $read;
			print "i'm CHILD";
			print $write "HELLO";
			exit;
		}
	}
	close $write;
	print join "-", @procs;
	for my $pid (@procs){
		waitpid($pid, 0);
	}

	while(<$read>){
		print $_;
	}
	return $res;
}

1;
