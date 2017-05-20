package Local::MusicLib::DB::MySQL;
use Mouse;
extends 'DBI::ActiveRecord::DB::MySQL';

sub _build_connection_params {
	my ($self) = @_;
	my $db = "MusicLib";
	my $host = "localhost";
	my $port = "3306";
	my $user = "musiclib"; 
	my $pass = "musiclib";
	return [
		"dbi:mysql:$db:$host:$port", $user, $pass
	];
}

no Mouse;
__PACKAGE__->meta->make_immutable();

1;