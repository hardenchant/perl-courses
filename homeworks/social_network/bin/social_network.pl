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

my $result;
my $h = Local::SocialNetwork->new();

$result = $h->get_our_friends($users[0], $users[1]) if $friends && @users;
$result = $h->get_alones() if $nofriends;
$result = $h->find_distance($users[0], $users[1]) if $num_handshakes && @users;

if ($friends || $nofriends) {
	$result = $h->from_id_to_objs($result) ;
	for (@{$result}) {
		$_->{first_name} = decode("utf8", $_->{first_name});
		$_->{last_name} = decode("utf8", $_->{last_name});
	}
	print JSON::XS->new->pretty(1)->utf8(1)->encode($result);
}
else {
	print $result."\n";
}
