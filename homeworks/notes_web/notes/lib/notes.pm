package notes;
use utf8;
use Dancer2;
use Dancer2::Plugin::Database;
use Digest::CRC 'crc64';
use Local::Note;
use Local::User;
use HTML::Entities;

our $VERSION = '0.1';

#if not auth redirect to auth 
hook 'before' => sub {
	if (!session('user') && request->path_info !~ m{^/(?:auth|reg)}){
		redirect '/auth';
	}
};

get '/' => sub {
	my $notes = Local::User->new(username => session('user'))->get_notes();
	$_->prepare_to_watch() for @$notes;	
	my $user = encode_entities(session('user'), '<>&"');
	template 'index' => { 'title' => "Notes - ".$user,
						  'username' => $user,
						  'notes' => $notes };
};

get '/auth' => sub {
	template 'auth' => { 'title' => "Auth" };
};

get '/logout' => sub {
	app->destroy_session;
	redirect '/';	
};

get qr{^/([a-f0-9]{16})$} => sub {
	my $note = Local::Note->pull(splat);
	
	my $user = encode_entities(session('user'),'<>&"');
	if($note){
		unless($note->user eq session('user') || $note->shared_users_hash->{session('user')}){
			response->status(404);
			template 'index' => {'notes' => [],
								 'title' => $user,
								  'errors' => ['You have not permission'],
								  'username' => $user
								};
		}
		else
		{
			$note->prepare_to_watch();
			template 'note' => {'title' => $note->title, 'note' => $note};
		}
	}
	else
	{
		template 'index' => {'notes' => [],
							 'title' => $user,
							  'errors' => ['Note not found'],
							  'username' => $user
							};	
	}
};

post '/auth' => sub {
	#checking
	my $user = Local::User->new(username => params->{username}, password => params->{password});
	if ($user->auth()){
		session 'user' => $user->username;
		redirect '/';
	}
	else
	{
		template 'auth' => { 'title' => "Auth", "errors" => ["Log, pass pair not found"] };
	}
};

post '/reg' => sub {
	#checking
	my @errors;
	push @errors, "Bad username (a-z0-9_)" unless (params->{new_username} =~ m/^[a-zA-Z0-9_]+$/); 
	push @errors, "Bad password (a-zA-Z0-9)" unless (params->{new_password} =~ m/^[a-zA-Z0-9]+$/);
	if (@errors){
		template 'auth' => { 'title' => "Auth", "errors" => \@errors };
	}
	else
	{
		my $user = Local::User->new(username => params->{new_username}, password => params->{new_password});
		if ($user->registration()){
			session 'user' => $user->{username};
			redirect '/';	
		}
		else
		{
			template 'auth' => { 'title' => "Auth", "errors" => ["User already exists"] }; 
		}
	}
};

post '/note' => sub {
	my $note_id = Local::Note->new({title => params->{title}, 
									shared_users => params->{shared_users}, 
									text => params->{text}, 
									user => session('user')});
	return unless $note_id; 
	my $hex_id = $note_id->commit();
	if ($hex_id) {
		redirect '/'.$hex_id;
	}
	else
	{
		redirect '/';
	}
	#checking
	
};

true;