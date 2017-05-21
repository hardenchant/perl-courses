package Local::MusicLib::Artist;

use DBI::ActiveRecord;
use Local::MusicLib::DB::MySQL;
use Mouse::Util::TypeConstraints;
use DateTime;

db "Local::MusicLib::DB::MySQL";

table 'artists';

has_field id => (
	isa => 'Int',
	auto_increment => 1,
	index => 'primary',
);

has_field name => (
    isa => 'Str',
    index => 'common',
    default_limit => 100,
);

subtype 'countrys'
    => as 'Str'
    => where { length $_ == 2 };

has_field country => (
    isa => 'countrys',
);

has_field create_time => (
    isa => 'DateTime',
    serializer => sub { $_[0]->epoch },
    deserializer => sub { DateTime->from_epoch(epoch => $_[0]) },
);

no DBI::ActiveRecord;
__PACKAGE__->meta->make_immutable();

1;