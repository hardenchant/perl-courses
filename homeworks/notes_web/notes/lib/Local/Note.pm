package Local::Note;
use Digest::CRC 'crc64';
use Dancer2;
use Dancer2::Plugin::Database;
use strict;
use warnings;
use Mouse;
use HTML::Entities;


has [qw/user text title shared_users shared_users_hash create_time id hex_id/] => (
	is => 'rw'
	);

sub insert_request {
	my $request = shift;
	return $request if $request;
	'INSERT INTO notes (id, create_time, user, title, note) VALUES (cast(? as signed),from_unixtime(?),?,?,?)';
}

sub select_by_id_request {
	my $request = shift;
	return $request if $request;
	'SELECT cast(id as unsigned), create_time, user, title, note FROM notes where id = cast(? as signed)';	
}

sub select_by_user_request {
	my $request = shift;
	return $request if $request;	
	'SELECT cast(id as unsigned), create_time, user, title, note FROM notes where user = ?';
}

sub white_list_insert_request {
	my $request = shift;
	return $request if $request;	
	'INSERT INTO white_lists (id, user) VALUES (cast(? as signed), ?)';
}

sub white_list_select_request {
	my $request = shift;
	return $request if $request;	
	'SELECT user FROM white_lists where id = cast(? as signed)';
}

sub BUILD {
	my $self = shift;
	$self->create_time // $self->create_time(time());
	$self->id // $self->id(crc64($self->{text}.$self->{create_time}.$self->{user}));
	$self->hex_id // $self->hex_id(unpack 'H*', pack 'Q', $self->id);
	$self->shared_users_hash({});
	for my $user (split ";", $self->shared_users){
		$self->shared_users_hash->{$user}++;	
	}
}

sub commit {
	my $self = shift;
	my $zap = database->prepare(insert_request());
	my $zap_whitelist = database->prepare(white_list_insert_request());
	return undef unless $zap->execute($self->id, $self->create_time, $self->user, $self->title, $self->text);
	for my $user (keys %{$self->shared_users_hash}){
		$zap_whitelist->execute($self->id, $user);
		#раскрутить обратно в случае ошибки
	}
	return $self->hex_id;
}

sub pull {
	shift;
	my $hex_id = shift;
	my $id = unpack 'Q', pack 'H*', $hex_id;
	my $zap = database->prepare(select_by_id_request());
	return undef unless $zap->execute($id);
	my $note = $zap->fetchrow_hashref();
	return undef unless $note;
	my $self = Local::Note->new(id => $id,
								create_time => $note->{create_time},
								user => $note->{user},
								title => $note->{title},
								text => $note->{note});
	my $zap_whitelist = database->prepare(white_list_select_request());
	return $self unless $zap_whitelist->execute($id);
	while(my $user = $zap_whitelist->fetchrow_hashref()){
		$self->shared_users_hash->{$user->{user}}++;
	}
	$self->shared_users(join ";", keys %{$self->shared_users_hash});
	return $self;
}

sub pull_notes_by_user {
	shift;
	my $username = shift;
	my $zap = database->prepare(select_by_user_request());
	return undef unless $zap->execute($username);
	my $result = [];
	my $zap_whitelist = database->prepare(white_list_select_request());
	while (my $note = $zap->fetchrow_hashref()){
		my $self = Local::Note->new(id => $note->{'cast(id as unsigned)'},
									create_time => $note->{create_time},
									user => $note->{user},
									title => $note->{title},
									text => $note->{note});
		push @$result, $self;
		next unless $zap_whitelist->execute($note->{id});
		while(my $user = $zap_whitelist->fetchrow_hashref()){
			$self->shared_users_hash->{$user}++;
		}
		$self->shared_users(join ";", keys %{$self->shared_users_hash})
	}
	return $result;
}

sub prepare_to_watch {
	my $self = shift;
	$self->text(encode_entities($self->text, '<>&"'));
	$self->{text} =~ s/\t/&nbsp;&nbsp;&nbsp;&nbsp;/g;
	$self->{text} =~ s/^ /&nbsp;/g;
	$self->title(encode_entities($self->title, '<>&"'));
	$self->shared_users(encode_entities($self->shared_users, '<>&"'));
}

1;