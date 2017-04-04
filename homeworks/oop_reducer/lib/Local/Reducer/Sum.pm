package Local::Reducer::Sum;
use strict;
use warnings;
use Mouse;
use Scalar::Util qw/looks_like_number/;

with qw/Local::Reducer/;

has 'field' => (
	is => 'rw',
	required => 1
	);

has 'result' => (
	is => 'rw',
	default => 0
	);

sub _reduce	{
	my $self = shift;
	my $line = $self->source->next();
	return 0 unless ($line); #if strings ended
	my $obj_str = $self->row_class->new(str => $line);
	return -1 unless ($obj_str); #if wrong formmat
	my $number = $obj_str->get($self->field, "0");
	return -1 unless looks_like_number($number); # if not a number
	$self->result($self->result + $number);
	return 1;
}

sub reduce_n {
	my ($self, $n) = (shift, shift);
	for my $count (1..$n){
		last unless($self->_reduce());			
	}
	return $self->result(); 
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