package Local::SocialNetwork;

use strict;
use warnings;
use YAML::XS 'LoadFile';
use FindBin;
use feature 'say';
use DBI;

=encoding utf8

=head1 NAME

Local::SocialNetwork - social network user information queries interface

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub new {
	my $class = shift;
	#load cfg
	my $cfg = LoadFile($FindBin::Bin.'/../config.yaml');
	#connect to db
	my $dbh = DBI->connect("dbi:$cfg->{Database}{driver}:database=$cfg->{Database}{database};host=$cfg->{Database}{host};port=$cfg->{Database}{port}",
					   $cfg->{Database}{username},
					   $cfg->{Database}{password});
	$dbh->do("SET NAMES 'utf8'");
	$dbh->do("SET CHARACTER SET 'utf8'");
	return bless {'dbh', $dbh}, $class;
}

sub DESTROY {
	my $self = shift;
	$self->{dbh}->disconnect();
}

sub get_friends_by_id {
	my $self = shift;
	my $id = shift;
	my $sth = $self->{dbh}->prepare('SELECT relations.friend_id FROM users, relations WHERE users.id=relations.id AND users.id=?');
	return undef unless $sth->execute($id);
	my @friends;
	while (my $friend_id = $sth->fetchrow_hashref()) {
		push @friends, $friend_id->{friend_id};
	}
	return \@friends;
}

sub get_our_friends {
	my $self = shift;
	my ($id1, $id2) = (shift, shift);
	my $sth = $self->{dbh}->prepare('SELECT relations.friend_id FROM users, relations JOIN (SELECT relations.friend_id FROM users, relations WHERE users.id=relations.id AND users.id=?) AS d ON relations.friend_id=d.friend_id WHERE users.id=relations.id AND users.id=?');
	return undef unless $sth->execute($id1, $id2);
	my @friends;
	while (my $friend_id = $sth->fetchrow_hashref()) {
		push @friends, $friend_id->{friend_id};
	}
	return \@friends;	
}

sub get_alones {
	my $self = shift;
	my $sth = $self->{dbh}->prepare('SELECT u.id FROM users AS u WHERE NOT EXISTS(SELECT * FROM relations WHERE relations.id=u.id)');
	return undef unless $sth->execute();
	my @users;
	while (my $user_id = $sth->fetchrow_hashref()) {
		push @users, $user_id->{id};
	}
	return \@users;	
}

sub friends {
	my $self = shift;
	my ($id1, $id2) = (shift, shift);
	my $sth = $self->{dbh}->prepare('SELECT * FROM users, relations WHERE users.id=relations.id AND users.id=? AND relations.friend_id=?');
	return 0 unless $sth->execute($id1, $id2);
	return 1 if $sth->fetchrow_hashref();
}

sub find_distance {
	my $self = shift;
	my ($id1, $id2) = (shift, shift);
	my $distance = 0;
	my $sth = $self->{dbh}->prepare('SELECT count(*) FROM users');
	return undef unless $sth->execute();
	my $max_dist = $sth->fetchrow_hashref()->{'count(*)'};
	my (@current, @next);
	push @current, $id1;
	while ($distance < $max_dist-1) {
		$distance++;
		for my $user_id (@current) {
			return $distance if $self->friends($user_id, $id2);
			@next = (@next, @{$self->get_friends_by_id($user_id)});
		}
		@current = @next;
		@next = ();
	}
	return undef;
}

sub from_id_to_objs {
	my $self = shift;
	my $ids = shift;
	my @result;
	my $sth = $self->{dbh}->prepare('SELECT * FROM users WHERE id = ?');
	while (@{$ids}) {
		$sth->execute(pop @{$ids});
		push @result, $sth->fetchrow_hashref();
	}
	return \@result;
}

1;
