#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib $FindBin::Bin.'/../lib/';
use Local::SocialNetwork;
use Getopt::Long;
use JSON::XS;
use Encode;

my ($friends, $nofriends, $num_handshakes);
my @users;

GetOptions ("friends" => \$friends,
			"nofriends" => \$nofriends,
			"num_handshakes" => \$num_handshakes,
			"user=i" => \@users
		) or die "Err args\n";

my $h = Local::SocialNetwork->new();

if (@users) {
	$friends = $h->get_our_friends($users[0], $users[1]) if $friends;
	$num_handshakes = $h->find_distance($users[0], $users[1]) if $num_handshakes;
}
$nofriends = $h->get_alones() if $nofriends;

if ($friends) {
	$friends = $h->from_id_to_objs($friends) ;
	for (@{$friends}) {
		$_->{first_name} = decode("utf8", $_->{first_name});
		$_->{last_name} = decode("utf8", $_->{last_name});
	}
	print JSON::XS->new->pretty(1)->utf8(1)->encode($friends);
}
if ($nofriends) {
	$nofriends = $h->from_id_to_objs($nofriends) ;
	for (@{$nofriends}) {
		$_->{first_name} = decode("utf8", $_->{first_name});
		$_->{last_name} = decode("utf8", $_->{last_name});
	}
	print JSON::XS->new->pretty(1)->utf8(1)->encode($nofriends);
}
print $num_handshakes."\n" if $num_handshakes;