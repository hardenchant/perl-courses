#!/usr/bin/env perl
use utf8;
use strict;
use warnings;
use 5.010;
use JSON::XS;
use FindBin;
use lib "$FindBin::Bin/../lib/";
use VFS;
use feature 'say';

our $VERSION = 1.0;

binmode STDOUT, ":utf8";

unless (@ARGV == 1) {
	warn "$0 <file>\n";
}

my $buf;
{
	local $/ = undef;
	$buf = <>;
}


# Вот досада, JSON получается трудночитаемым, совсем не как в задании.
#print JSON::XS::encode_json(VFS::parse($buf));
#print unpack "A*", substr $buf, 3, 4; 

$buf = unpack 'H*', $buf;
my @hex_bytes;
push @hex_bytes, substr($buf, 2*$_, 2) for 0..(length($buf)/2);

say pack "H*", $hex_bytes[0];
shift @hex_bytes;
say my $N = hex $hex_bytes[0].$hex_bytes[1];
shift @hex_bytes; shift @hex_bytes;
say pack "H*", $hex_bytes[0].$hex_bytes[1].$hex_bytes[2].$hex_bytes[3];
shift @hex_bytes; shift @hex_bytes; shift @hex_bytes; shift @hex_bytes;
say sprintf("%o", hex($hex_bytes[0].$hex_bytes[1]));
