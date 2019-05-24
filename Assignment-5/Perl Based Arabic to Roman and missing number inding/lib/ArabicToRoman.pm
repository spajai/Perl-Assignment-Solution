package ArabicToRoman;

use strict;
use warnings;

=head1 NAME

    ArabicToRoman Module for conversion of arabic numerics to roman numerics

=head1 VERSION

    Version 0.10

=head1 SYNOPSIS
    ArabicToRoman Module for conversion of arabic numerics to roman numerics

=head1 SUBROUTINES/METHODS

    Example/Usage :-
 
    use ArabicToRoman;

    my $api_obj = ArabicToRoman->new();

    print $api_obj->arabic_to_roman(1776);

=cut

our $VERSION = '0.10';

#see pod
sub new {
    return ( bless({}, shift) );
}

#see pod
sub arabic_to_roman {
    my ($self, $input) = (@_);

    #return undef if input is blank
    return undef if ($input eq '');
    return 0 if ($input == 0);

    #get symbol_map
    my @symbol_map = $self->_get_symbol_map();
    my $result;

    #append '-' sign if input is negative
    if($input < 0) {
        $result ='-';
        $input = -1 * $input; #need postive value to operate
    }

    foreach my $map (@symbol_map) {
    #derefer the array ref
    my($arabic, $roman) = @$map;
        #iterate till input is greater than equal to 1
        if ($input >= $arabic) {
            ($result, $input) = ($result .= $roman x int($input/$arabic),  $input % $arabic);
        }
    }

  return $result;
}

#see pod
sub _get_symbol_map {
    my ($self) = (@_);

    my @symbol_map = ( 
        [1000, 'M'],
        [500, 'D'],
        [100, 'C'],
        [50, 'L'],
        [10, 'X'],
        [5, 'V'],
        [1, 'I'],
    );

    return @symbol_map;
}

1;

__END__

=head2 new

    constructor for ArabicToRoman

    my $api = ArabicToRoman->new();

=cut


=head2 arabic_to_roman
    method to convert arabic input to roman.
    
    B<Input> :- String 
                Invocant and Arabic number to be converted. Positive and negative both supported
    B<Ouput> :- String/undef(in case of blank input)
                equivalent roman symbol for given arabic number

    This method will return null if input given is blank.
    It will call _get_symbol_map internally. 
    Will append the -ve symbol if input is -ve.
    It will itegrate the symbol_map values given order until input is greater than equal to 1.
    while iterating it will append the equivalent roman values if its complete divisible.
    and it will update the input value i.e the conveted value will be excluded in next run.
    
=head2 Example

    $api_obj->arabic_to_roman(1776);
    $api_obj->arabic_to_roman(-1776);
    $api_obj->arabic_to_roman(6);

=cut


=head2 _get_symbol_map
    Private method to get symbol map 
    
    B<Input> :- N/A
                Invocant needed for calling
    B<Ouput> :- Array of (array ref)

    This method will return arabic symbol to roman map
    Additional map can be added as well.
    eg :- But need to be added in proper order i.e Desc

    [900, 'CM'],
    [400, 'CD'],
    [90, 'XC'],
    [40, 'XL'],
    [9, 'IX'],
    [4, 'IV'],

=cut