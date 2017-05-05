use strict;
use warnings;
use feature 'say';
use AnyEvent::HTTP;
use Web::Query;
use URI;

use DDP;

# my $cv = AE::cv();

# my $h = http_head 'http://ya.ru', sub {
# 	my ($body, $hdr) = @_;
# 	local $, = "\n";
# 	say $hdr->{"content-length"};
# 	#say keys %{$hdr};
# 	$cv->send("done");
# };

# my $result = $cv->recv;
my $url_s = 'https://github.com/Nikolo/Technosfera-perl/tree/anosov-crawler/';
my %res;
my $wqs = wq($url_s);
my $url = URI->new($url_s);
my $res = $wqs->find('a')->each(sub {
										shift;
										my $site = URI->new($_->attr('href'))->canonical->abs($url);
										if ($site =~ m{^$url.*}){
											$res{URI->new($site->path)->abs($url)}++ unless ($site->eq($url));
										}
									}
								);
open (my $fh, '>', './out');
my $old_fh = select $fh;
local $, = "\n";
say "$_\t$res{$_}" for keys %res;
select $old_fh;
close $fh;