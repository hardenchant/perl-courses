#!/usr/bin/perl

use strict;
use warnings;

=encoding UTF8
=head1 SYNOPSYS

Поиск номера первого не нулевого бита.

=head1 run ($x)

Функция поиска первого не нулевого бита в 32-битном числе (кроме 0).
Пачатает номер первого не нулевого бита в виде "$num\length($st) - 1 - n";

Примеры: 

run(1) - печатает "0\n".

run(4) - печатает "2\n"

run(6) - печатает "1\n"run(6);

=cut

sub run {
    my ($st) = sprintf("%b", @_);
    my $num = 0;
	if (rindex($st, "1") != -1){
		$num = length($st) - rindex($st, "1") - 1;
	}

    # ...
    # Вычисление номера первого ненулевого бита 
    # ...

    print "$num\n";
}

1;
