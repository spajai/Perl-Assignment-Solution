#!/usr/bin/perl 
use strict;
use warnings;
use Getopt::Long;
use JSON;
use File::Basename;
use lib dirname (__FILE__);
use DB;

use Data::Dumper; 

my $param = {};
GetOptions ("file=s" => \$param->{file}) or die("Error in command line arguments\n");
die ("usage $0 --file = '/path/file.csv' \n") unless ($param->{file});
my $db = DB->new();

#update the script run
$db->insert_update_log(__FILE__,encode_json($param));

open (my $fh, '<',$param->{file}) || die 'Unable to open file $param->{file}'. $!;

my $count = 0;
my @headers;
my @set;
# read data and map it

while(<$fh>) {
    my %data;
    chomp;
    if($count == 0) {
      @headers = split (',', $_);
    }else {
        @data{@headers} = split (',', $_);
        push (@set, \%data);
    }
    $count++;
}

foreach my $s (@set) {

    my $cust = {
        CUSTOMER_NAME => clean( $s->{CUSTOMER_NAME} ),
        MANAGERID     => clean( $s->{MANAGERID} ),
        ASSET         => clean( $s->{ASSET} ),
    };

    my $man = {
        MANAGER_NAME  => clean($s->{MANAGER_NAME}),
        MANAGERID     => clean($s->{MANAGERID}),
    };

    my $maf = {
        MANUFACTURER_ID  => clean($s->{MANUFACTURER_ID}),
        MANUFACTURER     => clean($s->{MANUFACTURER}),
        MANUFACTURE_DATE => clean($s->{MANUFACTURE_DATE}),
        ASSET            => clean($s->{ASSET}),
        REPLACE_DATE     => clean($s->{REPLACE_DATE}),
    };

    #insert
    $db->insert_cust($cust);
    $db->insert_manager($man);
    $db->insert_manf($maf);

}

$db->insert_update_log;

sub clean {
    my $raw = shift;
    $raw =~ s/\\r\\n//g;
    $raw =~ s/\/r\/n//g;
    return $raw;
}