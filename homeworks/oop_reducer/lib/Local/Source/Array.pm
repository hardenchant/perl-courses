package Local::Source::Array;
use strict;
use warnings;
use Mouse;

with qw/Local::Source/;

has 'array' => (
	is => 'rw',
	required => 1
	);

sub next {
	my $self = shift;
	return undef unless ($#{$self->{array}} + 1);
	return shift @{$self->{array}};
}

1;