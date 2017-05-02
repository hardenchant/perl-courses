use DBIx::Class::Schema::Loader qw(make_schema_at);
use FindBin;

make_schema_at(
	'Local::Schema',
	{
		dump_directory => $FindBin::Bin . '/lib',
	},
	[
		'dbi:mysql:database=social_network;host=localhost',
		'sn',
		'socnet'
	]
);