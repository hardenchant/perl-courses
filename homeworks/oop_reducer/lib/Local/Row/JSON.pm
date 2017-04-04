package Local::Row::JSON;
use strict;
use warnings;
use Try::Tiny;
use JSON::XS;

sub new {
	my $class = shift;
	my $decode_str;
	if($_[1] eq "{}"){
		my $self = bless {}, $class;
		return $self;
	}
	eval{$decode_str = decode_json $_[1];};
	return undef if ($@ || ref $decode_str ne "HASH");
	my $self = bless $decode_str, $class;
	return $self;
}

sub get {
	my ($self, $name, $default) = (shift, shift, shift);
	return $self->{$name} if ($self->{$name});
	return $default; 	
}

1;