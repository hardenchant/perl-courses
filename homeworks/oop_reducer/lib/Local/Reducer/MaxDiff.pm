package Local::Reducer::MaxDiff;
use strict;
use warnings;
use Mouse;
use Scalar::Util qw/looks_like_number/;

with qw/Local::Reducer/;

has 'top' => (
	is => 'rw',
	required => 1
	);

has 'bottom' => (
	is => 'rw',
	required => 1
	);

has 'result' => (
	is => 'rw',
	default => 0
	);

sub _reduce {
	my $self = shift;
	my $line = $self->source->next();
	return 0 unless ($line); 
	my $obj_str = $self->row_class->new(str => $line);
	return -1 unless ($obj_str);
	my $top = $obj_str->get($self->top, "0");
	my $bottom = $obj_str->get($self->bottom, "0");
	return -1 unless (looks_like_number($top) && looks_like_number($bottom)); #ignore if not a number
	my $diff = abs($top - $bottom);
	$self->result($diff) if ($diff > $self->result);
	return 1;
}

sub reduce_n {
	my ($self, $n) = (shift, shift);
	for my $count (1..$n){
		last unless ($self->_reduce());
	}
	return $self->result;
}

sub reduce_all {
	my $self = shift;
	while ($self->_reduce()){}
	return $self->result;
}

sub reduced {
	my $self = shift;
	return $self->result;
}

1;