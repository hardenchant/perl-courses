package Anagram;

use 5.010;
use strict;
use warnings;

=encoding UTF8

=head1 SYNOPSIS

Поиск анаграмм

=head1 anagram($arrayref)

Функцию поиска всех множеств анаграмм по словарю.

Входные данные для функции: ссылка на массив - каждый элемент которого - слово на русском языке в кодировке utf8

Выходные данные: Ссылка на хеш множеств анаграмм.

Ключ - первое встретившееся в словаре слово из множества
Значение - ссылка на массив, каждый элемент которого слово из множества, в том порядке в котором оно встретилось в словаре в первый раз.

Множества из одного элемента не должны попасть в результат.

Все слова должны быть приведены к нижнему регистру.
В результирующем множестве каждое слово должно встречаться только один раз.
Например

anagram(['пятак', 'ЛиСток', 'пятка', 'стул', 'ПяТаК', 'слиток', 'тяпка', 'столик', 'слиток'])

должен вернуть ссылку на хеш


{
    'пятак'  => ['пятак', 'пятка', 'тяпка'],
    'листок' => ['листок', 'слиток', 'столик'],
}

=cut
use utf8;
use Encode qw(decode_utf8 encode_utf8);

#my @arr = split " ", $ARGV[0];
#use DDP;
#p @arr;
#p anagram(\@arr);

sub anagram {
    my $words_list = shift;
    my %result;
    #    
    # Поиск анограмм map {encode_utf8(lc decode_utf8($_))}
   	my %temphash;
   	for my $i (@$words_list){
   		my $word = encode_utf8(lc decode_utf8($i));
   		if ($temphash{length($word)}{$word}){
   			next;
   		}
   		else
   		{
   			$temphash{length($word)}{$word}++;
   		}
   		unless($result{$word}){
   			my $success = 0;
   			for my $k (keys %{$temphash{length($word)}}){
   				unless($result{$k}){
   					next;
   				}
   				if(length($k) == length($word) && ((join "", sort split "", $k) eq (join "", sort split "", $word))){
   					push @{$result{$k}}, $word;
   					$success = 1;
   				}
   			}
   			unless ($success){
   				$result{$word} = [];
   				push @{$result{$word}}, $word;
   			}
   		}
   	}
   	for my $k (keys %result){
   		unless($#{$result{$k}}){
   			delete $result{$k};
   		}
   		else
   		{
   			@{$result{$k}} = sort @{$result{$k}};
   		}
   	}

    return \%result;
}
1;
