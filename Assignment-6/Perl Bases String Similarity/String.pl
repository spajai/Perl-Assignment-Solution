use strict;
use warnings;
use Getopt::Long qw(GetOptions);

#set Defaults as per the requirement
GetOptions (
    'string=s'       => \my $inp_string,       # string input string
    'window-size=i'  => \my $window_size,  # Custom window_size
    'step-size=i'    => \my $step_size,    # Custom step_size
    'help'           => \my $help,         # print help
);

sub usage {
    die "
        String Maching 
        example :-
            perl $0 --string \"100000101010110101111110\" --window-size '12' --step-size '2'
        Usage :-
           $0 [--string \"100000101010110101111110\"] [--window-size '12'] [--step-size '2']
           Options:
            --string            (String) of  user input
            --window-size       (number) of  window-size number (Positive integer should be greater than 0)'
            --step-size         (number) of  step size number (optional Default equal to window-size)
            --help              (flag)   To  display this help\n"
      ;
}

usage() if ($help || !$inp_string || $inp_string eq '' || !$window_size || $window_size < 1);

sub char_test {
    my ($str1, $str2) = @_;

    my @arr1 = split(//,$str1);
    my @arr2 = split(//,$str2);
    
    return 0 if length($str1) != length($str2);
    
    my $total_char = length($str1);

    my $match_char = 0;

    foreach my $i (0..(scalar @arr1 - 1)){
        my $test = $arr2[$i];
        if ( $arr1[$i] =~ /$test/ ) {
            $match_char++;
        }
    }

    return $match_char / $total_char;
}

sub mirror_test {
    my ($str1 ,$str2) = (@_);

    my $res = {
        str1 => $str1,
        str2 => $str2,
        match => 0
    };

    my $rev_str_1 = reverse $str1;

    if ($rev_str_1 eq $str2) {
        $res->{result} =  "Reverse of $str1 and $str2 are matching";
        $res->{match} = 1;
    }

    my $rev_str_2 = reverse $str2;

    if ($rev_str_2 eq $str1) {
        $res->{result} = "Reverse of $str2 and $str1 are matching";
        $res->{match} =  1;
    }

    return $res;
}

sub split_string {
    my ($string, $window_size, $step_size) = (@_);

    my $len = length($string);
    my $index = 0;
    
    my @arr;
    while(  $index < $len ) {
        my $substring = substr($string, $index, $window_size);
        push (@arr, $substring);
        $index += $step_size;
    }
    
    return @arr;
}

sub format_print {
    my ($total_str, @arr) = @_;
    
    print "Total substring : $total_str\n";
    
    foreach my $row (@arr) {
        print $row->{result} . ' ' . sprintf('%.4f', $row->{match}) . "\n";
    }
}

sub main {
    chomp ( $inp_string );
    chomp ( $window_size );
    $step_size ||= $window_size;
    chomp ( $step_size );
    
    my @arr = split_string($inp_string, $window_size, $step_size);
    my $total_substring = scalar @arr;

    my @result;
    while (my $str1 = shift @arr) {
        foreach my $str2 (@arr) {
            if ( $str1 eq $str2 ) {
                push @result, {
                    'str1' => $str1,
                    'str2' => $str2,
                    'result' => "$str1 and $str2 are matching",
                    'match' => 1
                };
            } 
            else {
            
                my $mirror_test = mirror_test($str1, $str2);
                if ( $mirror_test->{match} ) {
                    push @result, $mirror_test; 
                }
                else {
                    my $match = char_test($str1, $str2);
                    push @result, {
                        'str1' => $str1,
                        'str2' => $str2,
                        'result' => "$str1 and $str2 are matching",
                        'match' => $match
                    };
                }
            }
            
        }
    }
    
    format_print($total_substring, @result);
}

main();

=pod

Enable to test single character match with other string.

sub char_fuzzy_test {
    my ($str1, $str2) = @_;

    my @arr1 = split(//,$str1);
    my @arr2 = split(//,$str2);
    my $total_char = length($str1 . $str2);

    my $count1 = 0;
    my $count2 = 0;

    foreach my $c1 (@arr1){
        foreach my $c2 (@arr2){
            if ( $c1 =~ /$c2/ ) {
                $count1++;
                last;
            }
        }
    }

    print Dumper($count1);

    my $match_char = $count1 + $count2;

    return sprintf "%.2f" , ( $match_char / $total_char);
}
=cut