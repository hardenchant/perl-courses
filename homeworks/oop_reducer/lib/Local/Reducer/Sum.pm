package Local::Reducer::Sum;

use Mouse;
use Scalar::Util qw/looks_like_number/;

with qw/Local::Reducer/;

has 'field' => (
	is => 'rw',
	required => 1
	);

sub reduce_n($) {
	my ($self, $n) = (shift, shift);
	for my $count (1..$n){
		my $line = $self->{source}->next();
		last unless ($line);
		$self->{reduced} +=	$self->{row_class}->new($line)->get($self->{field}, "0");			
	}
	return $self->{reduced}; 
}
sub reduce_all() {
	my $self = shift;
	my $line = $self->{source}->next();
	while (my $line = $self->{source}->next()){
		$self->{reduced} +=	$self->{row_class}->new($line)->get($self->{field}, "0");			
	}
	return $self->{reduced};
}
sub reduced() {
	my $self = shift;
	return $self->{reduced};	
}
1;