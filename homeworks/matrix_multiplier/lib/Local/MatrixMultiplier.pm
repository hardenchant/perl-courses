package Local::MatrixMultiplier;

use strict;
use warnings;
use threads;
use threads::shared;


sub mult {
	my ($mat_a, $mat_b, $max_child) = @_;
	my $res = [];
	for my $row (@{$mat_a}){
		die "Wrong matrix" if (scalar @{@{$mat_a}[0]}) != (scalar @{$row});
	}
	for my $row (@{$mat_b}){
		die "Wrong matrix" if (scalar @{@{$mat_b}[0]}) != (scalar @{$row});
	}
	die "Wrong matrix" unless scalar @{@{$mat_a}[0]} == scalar @{$mat_b};

	my @res_pos = (scalar @$mat_a, scalar @{@{$mat_b}[0]}, scalar @$mat_b - 1);
	
	my @result;
	for (0..$res_pos[2]){
		$result[$_] = [];
	}
	my $ref_res = shared_clone(\@result);
	my @pos:shared = (0, 0);
	my $ref_pos = \@pos;
	my @threads;
	push @threads, threads->create(sub {
					my @local_pos;
					{
						lock($ref_pos);
						@local_pos = @pos;
						if (@pos){
							if ($pos[1] + 1 < $res_pos[1]) {
								$pos[1]++;
							}
							elsif ($pos[0] + 1 < $res_pos[0]) {
								$pos[0]++;
								$pos[1] = 0;
							}
							else {
								@pos = ();
							}
						}
					}
					while (@local_pos) {
						for (0..$res_pos[2]){
							$ref_res->[$local_pos[0]]->[$local_pos[1]] += @{@{$mat_a}[$local_pos[0]]}[$_] * @{@{$mat_b}[$_]}[$local_pos[1]];
						}
						{
							lock($ref_pos);
							@local_pos = @pos;
							if (@pos){
								if ($pos[1] + 1 < $res_pos[1]) {
									$pos[1]++;
								}
								elsif ($pos[0] + 1 < $res_pos[0]) {
									$pos[0]++;
									$pos[1] = 0;
								}
								else {
									@pos = ();
								}
							}
						}
					}
	}) for (1..$max_child); 
 	$_->join() for (@threads);
	$res = $ref_res;
	return $res;
}

1;
