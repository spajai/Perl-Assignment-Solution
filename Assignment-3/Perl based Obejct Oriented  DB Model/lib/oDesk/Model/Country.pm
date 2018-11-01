package oDesk::Model::Country;

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

sub new {
    my ($class, %params) = @_;

    die "Attribute \(db\) is required at constructor" unless ($params{db});

    my $self = bless \%params, $class;

    return $self;
}

sub get_all_hashref {
    my ($self) = @_;
    my $dbh = $self->{db}->dbh;

    my $ary_ref = $dbh->selectcol_arrayref("select id, name from country", { Columns => [ 1, 2 ] }) || [];
    my %hash = @$ary_ref;

    return \%hash;
}

sub get_country_names {
    my ($self) = @_;
    my $dbh = $self->{db}->dbh;

    my $ary_ref = $dbh->selectcol_arrayref("select name from country order by name asc") || [];

    return wantarray ? @$ary_ref : $ary_ref;
}

sub get_name_for_id {
    my ($self, $id) = @_;
    return '' unless ($id);

    return $self->get_from_db('name', $id);
}

sub get_id_for_name {
    my ($self, $name) = @_;
    return '' unless ($name);

    return $self->get_from_db('id', $name);
}

sub get_from_db {
    my ($self, $get, $param) = @_;
    my $dbh = $self->{db}->dbh;
    my $col = $get eq 'name' ? 'id' : 'name';

    my @result = $dbh->selectrow_array("select $get from country where $col = ?", undef, $param);

    return $result[0] || '';

}

1;

=pod

__END__

=pod

=head1 NAME

oDesk::Model::Country

=head1 SYNOPSIS

  oDesk::Model::Country;
  my $model = oDesk::Model::Country->new;

  # to get get_all_hashref of the country
  my $country_hash = $model->get_all_hashref;

=head1 INTRODUCTION

oDesk::Model::Country is A custom country model

=head1 METHODS

=head2 get_all_hashref

    #my $country_has = $model->get_all_hashref;

    returns country hash
 
=head2 get_country_names

     #my $get_country_names = $model->get_country_names;
     #my @get_country_names = $model->get_country_names;

     returns country name array or array depends on what is asked

=head2 get_name_for_id

     #my $name = $model->get_name_for_id($id);

     returns country name for id provided
     intenally uses get_from_db
=head2 get_id_for_name

     #my $id = $model->get_id_for_name($name);

     returns id for country name provided
     intenally uses get_from_db

=head1 AUTHOR

Sushrut Pajai <spajai@cpan.com>

=cut
