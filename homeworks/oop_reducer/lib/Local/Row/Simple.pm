package Local::Row::Simple;
use strict;
use warnings;

sub new {
	my $class = shift;
	my $self = bless {}, $class;
	unless ($_[1] =~ m/(?:^\w+:\w+)(?:,\w+:\w+)*$|^$/){
		return undef;
	}
	my @arr = split ",", $_[1];
	for my $str (@arr){
		%{$self} = (%{$self}, split ":", $str);
	}
	return $self;
}

sub get {
	my ($self, $name, $default) = (shift, shift, shift);
	return $self->{$name} if ($self->{$name});
	return $default; 	
}

1;