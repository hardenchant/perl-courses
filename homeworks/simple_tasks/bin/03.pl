#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw(min max);
=encoding UTF8
=head1 SYNOPSYS

Поиск наименьшего и наибольшего из 3-х чисел

=head1 run ($x, $y, $z)

Функция поиска минимального и максимального из 3-х чисел $x, $y, $z.
Пачатает минимальное и максимальное числа, в виде "$value1, $value2\n"

Примеры: 

run(1, 2, 3) - печатает "1, 3\n".

run(1, 1, 1) - печатает "1, 1\n"

run(1, 2, 2) - печатает "1, 2\n"

=cut

sub run {
    my @in = @_;
    my $min = undef;
    my $max = undef;
    $min = min ($_[0], $_[1], $_[2]);
    $max = max ($_[0], $_[1], $_[2]);
    # ...
    # Вычисление минимума и максимума
    # ...

    print "$min, $max\n";
}

run (1,1,1);