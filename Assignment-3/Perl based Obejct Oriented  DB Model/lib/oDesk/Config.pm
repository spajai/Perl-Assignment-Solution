package oDesk::Config;

use strict;
use warnings;


sub new {
  my ($class, %params) = @_;

  my $path = __FILE__;
  $path =~ s/Config\.pm$//;
  $params{this_path} = $path;

  my $self = bless \%params, $class;
  return $self;
}

sub base_path {
  my $self = shift;
  return $self->{this_path} . "../../";
}

sub lib_path {
  my $self = shift;
  return $self->base_path . 'lib';
}

sub db_path {
  my $self = shift;
  return $self->base_path . 'db/odesk.db';
}

1;

__END__

=pod

=head1 NAME

oDesk::Confg

=head1 SYNOPSIS

  use oDesk::Config;
  my $config = oDesk::Config->new;

  # to get path of the root directory of the perl test
  my $base_path = $config->base_path;

  # get path of lib directory of the perl test
  my $lib_path = $config->lib_path;

  # get sqlite database file path
  my $db_path = $config->db_path;

=head1 INTRODUCTION

A basic configuration class for the oDesk Perl Developer Test.

=head1 METHODS

=head2 base_path

  my $base_path = $config->base_path;

If you untar the perl test tarball in your home directory, the value
returned for $base_path is /home/youraccount or whatever is equivalent
to ~/ on your system.

=head2 lib_path

  my $lib_path = $config->lib_path;

Returns the path to the location where the perl test perl modules/classes reside.
This should be: [base_path]/lib

=head2 db_path

  my $db_path = $config->db_path;

Returns the path to the location where the SQLite3 database resides.
This should return [base_path]/odesk.db

=head1 AUTHOR

Rick Apichairuk <rapichai@odesk.com>

=cut
