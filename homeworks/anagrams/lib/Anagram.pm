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
use Encode qw(decode_utf8 encode_utf8);
sub anagram {
    my $words_list = shift;
    my %result;
    #    
    # Поиск анограмм 
    my %temp;
    my %first_words;

    for my $i (@$words_list){
      my $word = lc decode_utf8($i);
      my $keyword = join "", sort split "", $word;
      $temp{$keyword}{$word}++;
      $first_words{$keyword} = $word unless $first_words{$keyword};
    }
    for my $keyword (keys %first_words){
      next if (scalar keys %{$temp{$keyword}} == 1);
      $result{encode_utf8 $first_words{$keyword}} = [sort map { encode_utf8 $_ } keys %{$temp{$keyword}}];
    }


    return \%result;
}
1;
