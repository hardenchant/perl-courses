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
		my $top = $obj_str->get($self->{top}, "0");
		my $bottom = $obj_str->get($self->{bottom}, "0");
		next unless (looks_like_number($top) && looks_like_number($bottom)); #ignore if not a number
		my $diff = abs($top - $bottom);
		$self->{reduced} = $diff if ($diff > $self->{reduced});
	}
	return $self->{reduced};
}

sub reduce_all {
	my $self = shift;
	while (my $line = $self->{source}->next()){
		my $obj_str = $self->{row_class}->new(str => $line);
		next unless ($obj_str);
		my $top = $obj_str->get($self->{top}, "0");
		my $bottom = $obj_str->get($self->{bottom}, "0");
		next unless (looks_like_number($top) && looks_like_number($bottom)); #ignore if not a number
		my $diff = abs($top - $bottom);
		$self->{reduced} = $diff if ($diff > $self->{reduced});	
	}
	return $self->{reduced};
}

sub reduced {
	my $self = shift;
	return $self->{reduced};
}

1;