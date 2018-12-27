#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use Time::Piece;
use Test::More;

my ($origin,$dest);
GetOptions (
	"o=s" => \$origin,
	"d=s" => \$dest,
	);
sub usage {
	print "Args:- \t-o origin Mandatory \n\t-d destiantion mandatory\n \nEx : perl Scriptname -o XXX -d YYY \n";
	exit;
}

usage() if((!$origin) or (!$dest));
my $time = Time::Piece->new();
my $dateformat = "%m/%d/%Y %H:%M:%S";

my ($count,@array,@result);
 
my @heading = qw/ORIGIN OT DESTINATION DT PRICE/;

#read all data files

	foreach my $filenum (1..3){
		$count = 0;
		open(my $fh, "<", "provider$filenum.txt") or die "Can't open < provider$filenum.txt: $!";
		while(<$fh>){
			$count++;
			my %hash;
			chomp $_;
			next if ($count == 1 or (!$_));
			@hash{@heading} = split (/\,|\|/,$_);
			push(@array, \%hash);
		}
	}

#find matching flight

	foreach my $row (@array) {
		if(uc($row->{ORIGIN}) eq uc($origin) and uc($row->{DESTINATION}) eq uc($dest)) {
			CleanData($row);
			push (@result ,$row);
		}
	}

#if no flight

	if(!(scalar @result)) {
		print  "No Flights For this route Origin :- $origin  Destination :- $dest\n";
		exit;
	}

#sort hash on basis of price and date

	@result = sort {
		$a->{PRICE} <=> $b->{PRICE} or
		 $time->strptime($a->{OT}, $dateformat) <=> $time->strptime($b->{OT} ,$dateformat)
	} @result;

my $i = 0;

#Remove Duplicate and print result	
	foreach(@result){
		for(my $j = $i+1;$j<scalar(@result); $j++){
				if (eq_hash($result[$i],$result[$j])){
				$result[$j]->{ISDUPLICATE} = 1;
				next;
			}
		}
		 if (!($result[$i]->{ISDUPLICATE})){
			printf ("%s --> %s \(%s --> %s\) - \$%s\n",$result[$i]->{ORIGIN},$result[$i]->{DESTINATION},$result[$i]->{OT},$result[$i]->{DT},$result[$i]->{PRICE});
		}
		$i++;
	}

#######################################
# sub CleanData 
#	Description :-
#	  This Subroutine contains the 
#	  Pre cleaning of Data
#  Parameters :- Hash ref of Data
#	Return :- Nothing
########################################

sub CleanData {
	my ($row) = @_;
	$row->{PRICE} =~ s/\$//g;
	$row->{OT} =~ s/\-/\//g;
	$row->{DT} =~ s/\-/\//g;
	return;
}