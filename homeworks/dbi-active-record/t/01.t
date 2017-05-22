use Test::More;
use FindBin;
use lib "$FindBin::Bin/../lib";


subtest track => sub {
	use Local::MusicLib::Track;
	my $obj = Local::MusicLib::Track->new();
	$obj->album_id(123);
	$obj->name("track");
	$obj->duration("4:5:6");
	$obj->create_time(DateTime->from_epoch(epoch => time()));
	my $exit_code = $obj->insert;
	is($exit_code, 1, "insert object");
	my $select = Local::MusicLib::Track->new()->select("album_id", 123, 1);
	is($select->album_id, $obj->album_id, "insert then select object album_id");
	is($select->name, $obj->name, "insert then select object name");
	is($select->duration, $obj->duration, "insert then select object duration");
	is($select->create_time, $obj->create_time, "insert then select object create_time");
	
	$obj->album_id(456);
	$obj->name("song");
	$obj->duration("0:0:10");
	$obj->create_time(DateTime->from_epoch(epoch => time()));	
	$exit_code = $obj->update();
	is($exit_code, 1, "update object");
	$select = Local::MusicLib::Track->new()->select("album_id", 456, 1);
	is($select->album_id, $obj->album_id, "update object album_id");
	is($select->name, $obj->name, "update object name");
	is($select->duration, $obj->duration, "update object duration");
	is($select->create_time, $obj->create_time, "update object create_time");

	$exit_code = $obj->delete();
	is($exit_code, 1, "delete object");
	$select = Local::MusicLib::Track->new()->select("album_id", 456, 1);
	is ($select, undef, "select after delete");
	no Local::MusicLib::Track;
};

done_testing(1);