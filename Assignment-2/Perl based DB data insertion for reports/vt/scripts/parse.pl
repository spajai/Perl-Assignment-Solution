use strict;
use warnings;

use FindBin;
use lib qq($FindBin::Bin/../lib);
use File::Find;
use VT;
use Dumpvalue;
use Data::Dumper;
my @content;
use JSON;
my $new = qq ();

my $bb;

open my ( $fh ), "text.txt"or warn("could not read the file: text.txt - $!"),return;
while (<$fh>) {

	$bb .= $_;
}
my $news = decode_json($bb);
print Dumper $news;

