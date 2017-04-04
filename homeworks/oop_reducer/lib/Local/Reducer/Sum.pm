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

has 'reduced' => (
	is => 'rw',
	default => 0
	);

sub reduce_n {
	my ($self, $n) = (shift, shift);
	for my $count (1..$n){
		my $line = $self->{source}->next();
		last unless ($line); #end if line undef
		my $obj_str = $self->{row_class}->new(str => $line);
		next unless ($obj_str);
		$obj_str = $obj_str->get($self->{field}, "0");
		next unless looks_like_number($obj_str); #ignore if not a number
		$self->{reduced} +=	$obj_str;			
	}
	return $self->{reduced}; 
}

sub reduce_all {
	my $self = shift;
	while (my $line = $self->{source}->next()){
		my $obj_str = $self->{row_class}->new(str => $line);
		next unless ($obj_str);
		$obj_str = $obj_str->get($self->{field}, "0");
		next unless looks_like_number($obj_str); #ignore if not a number
		$self->{reduced} +=	$obj_str;			
	}
	return $self->{reduced};
}

sub reduced {
	my $self = shift;
	return $self->{reduced};	
}

1;