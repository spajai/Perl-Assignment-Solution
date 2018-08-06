#! /usr/bin/perl -w
#
#  Read the JSON files returned by VirusTotal.com. Save the records into a 
#  database.

use strict;
use warnings;
use Getopt::Long;
use FindBin;
use lib qq($FindBin::Bin/../lib);
use File::Find;
use VT;
my @content;
my $data;
GetOptions ("file=s"   => \$data);
my @files = split (',',$data);
use DBI;
use Try::Tiny;

my $username='root';
my $pass='root';

open (my $log ,'>',"../log/log_db.txt") || die("could not create the file: ../log/log_db.txt");

my $dbh = DBI->connect("DBI:mysql:virusdb:localhost", $username, $pass) || die ( "Couldn't connect to database: " . DBI->errstr );
 

my $dbkeys;

sub wanted {
  push @content, $File::Find::name;
  return;
}

if (scalar @files == 0) {
    die "Read JSON reports from VirusTotal.com into a SQLite database file\n",
        "Usage:\n    $0 <VT_JSON_files>\n\n";
}
				
foreach my $file (@files) {
	if(-d $file ) {
		#push all the files inside the directory
		find( \&wanted, $file );
		unless (scalar @content > 0) {
			 print $log qq ("No JSON files available in Directory\n");
			exit;
		}

	} elsif (-f $file) {
		    open my ( $fh ), $file or warn("could not read the file: $file - $!"),return;
		    push (@content ,$file); #push single file which can be openable

	} elsif (-e $file) {
		print $log "\nFile is empty $file \n";
	}  else {
		print qq ("Provide the path of JSON file or Directory path containing JSON file");
	}

	my $report ;
		foreach my $filename (@content) {
			if(-f $filename){
				$report = VT::read_json_file($filename,$log) ;

				 if (checkdb() eq '0E0'){  #create table for first time only
				 	eval {

				 			my $create = qq(CREATE TABLE virusscan (
				 						  md5 VARCHAR(50) not null PRIMARY KEY , 
				 						  resource VARCHAR(200),
				 						  total VARCHAR(20),
				 						  scan_date CHAR(200), 
				 						  sha256 VARCHAR(200) not null,
				 						  positives VARCHAR(200) , 
				 						  sha1 VARCHAR(200) not null, 
				 						  scan_id VARCHAR(200), 
				 						  verbose_msg VARCHAR(200), 
				 						  permalink VARCHAR(500) ,
				 						  scans JSON ,
				 						  response_code VARCHAR(200))
			 						);
				 			my $insert = $dbh->prepare($create);


							my $result_create = $insert->execute();
				 	};
				 	if($@) {

				 		print "Unable create table in database \n";

				 	}
 
				 } else {

				 	#insert 
				 	eval {
	
				 		 my $result = VT::save2db($report,$dbh,$log);
				 		print $log "Data from file $filename saved successfully \n" if($result);
				 		print  "Data from file $filename saved successfully \n" if($result);
				 		print $log "Unable to save data for file $filename in db\n" if(!$result);
				 	}; 
				 	if($@) {

				 		print "Unable Save in DB \n $@";

				 	}


				 }

			} else {

				print $log "File is empty or not exist:- $filename \n"
			}
	}
}

sub checkdb {
		my $query = $dbh->prepare("SHOW TABLES LIKE 'virusscan'");
		my $result = $query->execute();
}
