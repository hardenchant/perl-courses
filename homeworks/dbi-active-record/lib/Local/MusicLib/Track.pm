package Local::MusicLib::Track;

use DBI::ActiveRecord;
use Local::MusicLib::DB::MySQL;

use DateTime;

db "Local::MusicLib::DB::MySQL";

table 'tracks';

has_field id => (
	isa => 'Int',
	auto_increment => 1,
	index => 'primary',
);

has_field album_id => (
    isa => 'Int',
    index => 'common',
    default_limit => 100,
);

has_field name => (
    isa => 'Str',
    index => 'common',
    default_limit => 100,
);

has_field duration => (
    isa => 'Str',
    serializer => sub {my @t = split ":", $_[0];
    				   $t[0] * 3600 + $t[1] * 60 + $t[2];},
    deserializer => sub {my $hh = int $_[0] / 3600;
    					 my $mm = int (($_[0] - $hh * 3600) / 60);
    					 my $ss = $_[0] - $hh * 3600 - $mm * 60;
						 "$hh:$mm:$ss"},
);

has_field create_time => (
    isa => 'DateTime',
    serializer => sub { $_[0]->epoch },
    deserializer => sub { DateTime->from_epoch(epoch => $_[0]) },
);

no DBI::ActiveRecord;
__PACKAGE__->meta->make_immutable();

1;