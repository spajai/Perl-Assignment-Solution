package oDesk::DB;

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use DBI;
use oDesk::Config;

my $config = oDesk::Config->new;
our $instance = undef;

sub new {
    my $class = shift;

    if(!$instance) {
        $instance = bless {}, $class;
    } 

    return $instance;
}

sub dbh {
  my ($class) = @_;

  my $db_path = $config->db_path;
  my $dbh = DBI->connect('dbi:SQLite:dbname='.$db_path,'','',{AutoCommit=>1,RaiseError=>1,PrintError=>0});

  return $dbh;
}

1;