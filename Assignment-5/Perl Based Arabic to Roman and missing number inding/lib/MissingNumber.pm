package MissingNumber;

use strict;
use warnings;
use List::Util qw(reduce sum);

=head1 NAME

    MissingNumber Module for finding the missing number from the unsorted string of number

=head1 VERSION

    Version 0.10

=head1 SYNOPSIS
    
=head1 SUBROUTINES/METHODS

    Example/Usage :-
 
    use MissingNumber;

    my $api_obj = MissingNumber->new();

    print $api_obj->get_missing_number("1:2:3:4;5;6:8 9\n10\r\n11:7 13");

=cut

our $VERSION = '0.10';

#see pod
sub new {
    return ( bless({}, shift) );
}

#see pod

sub get_missing_number {
    my ($self, $input) = (@_);

    my @list = $self->get_sorted_list($input);

    my $missing_number = $self->_missing_number(@list);

    return $missing_number;
}

sub get_sorted_list {
    my ($self, $input) = (@_);

    #split
    my @list = split('\s+|\,|\:|\;|\n|\r\n', $input);

    #retun numerically sortred list
    my @sorted_list = sort { $a <=> $b } @list;

    return @sorted_list;

}

sub _missing_number {
    my ($self, @list) = (@_);

    #first element lowest
    my $first_element = $list[0];

    #last element highest
    my $last_element = $list[-1];

    #sum first and last
    my $range_sum = sum($first_element..$last_element);

    #now deduct everything in list
    my $array_sum = reduce { $a + $b } @list;

    #total - remaining is missing number
    return $range_sum - $array_sum;

}

1;

__END__

=head2 new

    constructor for MissingNumber

    my $api = MissingNumber->new();

=cut


=head2 get_missing_number

    method to get missing number from the unsorted list of number string separated by :,\n\r\n etc.

    B<Input> :- String 
                Invocant and unsorted string of numbers
    B<Ouput> :- Scalar 
                missing digit

    This method will return missing digit from numebr string
    It will call _missing_number internally.
    Method will first call get_sorted_list
    and private method _missing_number

    
=head2 Example

    print $api_obj->get_missing_number("1:2:3:4;5;6:8 9\n10\r\n11:7 13");
    print $api_obj->get_missing_number("1:2:3:4;5:   6 8\n9\n10\r\n11:7 13");
    print $api_obj->get_missing_number("1:2:3:4;5;6:8");
    print $api_obj->get_missing_number("1 2 3 4 5 8");

=cut


=head2 get_sorted_list
    It will split and sort the array numerically
    
    B<Input> :- String of numbers (unsorted)
                
    B<Ouput> :- Sorted array of numbers

=cut

=head2 _missing_number
    It will split and sort the array numerically
    basically follows ;
    Sum first and last number and reduce the number from sum 
    remainng number is missing number

    B<Input> :- Sorted array of number
                
    B<Ouput> :- Scalar (missing number)

=cut