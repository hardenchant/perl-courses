package myconst;

use strict;
use warnings;
use Scalar::Util 'looks_like_number';


=encoding utf8

=head1 NAME

myconst - pragma to create exportable and groupped constants

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS
package aaa;

use myconst math => {
        PI => 3.14,
        E => 2.7,
    },
    ZERO => 0,
    EMPTY_STRING => '';

package bbb;

use aaa qw/:math PI ZERO/;

print ZERO;             # 0
print PI;               # 3.14
=cut

sub import{
	no strict 'refs';
	shift;
	my %EX_TAGS;
	my $package_name = caller;
	while(@_){
		die "invalid args checked" if($#_ < 1);
		if (ref $_[1] eq "HASH"){
			my ($tag_name, $hash) = (shift, shift);
			for my $const_name (keys %$hash){
				die "invalid args checked" unless (!ref $hash->{$const_name} && $const_name =~ m/^(?:(?:[a-zA-Z_](?:[a-zA-Z_0-9])+)|[a-zA-Z])$/);
				*{"$package_name::$const_name"} = sub() {return $hash->{$const_name};};
				push @{$EX_TAGS{all}}, $const_name;
				push @{$EX_TAGS{$tag_name}}, $const_name;
			}
		}
		elsif(!ref $_[1]){
			my ($const_name, $const_value) = (shift, shift);
			die "invalid args checked" unless ($const_name && $const_name =~ m/^(?:(?:[a-zA-Z_](?:[a-zA-Z_0-9])+)|[a-zA-Z])$/);
			*{"$package_name::$const_name"} = sub() {return $const_value;};
			push @{$EX_TAGS{all}}, $const_name;		}
		else{
			die "invalid args checked";
		}
	}
	require Exporter;
	push @{"$package_name\:\:ISA"}, qw/Exporter/;
	push @{"$package_name\:\:EXPORT_OK"}, @{$EX_TAGS{all}};
	%{"$package_name\:\:EXPORT_TAGS"} = (%{"$package_name\:\:EXPORT_TAGS"}, %EX_TAGS);
}


1;
