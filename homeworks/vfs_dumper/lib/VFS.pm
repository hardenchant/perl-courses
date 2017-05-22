package VFS;
use utf8;
use strict;
use warnings;
use 5.010;
use File::Basename;
use File::Spec::Functions qw{catdir};
no warnings 'experimental::smartmatch';

my %modes = (
		1 => {execute => 1},
		2 => {write => 1},
		3 => {execute => 1, write => 1},
		4 => {read => 1},
		5 => {read => 1, execute => 1},
		6 => {read => 1, write => 1},
		7 => {read => 1, write => 1, execute => 1}
);


sub mode2s($) {
	my $hex_number = shift;
	my ($user, $group, $other) = map {$modes{$_}} split "", sprintf("%o", hex $hex_number);
	return {mode => {user => $user, group => $group, other => $other}};
}


sub parse {
	shift;
	my $buf = shift;
	print $buf;
	my @arr = split "", unpack "H*", $buf;
	#my $command = 
	# Тут было готовое решение задачи, но выше упомянутый злодей добрался и
	# сюда. Чтобы тесты заработали, вам предстоит написать всё заново.
}

1;
