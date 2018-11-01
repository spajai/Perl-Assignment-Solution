use warnings;
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use Test::More;
use Test::Exception;
use Data::Dumper;

use_ok('oDesk::DB');

my $db_path = "$FindBin::Bin/../db/odesk.db";

#-------------------------------------------------------------------------------

# test instantiation
{
  my $db = oDesk::DB->new;
  isa_ok($db, 'oDesk::DB');
}

#-------------------------------------------------------------------------------

# test for singleton
{
  my $db = oDesk::DB->new;
  isa_ok($db, 'oDesk::DB');

  my $db2 = oDesk::DB->new;
  isa_ok($db2, 'oDesk::DB');

  ok($db == $db2, 'singleton');
}

#-------------------------------------------------------------------------------

# test getting database handle
{
  my $db = oDesk::DB->new; 

  isa_ok($db->dbh, 'DBI::db');
}

#-------------------------------------------------------------------------------

# make sure we have the right database
# verify by comparing records we expect to see
{
  my %expected = (
      '1'  => 'perl',
      '2'  => 'mod_perl',
      '3'  => 'unix',
      '4'  => 'java',
      '5'  => 'php',
      '6'  => 'c',
      '7'  => 'c++',
      '8'  => 'sql',
      '9'  => 'html',
      '10' => 'css',
      '11' => 'javascript',
      '12' => 'apache',
      '13' => 'emacs',
      '14' => 'vi',
      '15' => 'eclipse',
  );

  my $db = oDesk::DB->new; 
  my $aref = $db->dbh->selectall_arrayref('SELECT id, name FROM skill');
  my %hash = map { @{$_} } @$aref;
  is_deeply(\%hash, \%expected, 'expected records are correct');
}

#-------------------------------------------------------------------------------

done_testing();
