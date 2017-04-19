package foo;
use Mouse;
has '_time' => (
	is => 'rw',
	default => '13:50',
	init_arg => '13:40'
	);
sub  time {
	shift;
	my $self = shift;
	return 'string' unless($self);
	return $self;
}
1;

