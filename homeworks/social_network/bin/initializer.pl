#!/usr/bin/env perl

use strict;
use warnings;
use YAML::XS 'LoadFile';
use FindBin;
use lib $FindBin::Bin.'/../lib/';
use Local::Schema;

#load cfg
my $cfg = LoadFile($FindBin::Bin.'/../config.yaml');
#connect to db
my $schema = Local::Schema->connect("dbi:$cfg->{Database}{driver}:database=$cfg->{Database}{database};host=$cfg->{Database}{host};port=$cfg->{Database}{port}",
					   $cfg->{Database}{username},
					   $cfg->{Database}{password});

#my $resultset = $schema->resultset('User');

my $fh;

open ($fh, '-|', 'unzip -p '.$FindBin::Bin.'/../etc/user.zip') or die $!;

while(my $line = <$fh>){
	my @user = (split " ", $line); 
	my $resultset = $schema->resultset('User')->new_result(
			{
						id => $user[0],
						first_name => $user[1],
						last_name => $user[2],
			}
		);
	$resultset->insert();
	#$resultset->create(
					
	#);
}

