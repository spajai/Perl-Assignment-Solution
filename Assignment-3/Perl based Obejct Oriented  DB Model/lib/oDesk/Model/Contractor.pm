package oDesk::Model::Contractor;

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

use SQL::Abstract;

our $AUTOLOAD;

sub new {
    my ($class, %params) = @_;

    die "Attribute \(db\) is required at constructor" unless ($params{db});

    my $self = bless \%params, $class;

    return $self;
}

sub AUTOLOAD {
    my ($self, $val) = (@_);
    my $method = $AUTOLOAD;

    $method =~ s/.*:://;

    $self->{data}->{$method} = $val if (scalar(@_) > 1);

    return exists($self->{data}->{$method}) ? $self->{data}->{$method} : undef;
}

sub get_all {
    my ($self) = @_;
    my $dbh = $self->{db}->dbh;

    my $ary_ref = $dbh->selectcol_arrayref("select * from contractor") || [];

    return wantarray ? @$ary_ref : $ary_ref;
}

sub create {
    my ($self, %data) = @_;
    my $dbh = $self->{db}->dbh;
    my $sql = SQL::Abstract->new;
    my ($stmt, @bind);
    %{ $self->{data} } = %data;
    foreach my $col (qw/first_name last_name hourly_rate country_id/) {
        return unless (defined $data{$col});
    }

    ($stmt, @bind) = $sql->select('contractor', '*', \%data);
    my $row = $dbh->selectrow_hashref($stmt, undef, @bind);

    if (keys %$row) {
        %{ $self->{data} } = %$row;
        $self->{id} = $row->{id};
        return $self->{id};
    }

    eval {
        ($stmt, @bind) = $sql->insert('contractor', \%data);
        my $sth = $dbh->prepare($stmt);
        $sth->execute(@bind);
    };

    die $@ if ($@);

    $self->{id} = $self->get_existing(\%data, 'id');
    $self->{data}->{id} = $self->{id};

    return $self->{id};
}

sub get_existing {
    my ($self, $data, $id) = @_;
    my $dbh = $self->{db}->dbh;
    my $sql = SQL::Abstract->new;
    my ($stmt, @bind);

    # %{$self->{data}} = %data;
    delete $data->{id};
    ($stmt, @bind) = $sql->select('contractor', '*', $data);
    my $row = $dbh->selectrow_hashref($stmt, undef, @bind);

    return $id ? $row->{id} : $row;
}

sub get_common_skills {
    my ($self, $c1, $c2) = @_;
    my $id  = $c1->id;
    my $id2 = $c2->id;
    my $dbh = $self->{db}->dbh;

    my $sql = <<SQL;
select skill_id from contractor_skill where contractor_id = ?
intersect 
select skill_id from contractor_skill where contractor_id = ?
SQL

    my $row = $dbh->selectcol_arrayref($sql, undef, $id, $id2);

    return @$row;

}

sub load {
    my ($self, $id) = @_;
    my $dbh = $self->{db}->dbh;
    my $sql = SQL::Abstract->new;

    return undef unless ($id);

    my ($stmt, @bind) = $sql->select('contractor', '*', { 'id' => $id });
    my $row = $dbh->selectrow_hashref($stmt, undef, @bind);

    if (keys %$row) {
        %{ $self->{data} } = %$row;
        $self->{data}->{id} = $row->{id};
        return %$row;
    }

}

sub delete {
    my ($self, $id) = @_;
    my $dbh = $self->{db}->dbh;
    my $sql = SQL::Abstract->new;

    return undef unless ($id);
    my ($stmt,    @bind)    = $sql->delete('contractor',       { 'id'            => $id });
    my ($stmt_sk, @bind_sk) = $sql->delete('contractor_skill', { 'contractor_id' => $id });

    eval {
        my $sth    = $dbh->prepare($stmt);
        my $sth_sk = $dbh->prepare($stmt_sk);
        $sth->execute(@bind);
        $sth_sk->execute(@bind_sk);

        # $self->{data}->{id} = $dbh->{'mysql_insertid'};
        # return $self->{data}->{id};
    };

    if ($@) {
        die $@;
    }

}

sub update {
    my ($self) = @_;
    my $dbh    = $self->{db}->dbh;
    my $sql    = SQL::Abstract->new;
    my $id     = $self->{id};
    return undef unless ($id);

    my ($stmt, @bind) = $sql->update('contractor', $self->{data}, { 'id' => $id });

    eval {
        my $sth = $dbh->prepare($stmt);
        $sth->execute(@bind);
    };

    if ($@) {
        die $@;
    }

}

sub add_skill {
    my ($self, $skill_id) = @_;
    my $dbh = $self->{db}->dbh;
    my $sql = SQL::Abstract->new;
    return unless ($skill_id);

    my $data = {
        skill_id      => $skill_id,
        contractor_id => $self->{id} || $self->{data}->{id},
    };

    my ($stmt, @bind) = $sql->select('contractor_skill', '*', $data);
    my $row = $dbh->selectrow_hashref($stmt, undef, @bind);

    return $self->{id} if (keys %$row);

    eval {
        ($stmt, @bind) = $sql->insert('contractor_skill', $data);
        my $sth = $dbh->prepare($stmt);
        $sth->execute(@bind);
    };

    die $@ if ($@);

}

sub get_skills {
    my ($self) = @_;
    my $dbh = $self->{db}->dbh;

    my $skill_id = $dbh->selectcol_arrayref("select skill_id from contractor_skill") || [];

    return wantarray ? @$skill_id : $skill_id;
}

sub delete_skill {
    my ($self, $skill_id) = @_;
    my $dbh = $self->{db}->dbh;
    my $sql = SQL::Abstract->new;

    return undef unless ($skill_id);
    my $where = {
        skill_id      => $skill_id,
        contractor_id => $self->{id} || $self->{data}->{id},
    };
    my ($stmt, @bind) = $sql->delete('contractor_skill', $where);

    eval {
        my $sth = $dbh->prepare($stmt);
        $sth->execute(@bind);
        return $self->{data}->{id};
    };

    if ($@) {
        die $@;
    }

}

done_testing();

1;

__END__

=pod

=head1 NAME

oDesk::Model::Contractor

=head1 SYNOPSIS

  oDesk::Model::Contractor;
  my $c1 = oDesk::Model::Contractor->new(db => $db);
  $c1->load($contractor1_id);

  # to get get_all of the Contractor skill
  my $Contractor_hash = $c1->get_all;

=head1 INTRODUCTION

oDesk::Model::Contractor is A custom Contractor model

=head1 METHODS

=head2 add_skill

    #my $skill_has = $c1->add_skill('$id');

    adds skill for Contractor
 
=head2 get_skills

     #my $get_skills = $c1->get_skills;
     #my @get_skills = $c1->get_skills;

     returns skill name array or array depends on what is asked

=head2 update
    #set the method values and update 
    $model->update();
   
=head2 delete

    $model->delete($c2->id);
    delete skill id for Contractor

=head2 add_skill

    #my $get_skills = $c->add_skill($id);
    add's skill id for Contractor
=head1 AUTHOR

Sushrut Pajai <spajai@cpan.com>

=cut
