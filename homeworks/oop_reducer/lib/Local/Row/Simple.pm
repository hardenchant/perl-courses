package Local::Row::Simple;
use strict;
use warnings;
use Mouse;

with qw/Local::Row/;

sub get {
	my ($self, $name, $default) = (shift, shift, shift);
	my @arr = split ",", $self->{str};
	my %hash;
	for my $str (@arr){
		%hash = (%hash, split ":", $str);
	}
	return $hash{$name} if ($hash{$name});
	return $default; 	
}

1;