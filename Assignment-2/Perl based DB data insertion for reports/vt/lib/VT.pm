package VT;

###################################################
#
#  Author eamil : Spajai@cpan.org
#
#
####################################################

#  Read VirusTotal.com malware sample reports

use strict;
use warnings;
use Try::Tiny;
# use JSON::Tiny;
use DBI;
use JSON;
use File::Find;
use Data::Dumper;
use DBI;
local $/  = undef;   # enable file slurp mode
sub usage {
    print qq ("Please provide the JSON file to load");
    exit;
}

sub read_json_file {
    my $fname = shift || usage();
    my $log = shift;
	my $data;
	open my ( $fh ), "$fname"or warn("could not read the file: $fname - $!"),return;
	while (<$fh>) {
		$data .= $_;
	}
	try {
		my $json = decode_json($data);
		return $json;
	} catch {
		print $log "\nMalfunctioned JSON in file $fname \n";
		return;

	}
}

sub save2db {
	my ($report,$dbh,$log) = (@_);
	# die unless ( $dbh && $report);
	my $result;	
	my $ok  =0;

		#lest validate and interate now
		foreach my $colname (keys %{$report}) {
			if($colname eq 'md5') {

				if(exists $report->{$colname}) {

					my $check = $dbh->prepare("select 1 from virusscan where $colname = \"$report->{$colname}\"");
					my $result_create = $check->execute();
					if($result_create ne '0E0') {
						print $log "Data for md5  $report->{$colname} already exists in database\n";
						return;
					} else {
						$ok = 1;
					}

				} else {
					print $log "Primary key missing \n";
					return;
				}
			} 
		}
	
		if($ok) {
			my $scan;
			if (exists $report->{scans}) {
				 $report->{scans} = encode_json($report->{scans});
			}
			my @values = values %{$report};
			my @columns = keys %{$report};
			if(scalar @columns == scalar @values) {
				my $sql = "INSERT INTO virusscan(md5,resource,total,scan_date,sha256,positives,sha1,scan_id,verbose_msg,permalink,response_code,scans) VALUES ('$report->{md5}','$report->{resource}','$report->{total}','$report->{scan_date}','$report->{sha256}','$report->{positives}','$report->{sha1}','$report->{scan_id}','$report->{verbose_msg}','$report->{permalink}','$report->{response_code}','$report->{scans}')";
				my $sth = $dbh->prepare($sql);
				$result = $sth->execute();
			}
			return $result;

		}

	return;
}



1;
