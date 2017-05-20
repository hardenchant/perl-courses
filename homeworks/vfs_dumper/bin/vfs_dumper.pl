#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;
use JSON::XS;
use FindBin;
use lib "$FindBin::Bin/../lib/";
use VFS;
use feature 'say';

our $VERSION = 1.0;

unless (@ARGV == 1) {
	warn "$0 <file>\n";
}

open (my $f, "<", $ARGV[0]);
binmode $f;

my $buf;
{
	local $/ = undef;
	$buf = <>;
}

VFS->parse($buf);
# Вот досада, JSON получается трудночитаемым, совсем не как в задании.