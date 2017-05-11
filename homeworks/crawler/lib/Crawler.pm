package Crawler;

use 5.010;
use strict;
use warnings;

use AnyEvent::HTTP;
use Web::Query;
use URI;

=encoding UTF8

=head1 NAME

Crawler

=head1 SYNOPSIS

Web Crawler

=head1 run($start_page, $parallel_factor)

Сбор с сайта всех ссылок на уникальные страницы

Входные данные:

$start_page - Ссылка с которой надо начать обход сайта

$parallel_factor - Значение фактора паралельности

Выходные данные:

$total_size - суммарный размер собранных ссылок в байтах

@top10_list - top-10 страниц отсортированный по размеру.

=cut




sub run {
    my ($start_page, $parallel_factor) = @_;
    $start_page or die "You must setup url parameter";
    $parallel_factor or die "You must setup parallel factor > 0";

    my $total_size = 0;
    my @top10_list;

    #............
    #Код crawler-а
    #............

	$AnyEvent::HTTP::MAX_PER_HOST = $parallel_factor;

	my $cv = AE::cv();
	my $url = URI->new($start_page)->canonical;

	my %result;
	my %visited;

	my $func; $func = sub {
		my $site = shift;
		my $cond = shift;
		$cv->begin;
		if ($cond) {
			#head
			return unless (scalar keys %result < 1000);
			http_head $site, sub {
				shift; my $hdr = shift;
				if ($hdr->{'content-type'} =~ m/.*text\/html.*/){
					$func->($site);
				}
				$cv->end;
			};
		}
		else {
			#get
			return unless (scalar keys %result < 1000);
			http_get $site, sub {
				my ($body, $hdr) = @_;
				$result{$site} = $hdr->{'content-length'};
				wq($body)->find('a')->each(sub {
					shift; #skip index
					my $uri = URI->new($_->attr('href'))->canonical->abs($url);
					if ($uri =~ m{^$url.*}){
						$uri = URI->new($uri->path())->abs($url);#исключаем теги привязки из ссылок
						unless ($visited{$uri}) {
							$visited{$uri}++;
							$func->($uri, 1);
						}
					}
				});
				$cv->end;
			};
		}
	}; $func->($url);
	$cv->recv;
	$total_size += $_ for (values %result);
	my @sort_key = (sort { $result{$b} <=> $result{$a} } keys %result);
	for (1..10){
		push @top10_list, shift @sort_key;
	}
    return $total_size, @top10_list;
}

1;
