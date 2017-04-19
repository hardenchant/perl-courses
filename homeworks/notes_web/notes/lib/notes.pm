package notes;
use utf8;
use Dancer2;
use Dancer2::Plugin::Database;
use Digest::CRC 'crc64';
use Local::Note;
use Local::User;

our $VERSION = '0.1';


hook 'before' => sub {
	if (!session('user') && request->path_info !~ m{^/(?:auth|reg)}){
		redirect '/auth';
	}
};

get '/' => sub {
	#my $notes = Local::User->new(username => session('user'))->get_notes();

	template 'index' => { 'title' => "Notes - ".session('user'), 'username' => session('user')};#, 'notes' => $notes };
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
	template 'note' => {'title' => $note->title, 'note' => $note};
	#return "<h1>".$note->title()."</h1>\n".$note->note()."<br>".$note->shared_users() if $note;
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
	my $user = Local::User->new(username => params->{new_username}, password => params->{new_password});
	if ($user->registration()){
		session 'user' => $user->{username};
		redirect '/';	
	}
	else
	{
		template 'auth' => { 'title' => "Auth", "errors" => ["This user already exists"] }; 
	}
};

post '/note' => sub {
	my $note_id = Local::Note->new({title => params->{title}, 
									users => params->{users}, 
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