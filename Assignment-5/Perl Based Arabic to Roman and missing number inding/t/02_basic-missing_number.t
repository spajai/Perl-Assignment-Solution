use strict;
use warnings;

use lib '../lib';

use Test::More;

use_ok('MissingNumber');

#-------------------------------------------------------------------------------

#instantiation
{
    my $obj = MissingNumber->new;
    isa_ok($obj, 'MissingNumber');
}

#-------------------------------------------------------------------------------

{
    my $api_obj = MissingNumber->new;

    my $tests = {
        "1:2:3:4;5;6:8 9\n10\r\n11:7 13" => '7',
        "1:2:3:4;5;6:8 9\n10\r\n11:7 13" => '12',
        "5;6:1:2:3:4:9\n10\r\n11:7:13:8" => '12',
        "1:2:3:4;5;6:7:8:9\n11" => '10',
        "1:2:3:4;5;7" => '6',
        
    };

    foreach my $input (keys %$tests) {
        my $result = $api_obj->get_missing_number($input);
        ok($result eq $tests->{$input},"Missing '$result' verified");
    }
}

#-------------------------------------------------------------------------------

{
    my $api_obj = MissingNumber->new;

    my @expected = qw/1 2 3 4 5 6 7 8 9/;

    my @result = $api_obj->get_sorted_list('1 2 6 3 4 5 8 7 9');

    is_deeply([@result] ,[@expected],"Sort method verified");
}

#-------------------------------------------------------------------------------

done_testing();