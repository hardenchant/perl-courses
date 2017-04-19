package Local::User;
use warnings;
use strict;
use Dancer2;
use Dancer2::Plugin::Database;
use Digest::MD5 'md5_hex';
use Mouse;
use Local::Note;

has 'username' => (
		is => 'ro',
		required => 1
	);

has 'password' => (
		is => 'rw',
	);

sub auth {
	my $self = shift;	
	my $zap = database->prepare('SELECT password FROM users WHERE username = ?');
	return undef unless $zap->execute($self->username);
	my $user = $zap->fetchrow_hashref();
	return 1 if (md5_hex($self->password) eq $user->{password});
	return 0;
}

sub registration {
	my $self = shift;	
	my $zap = database->prepare('SELECT username FROM users WHERE username = ?');
	return undef unless $zap->execute($self->username);
	return 0 if $zap->fetchrow_hashref();

	$zap = database->prepare('INSERT INTO users (username, password) VALUES (?, ?)');
	return undef unless $zap->execute($self->username, (md5_hex $self->password));
	return 1;
}

sub get_notes {
	my $self = shift;
	return Local::Note->pull_notes_by_user($self->username);
}

1;