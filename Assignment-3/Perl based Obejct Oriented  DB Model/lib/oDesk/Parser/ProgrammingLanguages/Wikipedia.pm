package oDesk::Parser::ProgrammingLanguages::Wikipedia;

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use LWP::UserAgent;
use HTML::TreeBuilder;

sub new {
    my ($class, %params) = @_;

    $params{ua} = LWP::UserAgent->new;

    my $self = bless \%params, $class;

    return $self;
}

sub url {
    my ($self) = @_;
    my $default_url = 'http://en.wikipedia.org/wiki/List_of_programming_languages';

    return $self->{url} || $default_url;
}

sub get_data {
    my ($self) = @_;
    my $url    = $self->url;
    my $ua     = $self->{ua};
    my $tree;

    my $res = $ua->get($url);
    my @res;

    if ($res->code eq '200') {
        $tree = HTML::TreeBuilder->new_from_content($res->content);
    } else {
        die "Unable to connect" . $res->content . "\n";
    }

    foreach ($tree->look_down(class => 'div-col columns column-width')) {
        foreach my $link ($_->look_down('_tag', 'a')) {
            push @res, $link->as_text;
        }
    }

    return wantarray ? @res : \@res;

}

sub get_anagrams {
    my ($self) = @_;

    my @data = $self->get_data;
    my @res  = $self->find_anagrams(\@data);
    my %anag;

    foreach my $lan (@res) {
        $lan = uc($lan);
        $anag{$lan}++;
    }

    return [ sort keys %anag ];

}

sub find_anagrams {
    my ($self, $data) = @_;
    my %anagrams;
    my @res;

    foreach my $word (@$data) {
        my $key = join '', sort(split(//, lc($word)));
        push @{ $anagrams{$key} }, $word;
    }

    foreach my $lst (values %anagrams) {
        if (1 < @$lst) {
            push @res, @$lst;
        }
    }

    return @res;
}

1;

__END__

=pod

=head1 NAME

oDesk::Parser::ProgrammingLanguages::Wikipedia

=head1 SYNOPSIS

  oDesk::Parser::ProgrammingLanguages::Wikipedia;
  my $c1 = oDesk::Parser::ProgrammingLanguages::Wikipedia->new(url => $url);

  # to get default url
  my $url = $c1->url;

=head1 INTRODUCTION

oDesk::Parser::ProgrammingLanguages::Wikipedia is A custom parser

=head1 METHODS

=head2 get_anagrams

    #my $data_array_ref = $c1->get_anagrams;

    Smartly crafted sub to extract all programming lan from url.
 
=head2 get_anagrams

     #my $get_ang = $c1->get_anagrams;

     returns anagrams

=head2 find_anagrams
    #internal method

=head1 AUTHOR

Sushrut Pajai <spajai@cpan.com>

=cut