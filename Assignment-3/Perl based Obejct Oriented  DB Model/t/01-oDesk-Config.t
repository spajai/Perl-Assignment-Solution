use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Test::More;
use Test::Exception;
use Cwd 'realpath';

use_ok('oDesk::Config');

#-------------------------------------------------------------------------------

#instantiation
{
  my $c = oDesk::Config->new;
  isa_ok($c, 'oDesk::Config');
}

#-------------------------------------------------------------------------------

{
  my $c = oDesk::Config->new;
  my $test_path = $c->base_path . '/t';
  my $abspath1 = realpath($test_path);
  my $abspath2 = realpath($FindBin::Bin);

  cmp_ok($abspath1, 'eq', $abspath2, 'base_path check');
}

#-------------------------------------------------------------------------------

done_testing();
