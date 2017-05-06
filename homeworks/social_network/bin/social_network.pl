#!/usr/bin/env perl
use strict;
use warnings;
use YAML::XS 'LoadFile';
use FindBin;
use lib $FindBin::Bin.'/../lib/';
use Local::Schema;
use feature 'say';
use DBI;

#load cfg
my $cfg = LoadFile($FindBin::Bin.'/../config.yaml');
#connect to db
my $dbh = DBI->connect("dbi:$cfg->{Database}{driver}:database=$cfg->{Database}{database};host=$cfg->{Database}{host};port=$cfg->{Database}{port}",
					   $cfg->{Database}{username},
					   $cfg->{Database}{password});

sub get_friends_by_id {
	my $id = shift;
	my $sth = $dbh->prepare('SELECT relations.friend_id FROM users, relations WHERE users.id=relations.id AND users.id=?');
	return undef unless $sth->execute($id);
	my @friends;
	while (my $friend_id = $sth->fetchrow_hashref()) {
		push @friends, $friend_id->{friend_id};
	}
	return \@friends;
}
sub get_our_friends {
	my ($id1, $id2) = (shift, shift);
	my $sth = $dbh->prepare('SELECT relations.friend_id FROM users, relations JOIN (SELECT relations.friend_id FROM users, relations WHERE users.id=relations.id AND users.id=?) AS d ON relations.friend_id=d.friend_id WHERE users.id=relations.id AND users.id=?');
	return undef unless $sth->execute($id1, $id2);
	my @friends;
	while (my $friend_id = $sth->fetchrow_hashref()) {
		push @friends, $friend_id->{friend_id};
	}
	return \@friends;	
}
sub get_non_friends {
	my $sth = $dbh->prepare('SELECT u.id FROM users AS u WHERE NOT EXISTS(SELECT * FROM relations WHERE relations.id=u.id)');
	return undef unless $sth->execute();
	my @users;
	while (my $user_id = $sth->fetchrow_hashref()) {
		push @users, $user_id->{id};
	}
	return \@users;	
}
sub friends {
	my ($id1, $id2) = (shift, shift);
	my $sth = $dbh->prepare('SELECT * FROM users, relations WHERE users.id=relations.id AND users.id=? AND relations.friend_id=?');
	return 0 unless $sth->execute($id1, $id2);
	return 1 if $sth->fetchrow_hashref();
}
sub find_distance {
	my ($id1, $id2) = (shift, shift);
	my $distance = 0;
	return $distance if friends($id1, $id2);
	my $sth = $dbh->prepare('SELECT count(*) FROM users');
	return undef unless $sth->execute();
	my $max_dist = $sth->fetchrow_hashref()->{'count(*)'};
	my (@current, @next);
	@current = @{get_friends_by_id($id1)};
	while ($distance < $max_dist) {
		$distance++;
		for my $user_id (@current) {
			return $distance if friends($user_id, $id2);
		}
		
	}
	return undef;
}

use DDP; p friends(506, 4147);
# sub get_friends_by_id {
# 	my $id = shift;
# 	my $resultset = $schema->resultset('Relation')->search({id => $id});
# 	my @friends;
# 	while (my $friend = $resultset->next) {
# 		push @friends, $friend->friend_id;
# 	}
# 	return \@friends; 
# }
# sub get_our_friends {
# 	my ($id1, $id2) = @_;
# 	my $friends1 = get_friends_by_id($id1);
# 	my $friends2 = get_friends_by_id($id2);
# 	my %our_friends;
# 	$our_friends{$_}++ for @{$friends1};
# 	$our_friends{$_}++ for @{$friends2};
# 	my @result;
# 	for my $key (keys %our_friends) {
# 		push @result, $key if $our_friends{$key} > 1;
# 	}
# 	return \@result;
# }
# sub have_friends {
# 	my $id = shift;
# 	my $friends = get_friends_by_id($id);
# 	return 0 unless (@{$friends});
# 	1;
# }
# sub users_with_no_friends {
# 	my %users_id;
# 	my %friend_id;
# 	my $resultset = $schema->resultset('User');

# 	my @users_with_no_friends;
# 	while (my $user = $resultset->next) {
# 		$users_id{$user->id}++;
# 	}
# 	$resultset = $schema->resultset('Relation');
# 	while (my $user = $resultset->next) {
# 		$friend_id{$user->id}++;
# 	}
# 	for my $id (keys %friend_id){
# 		delete $users_id{$id} if $users_id{$id}; 
# 	}
# 	@users_with_no_friends = (keys %users_id); 
# 	return \@users_with_no_friends;
# }

# say scalar @{users_with_no_friends()};