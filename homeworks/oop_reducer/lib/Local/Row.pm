package Local::Row;
use strict;
use warnings;
use Mouse::Role;

our $VERSION = '1.00';

requires qw/get/;

has 'str' => (
	is => 'rw',
	required => 1
	);
1;