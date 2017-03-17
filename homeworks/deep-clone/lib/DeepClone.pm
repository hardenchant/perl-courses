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
	my $linklist;

	my $context = 0;
	my $subfail = 0;

	if (scalar @_ > 0){
		$linklist = shift;
		$context = 1;
	}
	else
	{
		$linklist = {};
	}

	# ...
	# deep clone algorith here
	if (ref $orig eq "ARRAY"){
		$cloned = [];
		$linklist->{$orig} = \@$cloned;
		for my $i (@$orig){
			if  ($i && $linklist->{$i}){
				push @$cloned, $linklist->{$i};
			}
			else
			{
				(my $temp, $subfail) = clone($i, $linklist);
				last if ($subfail);
				push @$cloned, $temp;
			} 
		}
	}
	elsif (ref $orig eq "HASH"){
		$cloned = {};
		$linklist->{$orig} = \%$cloned;
		for my $i (keys %$orig){
			if ($orig->{$i} && $linklist->{$orig->{$i}}){
				$cloned->{$i} = $linklist->{$orig->{$i}};
			}
		 	else
		 	{
				($cloned->{$i}, $subfail) = clone($orig->{$i}, $linklist);
				last if ($subfail);
			}
		}
	}
	elsif(!ref $orig)
	{
		$cloned = $orig;
	}
	else
	{
		$subfail = 1;
	}


	if ($context){
		return $cloned, $subfail;
	}
	else
	{	
		return undef if($subfail);
		return $cloned;
	}
}
1;