print @ARGV;
print "\n"; 

my $f; 
open ($f, "<", $ARGV[0]);
binmode $f; 
$/=undef; 
my $line = <$f>; 
my @arr = split "", unpack "H*", $line; 
my $i = 1;
while (@arr) {
	print $i."\t";
	$i++;
	for (1..8) {
		for(1..4) {
			last unless(@arr);
			print shift @arr;
		}
		print " ";
	}
	print "\n";
}