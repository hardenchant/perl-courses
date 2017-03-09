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
	# ...
	# deep clone algorith here
	if (ref $orig eq "ARRAY"){
		if ($#{$orig} == -1){
			$cloned = \[];
		}
		else
		{
			my @newarr;
			for my $i (@$orig){
				if((ref $i eq "ARRAY") && ($i eq $orig))
				{
					last;
				}
				else
				{
					push @newarr, clone($i);
				}
			}
			$cloned = \@newarr;
		}
	}
	elsif (ref $orig eq "HASH"){
		if (scalar keys %$orig == 0){
			$cloned = \{};
		}
		else
		{
			my %newhash;
			for my $i (keys %$orig){
				if((ref $orig->{$i} eq "HASH") && ($orig->{$i} eq $orig)){
					
					last;
				}
				else
				{
					%newhash = (%newhash, $i, clone($orig->{$i}));
					
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
		$cloned = undef;
		
	}
	return $cloned;
}

1;
