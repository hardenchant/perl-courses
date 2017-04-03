use warnings;
use strict;
use Local::Reducer::Sum;
use Local::Source::Array;
use Local::Row::Simple;
use feature 'say';

my $reducer = Local::Reducer::Sum->new(initial_value => 0,
									   row_class => "Local::Row::Simple", 
									   source => Local::Source::Array->new(array => [
									   		'key:value,number:3',
									   		'ke:val,number:5',
									   		'k:v,number:10'
									   ]), 
									   field => "number");
say $reducer->reduce_all();