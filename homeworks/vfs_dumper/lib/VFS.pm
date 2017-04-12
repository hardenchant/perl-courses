package VFS;
use utf8;
use strict;
use warnings;
use 5.010;
use File::Basename;
use File::Spec::Functions qw{catdir};
use JSON::XS;
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

my %command_subs = (
	D => sub {
		my ($hex_bytes, $last_folder_list) = (shift, shift); 
		my $N_name = hex (shift @{$hex_bytes}).(shift @{$hex_bytes});
		my $name;
		$name .= (shift @{$hex_bytes}) for 1..$N_name;
		$name = pack "H*", $name;
		mode2s(shift @{$hex_bytes}).(shift @{$hex_bytes});
		push @{$last_folder_list}, {type => "directory", name => $name,  list => [], %{mode2s(shift @{$hex_bytes}).(shift @{$hex_bytes})}};
		1;
	}, 
	F => sub {
		my ($hex_bytes, $last_folder_list) = (shift, shift); 
		$command_subs{D}($hex_bytes, $last_folder);
		$last_folder_list->[-1]->{type} = "file";
		delete $last_folder_list->[-1]->{list};
		$last_folder_list->[-1]->{size} = hex (shift @{$hex_bytes}).(shift @{$hex_bytes}).(shift @{$hex_bytes}).(shift @{$hex_bytes});
		my $sha;
		$sha .= shift @{$hex_bytes} for 1..20;
		$last_folder_list->[-1]->{hash} = $sha;
		1;
	},
	I => sub {
		$last_folder_list = $last_folder_list->[-1]->{list};
	},
	U => 
	Z => 
);

sub parse {
	my $buf = shift;
	
	# Тут было готовое решение задачи, но выше упомянутый злодей добрался и
	# сюда. Чтобы тесты заработали, вам предстоит написать всё заново.
}

1;
