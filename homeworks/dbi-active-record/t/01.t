use Test::More;
use FindBin;
use lib "$FindBin::Bin/../lib";

use Local::MusicLib::Track;
my $obj = Local::MusicLib::Track->new();
$obj->album_id(123);
$obj->name("track");
$obj->duration("4:5:6");
$obj->create_time(DateTime->from_epoch(epoch => time()));

subtest track => sub {
	my $r = $obj->insert;
	is($r, 1, "insert object");
	my $rw = Local::MusicLib::Track->new()->select("album_id", 123, 1);
	is($rw->album_id, $obj->album_id, "select object album_id");
	is($rw->name, $obj->name, "select object name");
	is($rw->duration, $obj->duration, "select object duration");
	is($rw->create_time, $obj->create_time, "select object create_time");

	no Local::MusicLib::Track;
};



done_testing(1);