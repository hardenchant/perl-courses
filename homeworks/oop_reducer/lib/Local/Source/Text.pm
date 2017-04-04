package Local::Source::Text;
use strict;
use warnings;
use Mouse;

with qw/Local::Source/;

has 'text' => (
	is => 'rw',
	required => 1
	);

has 'delimiter' => (
	is => 'rw',
	default => "\n"
	);

has 'array' => (
	is => 'rw'
	);

sub BUILD(){
	my $self = shift;
	my @array = split $self->delimiter, $self->text;
	$self->array(\@array);
}

sub next {
	my $self = shift;
	return undef unless (@{$self->array});
	return shift @{$self->array};
}

1;