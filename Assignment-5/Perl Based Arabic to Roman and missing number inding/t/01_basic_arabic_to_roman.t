use strict;
use warnings;

use lib '../lib';

use Test::More;

use_ok('ArabicToRoman');

#-------------------------------------------------------------------------------

#instantiation
{
    my $obj = ArabicToRoman->new;
    isa_ok($obj, 'ArabicToRoman');
}

#-------------------------------------------------------------------------------

{
    my $obj = ArabicToRoman->new;
    my $api_obj = ArabicToRoman->new();
    my $tests = {
        '1776'  => 'MDCCLXXVI',
        '-1776' => '-MDCCLXXVI',
        '1'     => 'I',
        '0'     => 0,
        '5000'  => 'MMMMM',
        '2222'  => 'MMCCXXII',
        '1234'  => 'MCCXXXIIII',
    };

    foreach my $input (keys %$tests) {
        my $result = $api_obj->arabic_to_roman($input);
        ok($result eq $tests->{$input},"Roman equivalent of '$input' is '$result'");
    }
}

#-------------------------------------------------------------------------------

{
    my $obj = ArabicToRoman->new;
    my @symbol_map_got = $obj->_get_symbol_map();

    my @symbol_map_expected = ( 
        [1000, 'M'],
        [500, 'D'],
        [100, 'C'],
        [50, 'L'],
        [10, 'X'],
        [5, 'V'],
        [1, 'I'],
    );

    is_deeply(\@symbol_map_expected, \@symbol_map_expected ,"Symbol map verified");
}

#-------------------------------------------------------------------------------

done_testing();