package Local::Source::Array;
use strict;
use warnings;
use Mouse;

with qw/Local::Source/;

has 'array' => (
	is => 'rw',
	required => 1
	);

sub BUILD(){
	my $self = shift;
	my @arr = @{$self->array()};
	$self->array(\@arr);
} 

sub next {
	my $self = shift;
	return undef unless (@{$self->array});
	return shift @{$self->array};
}

1;