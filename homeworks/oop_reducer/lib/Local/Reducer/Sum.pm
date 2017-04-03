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

sub reduce_n {
	my ($self, $n) = (shift, shift);
	for my $count (1..$n){
		my $line = $self->{source}->next();
		last unless ($line); #end if line undef
		my $value = $self->{row_class}->new(str => $line)->get($self->{field}, "0");
		next unless looks_like_number($value); #ignore if not a number
		$self->{reduced} +=	$value;			
	}
	return $self->{reduced}; 
}
sub reduce_all {
	my $self = shift;
	while (my $line = $self->{source}->next()){
		my $value = $self->{row_class}->new(str => $line)->get($self->{field}, "0");
		next unless looks_like_number($value); #ignore if not a number
		$self->{reduced} +=	$value;			
	}
	return $self->{reduced};
}
sub reduced {
	my $self = shift;
	return $self->{reduced};	
}
1;