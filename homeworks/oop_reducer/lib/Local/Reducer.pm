package Local::Reducer;

use strict;
use warnings;
use Mouse::Role;
=encoding utf8

=head1 NAME

Local::Reducer - base abstract reducer

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

has 'source' =>	( 
	is => 'rw',
	required => 1
	 );
has 'row_class' => ( 
	is => 'rw',
	required => 1 
	);
has 'initial_value' => ( 
	is => 'rw',
	required => 1
	);
has 'reduced' => (
	is => 'rw',
	);

requires qw/reduce_n reduce_all reduced/;

1;
