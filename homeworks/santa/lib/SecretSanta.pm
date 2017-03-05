package SecretSanta;

use 5.010;
use strict;
use warnings;
use DDP;

sub calculate {
	my @members = @_;
	my @res;

	my %inhash;
	for my $val (@members) {
		if (ref($val)) {
				%inhash = (%inhash, @{$val}[0],@{$val}[1]); 
				%inhash = (%inhash, @{$val}[1],@{$val}[0]);
			}
			else
			{
				%inhash = (%inhash,$val,undef);
			}
	};
	my @rnd = keys %inhash;
	my %hres;
	
	for my $i (0..20){
		%hres = ();
		my $success = 0;
		for my $key (keys %inhash) {
			$success = 0;
			for my $j (0..100){
				my $suppose = @rnd[int rand($#rnd)];
				unless (($inhash{$key} eq $suppose) || ($suppose eq $key)){
					unless ((exists $hres{$suppose}) && ($hres{$suppose} eq $key))
					{
						%hres = (%hres, $key, $suppose);
						$success = 1;
						last;
					} 
				}
			}
			last if !$success;
		}
		last if $success;
	}
	for my $i (keys %hres){
		push @res,[$i, $hres{$i}];
	}
	# ...
	#	push @res,[ "fromname", "toname" ];
	# ...

	return @res;
}

1;
