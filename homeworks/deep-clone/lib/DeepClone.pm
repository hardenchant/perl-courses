package DeepClone;

use 5.010;
use strict;
use warnings;

=encoding UTF8

=head1 SYNOPSIS

Клонирование сложных структур данных

=head1 clone($orig)

Функция принимает на вход ссылку на какую либо структуру данных и отдаюет, в качестве результата, ее точную независимую копию.
Это значит, что ни один элемент результирующей структуры, не может ссылаться на элементы исходной, но при этом она должна в точности повторять ее схему.

Входные данные:
* undef
* строка
* число
* ссылка на массив
* ссылка на хеш
Элементами ссылок на массив и хеш, могут быть любые из указанных выше конструкций.
Любые отличные от указанных типы данных -- недопустимы. В этом случае результатом клонирования должен быть undef.

Выходные данные:
* undef
* строка
* число
* ссылка на массив
* ссылка на хеш
Элементами ссылок на массив или хеш, не могут быть ссылки на массивы и хеши исходной структуры данных.

=cut

sub clone {
	my $orig = shift;
	my $cloned;

	my $vl = shift;
	$vl = 1 unless $vl;
	my $success = 1;

	my $origg = shift;
	$origg = $orig unless $origg;
	# ...
	# deep clone algorith here
	if (ref $orig eq "ARRAY"){
		if ($#{$orig} == -1){
			$cloned = [];
		}
		else
		{
			my @newarr;
			for my $i (@$orig){
				if((ref $i eq "ARRAY") && (($i eq $orig) || ($i eq $origg))) # 
				{
					$success = 0;
					last;
				}
				else
				{
					my @temp = clone($i, $vl + 1, $origg);
					$success = $temp[2];
					push @newarr, $temp[0];
				}
			}
			$cloned = \@newarr;
		}
	}
	elsif (ref $orig eq "HASH"){
		if (scalar keys %$orig == 0){
			$cloned = {};
		}
		else
		{
			my %newhash;
			for my $i (keys %$orig){
				if((ref $orig->{$i} eq "HASH") && (($orig->{$i} eq $orig) || ($orig->{$i} eq $origg))){ #  
					$success = 0;
					last;
				}
				else
				{
					my @temp = clone($orig->{$i}, $vl + 1, $origg);
					$success = $temp[2];
					%newhash = (%newhash, $i, $temp[0]);
					
				}
			}

			$cloned = \%newhash;
		}
	}
	elsif(ref \$orig eq "SCALAR")
	{
		$cloned = $orig;
	}
	else
	{
		$success = 0;
	}


	if ($vl == 1){
		if ($success == 1){
			return $cloned;
		}
		else
		{
			return undef;
		}
	}
	else
	{
		return $cloned, $vl, $success;
	}
}
1;
