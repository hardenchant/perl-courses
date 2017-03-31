#!/usr/bin/perl

use strict;
use warnings;
our $VERSION = 1.0;


my $filepath = $ARGV[0];
die "USAGE:\n$0 <log-file.bz2>\n"  unless $filepath;
die "File '$filepath' not found\n" unless -f $filepath;

my $parsed_data = parse_file($filepath);
report($parsed_data);
exit;

sub parse_file {
    my $file = shift;

    # you can put your code here
    
    my $fd;
    if ($file =~ /\.bz2$/) {
        open $fd, "-|", "bunzip2 < $file" or die "Can't open '$file' via bunzip2: $!";
    } else {
        open $fd, "<", $file or die "Can't open '$file': $!";
    }

    my $result;
    while (my $log_line = <$fd>) {
        $log_line =~ /^(?<ipaddr>(?:\d{1,3}\.){3}\d{1,3}) \[(?<timestamp>.{17}).{9}\] ".*" (?<code>\d{3}) (?<data>\d+) ".*" ".*" "(?<koeff>.*)"\s$/;
        if ($+{code} == 200){
            $result->{foreach}{$+{ipaddr}}{data} += int $+{data} * ($+{koeff} eq  "-" ? 1 : $+{koeff}); 
        }
        $result->{foreach}{$+{ipaddr}}{count_requests}++;
        $result->{foreach}{$+{ipaddr}}{codes}{$+{code}} += $+{data};
        $result->{foreach}{$+{ipaddr}}{count_min}{$+{timestamp}}++;
    }

    for my $ipaddr (keys %{$result->{foreach}}){
    	#total
    	$result->{total}{data} += $result->{foreach}{$ipaddr}{data} if ($result->{foreach}{$ipaddr}{data});
    	$result->{total}{count} += $result->{foreach}{$ipaddr}{count_requests};
        $result->{total}{count_min} += scalar keys %{$result->{foreach}{$ipaddr}{count_min}};
    	for my $code (keys %{$result->{foreach}{$ipaddr}{codes}}){
        	$result->{total}{codes}{$code} += $result->{foreach}{$ipaddr}{codes}{$code};
    	}
        
        #top
    	my %hash;
        for my $el (@{$result->{top}}){
            $hash{$el}++;
        }
        unless(exists $hash{$ipaddr}){   #если элемент не в топе
            @{$result->{top}} = reverse sort { #посортируем топ
                        $result->{foreach}{$a}{count_requests} <=> $result->{foreach}{$b}{count_requests}
                        } @{$result->{top}};    
            if (exists $result->{top}[9]){  #если топ забит то сравниваем с наименьшим
                if ($result->{foreach}{$ipaddr}{count_requests} > $result->{foreach}{$result->{top}[9]}{count_requests}){
                    $result->{top}[9] = $ipaddr;
                }
            }
            else    #топ не забит, просто добавляем
            {    
                push @{$result->{top}}, $ipaddr;
            }
        }	
    }


    @{$result->{top}} = reverse sort { #посортируем топ, вдруг что изменилось
                        $result->{foreach}{$a}{count_requests} <=> $result->{foreach}{$b}{count_requests}
                        } @{$result->{top}};    
        
    close $fd;

    # you can put your code here

    return $result;
}

sub report {
    my $result = shift;
    my @codes = sort keys %{$result->{total}{codes}};
    print "IP\tcount\tavg\tdata\t";
    print join "\t", @codes;
    print "\n";
    my $avg = $result->{total}{count} / $result->{total}{count_min};
    $avg = sprintf("%.2f", $avg);
    print "total\t$result->{total}{count}\t$avg\t".(int $result->{total}{data}/1024);
    for my $code (@codes){
        print "\t".(int $result->{total}{codes}{$code}/1024);
    }
    print "\n";
    for my $el (@{$result->{top}}){
        print $el."\t";
        print $result->{foreach}{$el}{count_requests}."\t";
        my $avg = $result->{foreach}{$el}{count_requests} / (scalar keys %{$result->{foreach}{$el}{count_min}});
        $avg = sprintf("%.2f", $avg);
        print "$avg\t";
        print (int $result->{foreach}{$el}{data}/1024);
        for my $code (@codes){
            print "\t";
            print $result->{foreach}{$el}{codes}{$code} ? (int $result->{foreach}{$el}{codes}{$code}/1024) : 0;
        }
        print "\n";
    }
    # you can put your code here

}
