#!/usr/bin/perl 
use strict;
use warnings;
use Getopt::Long;
use JSON;
use File::Basename;
use lib dirname(__FILE__);
use DB;

use Data::Dumper;

my $param = {
    sc1 => undef,
    sc2 => undef,
    sc3 => undef,
    man => undef,
    maf => undef,
};

GetOptions(
    "sc1"   => \$param->{sc1},
    "sc2"   => \$param->{sc2},
    "sc3"   => \$param->{sc3},
    "man=s" => \$param->{man},
    "maf=s" => \$param->{maf},
);

die("usage $0 [--sc1 | --sc2 | --sc3 ] {--man 'MANAGER ID XXX' | --maf 'MANAFACTURER ID XXX'}  \n")
  unless ($param->{sc1} || $param->{sc2} || $param->{sc3});
my $db = DB->new();

#update the script run
$db->insert_update_log(__FILE__, encode_json($param));
my $res;

my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime();
$res->{metrics}->{startTime} = sprintf("%02d-%02d-%02d %02d:%02d:%02d", $year + 1900, $mon, $mday, $hour, $min, $sec);

if ($param->{sc1}) {
    eval {
        $res->{data}       = $db->get_man_cust($param->{man});
        $res->{successful} = 1;
    };
    $res->{successful} = 0 if ($@);
}

if ($param->{sc2}) {
    eval {
        $res->{data}       = $db->get_maf_ast($param->{maf});
        $res->{successful} = 1;
    };
    $res->{successful} = 0 if ($@);
}

if ($param->{sc3}) {
    eval {
        $res->{data} = $db->get_ast($param->{man}, $param->{maf});
        $res->{successful} = 1;
    };
    $res->{successful} = 0 if ($@);
}

($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime();
$res->{metrics}->{endTime} = sprintf("%02d-%02d-%02d %02d:%02d:%02d", $year + 1900, $mon, $mday, $hour, $min, $sec);
$res->{metrics}->{elapsedTime} = time - $^T;
print encode_json $res;

$db->insert_update_log;
