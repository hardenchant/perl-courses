#!/usr/bin/perl

use strict;
use warnings;

=encoding UTF8
=head1 SYNOPSYS

Поиск количества вхождений строки в подстроку.

=head1 run ($str, $substr)

Функция поиска количества вхождений строки $substr в строку $str.
Пачатает количество вхождений в виде "$count\n"
Если вхождений нет - печатает "0\n".

Примеры: 

run("aaaa", "aa") - печатает "2\n".

run("aaaa", "a") - печатает "4\n"

run("abcab", "ab") - печатает "2\n"

run("ab", "c") - печатает "0\n"

=cut

sub run {
    my ($str, $substr) = @_;
    my $num = 0;
    while(index($str, $substr) != -1)
    {
    	$str = substr($str, 0, index($str, $substr)).
    		substr($str, index($str, $substr) + length($substr), length($str)); #return str without 1 sub tr
    	$num++;
    }
    # ...
    # Вычисление количества вохождений строки $substr в строку $str,
    # ...

    print "$num\n";
}

1;
