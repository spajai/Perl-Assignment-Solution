use strict;
use warnings;

use FindBin;
use lib qq($FindBin::Bin/../lib);
use File::Find;
use VT;
use Data::Dumper;

use JSON;

my $d;

open my ( $fh ), "text.txt"or warn("could not read the file: text.txt - $!"),return;
while (<$fh>) {

	$d .= $_;
}
my $news = decode_json($d);
print Dumper $news;

