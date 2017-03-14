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
		%$linklist = (%$linklist, $orig, \@$cloned);
		for my $i (@$orig){
			my $success = 0;
			for my $k (keys %$linklist){
				if  ($i && $i eq $k){
					push @$cloned, $linklist->{$k};
					$success = 1;
					last;
				}
			}
			unless ($success){
				my @temp = clone($i, $linklist);
				$subfail = $temp[1];
				last if ($subfail);
				push @$cloned, $temp[0];
			} 
		}
	}
	elsif (ref $orig eq "HASH"){
		$cloned = {};
		%$linklist = (%$linklist, $orig, \%$cloned);
		for my $i (keys %$orig){
			my $success = 0;
			for my $k (keys %$linklist){
				if ($orig->{$i} && $orig->{$i} eq $k){
					%$cloned = (%$cloned, $i, $linklist->{$k});
					$success = 1;
					last;
				}
			}
			unless ($success){
				my @temp = clone($orig->{$i}, $linklist);
				$subfail = $temp[1];
				last if ($subfail);
				%$cloned = (%$cloned, $i, $temp[0]);
			}
		}
	}
	elsif(ref \$orig eq "SCALAR")
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