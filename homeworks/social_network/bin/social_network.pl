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

my $resultset = $schema->resultset('User');

while 

$resultset->create(
				{
					id => ,
					first_name => ,
					last_name => ,
				}
	);

# my $dbh = DBI->connect(
# 	"DBI:mysql:database=social_network;".
# 		"host=localhost;port=3306",
# 		"sn", "socnet");
# my $sth = $dbh->prepare('INSERT INTO users (id, first_name, last_name) VALUES (?, ?, ?)');

# my $fh;
# open ($fh, '-|', 'unzip -p '.$FindBin::Bin.'/../etc/user.zip') or die $!;
# while(my $line = <$fh>){
# 	my ($id, $first_name, $last_name) = split " ", $line;
# 	$sth->execute($id, $first_name, $last_name);
# }

# my $dbh = DBI->connect(
# 	"DBI:mysql:database=social_network;".
# 		"host=localhost;port=3306",
# 		"sn", "socnet");
# my $sth = $dbh->prepare('INSERT INTO friends_graph (uniq_id) VALUES (?)');

# my $fh;
# open ($fh, '-|', 'unzip -p '.$FindBin::Bin.'/../etc/user_relation.zip') or die $!;
# my %hash;
# while(my $line = <$fh>){
# 	my ($id1, $id2) = split " ", $line;
# 	$hash{($id1 < $id2)? $id1.'a'.$id2 : $id2.'a'.$id1}++;
# }
# $sth->execute($_) for (keys %hash);


# my $dbh = DBI->connect(
# 	"DBI:mysql:database=social_network;".
# 		"host=localhost;port=3306",
# 		"sn", "socnet");
# my $sth = $dbh->prepare("SELECT uniq_id FROM friends_graph where uniq_id like ? or uniq_id like ?");
# die "BD" unless $sth->execute("500a%","%a500");
# my $result1 = $sth->fetchall_hashref("uniq_id");
# die "BD" unless $sth->execute("900a%","%a900");
# my $result2 = $sth->fetchall_hashref("uniq_id");

# my @ob;

# for my $uniq_id (keys %$result1){
	
# 	if ($result2->{$uniq_id}){
# 		push
# 	}
# }

# print "\n";