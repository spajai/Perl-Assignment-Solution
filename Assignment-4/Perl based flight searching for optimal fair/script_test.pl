#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use FileHandle;

my $dir ="new/";
my $fh1 = FileHandle->new;
my $fh2 = FileHandle->new;
my $fh3 = FileHandle->new;

if (!(-e $dir and -d $dir)) {
		qx(mkdir new/);
		$fh1->open(">new/provider1.txt");
	} else {
		$fh1->open(">new/provider1.txt");
}

	$fh2->open(">new/provider2.txt");
	$fh3->open(">new/provider3.txt");

	print $fh1 ("Origin,Departure Time,Destination,Destination Time,Price
LAS,6/23/2014 13:30:00,LAX,6/23/2014 14:40:00,\$151.00
YYZ,6/15/2014 6:45:00,YYC,6/15/2014 8:54:00,\$578.00
MIA,6/23/2014 19:40:00,ORD,6/23/2014 21:45:00,\$532.00
YYC,6/12/2014 11:00:00,YVR,6/12/2014 11:24:00,\$379.00
LHR,6/21/2014 11:05:00,BOS,6/21/2014 17:06:00,\$975.00
YVR,6/18/2014 9:10:00,YYZ,6/18/2014 19:47:00,\$1093.00
LAX,6/19/2014 8:45:00,YYC,6/19/2014 12:45:00,\$356.00
MIA,6/20/2014 7:45:00,ORD,6/20/2014 12:36:00,\$422.00");

	print $fh2 ("Origin,Departure Time,Destination,Destination Time,Price
JFK,6-21-2014 17:55:00,YEG,6-21-2014 23:23:00,\$589.00
LAS,6-22-2014 9:45:00,YYZ,6-22-2014 21:20:00,\$549.00
YVR,6-23-2014 9:20:00,YYZ,6-23-2014 15:22:00,\$1122.00
MSY,6-19-2014 5:55:00,YUL,6-19-2014 10:58:00,\$480.00
YYZ,6-26-2014 12:00:00,YYC,6-26-2014 14:09:00,\$630.00
LAX,6-19-2014 11:00:00,YYC,6-19-2014 17:45:00,\$543.00
YYC,6-23-2014 12:40:00,YYZ,6-23-2014 14:54:00,\$541.00
MIA,6-23-2014 19:40:00,ORD,6-23-2014 21:45:00,\$532.00
YVR,6-23-2014 22:10:00,YYZ,6-24-2014 2:22:00,\$1151.00
LAS,6-16-2014 8:11:00,YYZ,6-16-2014 19:28:00,\$703.00
LAX,6-21-2014 8:55:00,YYC,6-21-2014 15:10:00,\$577.00
YYZ,6-15-2014 7:00:00,YVR,6-15-2014 9:00:00,\$647.00
LHR,6-19-2014 6:30:00,BOS,6-19-2014 12:42:00,\$1243.00");

	print $fh1 ("Origin|Departure Time|Destination|Destination Time|Price
LAS|6/29/2014 14:55:00|LAX|6/29/2014 16:10:00|\$201.00
MIA|6/17/2014 14:55:00|ORD|6/17/2014 17:10:00|\$542.00
LAS|6/29/2014 7:30:00|YYZ|6/29/2014 13:58:00|\$678.00
YYZ|6/22/2014 12:00:00|YYC|6/22/2014 14:09:00|\$630.00
JFK|6/15/2014 9:30:00|YEG|6/15/2014 17:50:00|\$730.00
YYZ|6/13/2014 7:00:00|YVR|6/13/2014 9:00:00|\$648.00
MIA|6/22/2014 6:50:00|ORD|6/22/2014 9:02:00|\$576.00
YYC|6/23/2014 14:15:00|YYZ|6/23/2014 21:59:00|\$573.00
YYZ|6/15/2014 18:00:00|YVR|6/15/2014 20:00:00|\$698.00
LAS|6/16/2014 8:11:00|YYZ|6/16/2014 19:28:00|\$703.00
LHR|6/27/2014 16:40:00|BOS|6/27/2014 18:50:00|\$1616.00
MSY|6/19/2014 14:55:00|YUL|6/19/2014 23:24:00|\$645.00
YYZ|6/22/2014 12:00:00|YYC|6/22/2014 14:09:00|\$630.00
LAS|6/15/2014 9:54:00|LAX|6/15/2014 11:05:00|\$286.00
YYC|6/30/2014 9:30:00|YYZ|6/30/2014 17:05:00|\$535.00");

	my($scriptresult,$expectedoutput,$testname);
	qx(cp flightsearch.pl new/.);
	$scriptresult->{SCRIPTRESULT1} = qx(perl flightsearch.pl -o LAS -d YYZ);
	$scriptresult->{SCRIPTRESULT2} = qx(perl flightsearch.pl -o LaS -d Yyz);
	$scriptresult->{SCRIPTRESULT3} = qx(perl flightsearch.pl -o LAS -d YYA);
	$scriptresult->{SCRIPTRESULT4} = qx(perl flightsearch.pl -o YYZ -d YYZ);
	$scriptresult->{SCRIPTRESULT5} = qx(perl flightsearch.pl -o YYZ -d YYC);
	$scriptresult->{SCRIPTRESULT6} = qx(perl flightsearch.pl -o MIA -d ORD);
	$testname->{TEST1} = "Test For valid Flight";
	$testname->{TEST2} = "Test For Valid Flight";
	$testname->{TEST3} = "Test For No Flight Found";
	$testname->{TEST4} = "Test For No Flight Found";
	$testname->{TEST5} = "Test For Same Price But Early departure";
	$testname->{TEST6} = "Test For Dumplicate Records";
	$expectedoutput->{EXPECTEDOUTPUT1} = ("LAS --> YYZ (6/22/2014 9:45:00 --> 6/22/2014 21:20:00) - \$549.00
LAS --> YYZ (6/29/2014 7:30:00 --> 6/29/2014 13:58:00) - \$678.00
LAS --> YYZ (6/16/2014 8:11:00 --> 6/16/2014 19:28:00) - \$703.00");

	$expectedoutput->{EXPECTEDOUTPUT2} = ("LAS --> YYZ (6/22/2014 9:45:00 --> 6/22/2014 21:20:00) - \$549.00
LAS --> YYZ (6/29/2014 7:30:00 --> 6/29/2014 13:58:00) - \$678.00
LAS --> YYZ (6/16/2014 8:11:00 --> 6/16/2014 19:28:00) - \$703.00");

	$expectedoutput->{EXPECTEDOUTPUT3} = ("No Flights For this route Origin :- LAS  Destination :- YYA");

	$expectedoutput->{EXPECTEDOUTPUT4} = ("No Flights For this route Origin :- YYZ  Destination :- YYZ");

	$expectedoutput->{EXPECTEDOUTPUT5} = ("YYZ --> YYC (6/15/2014 6:45:00 --> 6/15/2014 8:54:00) - \$578.00
YYZ --> YYC (6/22/2014 12:00:00 --> 6/22/2014 14:09:00) - \$630.00
YYZ --> YYC (6/26/2014 12:00:00 --> 6/26/2014 14:09:00) - \$630.00");

	$expectedoutput->{EXPECTEDOUTPUT6} = ("MIA --> ORD (6/20/2014 7:45:00 --> 6/20/2014 12:36:00) - \$422.00
MIA --> ORD (6/23/2014 19:40:00 --> 6/23/2014 21:45:00) - \$532.00
MIA --> ORD (6/17/2014 14:55:00 --> 6/17/2014 17:10:00) - \$542.00
MIA --> ORD (6/22/2014 6:50:00 --> 6/22/2014 9:02:00) - \$576.00");

	foreach(1..6) {
		print "Running Unit Test $_/6 $testname->{\"TEST$_\"} \n Result :- ";
		chomp($scriptresult->{"SCRIPTRESULT$_"});
		chomp($expectedoutput->{"EXPECTEDOUTPUT$_"});
		if( $scriptresult->{"SCRIPTRESULT$_"} eq  $expectedoutput->{"EXPECTEDOUTPUT$_"} ) {
			print "TEST PASS\n";
		}else  {
			print "TEST NUMBER $_ FAILED \n";
		}
	} 
