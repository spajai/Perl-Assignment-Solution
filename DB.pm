package DB;

use strict;
use warnings;

use DBI;

sub new {
    return bless({}, shift);
}

# MySQL database configuration

# connect to MySQL database

sub connect_db {
    my $self     = shift;
    my $dsn      = 'DBI:mysql:shop';
    my $username = "root";
    my $password = 'root';
    my %attr     = (
        PrintError => 0,
        RaiseError => 1,
        AutoCommit => 1,
    );

    return DBI->connect($dsn, $username, $password, \%attr) || die "Unable to connect to DB $@";
}

sub insert_update_log {
    my $self   = shift;
    my $name   = shift;
    my $params = shift;
    my $db     = $self->connect_db();

    #report finish
    if (exists $self->{log_id} && defined $self->{log_id}) {
        my $sth = $db->prepare("update log set finish = ? where id = ?");
        $sth->execute('y', $self->{log_id});
        return 1;
    }
    else {
        #insert
        my $sth = $db->prepare("Insert into log (script_name,params) values (?,?)");
        $sth->execute($name, $params);
        $self->{log_id} = $sth->{'mysql_insertid'};
        return $self->{log_id};
    }
}

sub insert_cust {
    my $self  = shift;
    my $data  = shift;
    my $db    = $self->connect_db();
    my $exist = $self->get_cust($data->{CUSTOMER_NAME} || $data->{MANAGERID});
    return if (scalar @$exist);

    my $sth = $db->prepare("Insert into customer (CUSTOMER_NAME,MANAGERID,ASSET) values (?,?,?)");
    $sth->execute($data->{CUSTOMER_NAME}, $data->{MANAGERID}, $data->{ASSET});
    return $sth->{'mysql_insertid'};
}

sub insert_manager {
    my $self  = shift;
    my $data  = shift;
    my $db    = $self->connect_db();
    my $exist = $self->get_man($data->{MANAGER_NAME} || $data->{MANAGERID});
    return if (scalar @$exist);

    my $sth = $db->prepare("Insert into manager (MANAGER_NAME,MANAGERID) values (?,?)");
    $sth->execute($data->{MANAGER_NAME}, $data->{MANAGERID});
    return $sth->{'mysql_insertid'};

}

sub insert_manf {
    my $self  = shift;
    my $data  = shift;
    my $db    = $self->connect_db();
    my $exist = $self->get_maf($data->{MANUFACTURER_ID}, $data->{ASSET});
    return if (scalar @$exist);

    my $sth = $db->prepare(
        "Insert into manufacturer (MANUFACTURER_ID,MANUFACTURER,MANUFACTURE_DATE,ASSET,REPLACE_DATE) values (?,?,?,?,?)");
    $sth->execute(
        $data->{MANUFACTURER_ID},
        $data->{MANUFACTURER}, $data->{MANUFACTURE_DATE},
        $data->{ASSET}, $data->{REPLACE_DATE}
    );
    return $sth->{'mysql_insertid'};
}

sub get_cust {
    my $self = shift;
    my $id   = shift;
    my $db   = $self->connect_db();
    my $res  = [];

    #report finish
    if ($id) {
        my $sth = $db->prepare("select * from customer where customer_name= ? or managerid = ?");
        $sth->execute($id, $id);
        while (my $row = $sth->fetchrow_hashref) {
            push @$res, $row;
        }
        return $res;
    }
    else {
        my $sth = $db->prepare("select * from customer");
        $sth->execute($id, $id);
        while (my $row = $sth->fetchrow_hashref) {
            push @$res, $row;
        }
        return $res;
    }
}

sub get_man {
    my $self = shift;
    my $id   = shift;
    my $db   = $self->connect_db();
    my $res  = [];

    #report finish
    if ($id) {
        my $sth = $db->prepare("select * from manager where manager_name= ? or managerid = ?");
        $sth->execute($id, $id);
        while (my $row = $sth->fetchrow_hashref) {
            push @$res, $row;
        }
        return $res;
    }
    else {
        my $sth = $db->prepare("select * from manager");
        $sth->execute();
        while (my $row = $sth->fetchrow_hashref) {
            push @$res, $row;
        }
        return $res;
    }
}

sub get_maf {
    my $self = shift;
    my $id   = shift;
    my $id2  = shift;
    my $db   = $self->connect_db();
    my $res  = [];

    #report finish
    if ($id) {
        my $sth = $db->prepare("select * from manufacturer where manufacturer_id = ? and asset = ?");
        $sth->execute($id, $id2);
        while (my $row = $sth->fetchrow_hashref) {
            push @$res, $row;
        }
        return $res;
    }
    else {
        my $sth = $db->prepare("select * from manufacturer");
        $sth->execute();
        while (my $row = $sth->fetchrow_hashref) {
            push @$res, $row;
        }
        return $res;
    }
}

sub get_man_cust {
    my $self = shift;
    my $id   = shift;
    my $part = " and m.managerid = '$id'" if ($id);
    my $db   = $self->connect_db();
    my $res  = [];

    #report finish
    my $sql =
      "select m.manager_name,m.managerid,c.customer_name from customer as c , manager as m where c.managerid = m.managerid ";
    $sql .= $part if ($id);

    my $sth = $db->prepare($sql);
    $sth->execute();
    while (my $row = $sth->fetchrow_hashref) {
        push @$res, $row;
    }
    return $res;
}

sub get_maf_ast {
    my $self = shift;
    my $id   = shift;
    my $part = " where manufacturer_id = '$id' or manufacturer= '$id'" if ($id);
    my $db   = $self->connect_db();
    my $res  = [];

    #report finish
    my $sql = "select asset from manufacturer ";
    $sql .= $part if ($id);
    my $sth = $db->prepare($sql);
    $sth->execute();
    while (my $row = $sth->fetchrow_hashref) {
        push @$res, $row;
    }
    return $res;
}

sub get_ast {
    my $self  = shift;
    my $id    = shift;                           #man
    my $id2   = shift;                           #maf
    my $part  = " ma.managerid = '$id'";
    my $part2 = " m.manufacturer_id = '$id2'";
    my $join;
    my $res = [];

    if ($id && $id2) {
        $join = $part . ' and ' . $part2;
    }
    elsif ($id || $id2) {
        $join = $part . ' or ' . $part2;
    }

    my $sql =
'select m.asset from manufacturer as m,customer as c,manager as ma where ma.managerid = c.managerid and c.asset= m.asset and m.replace_date < DATE_ADD(CURDATE(), INTERVAL 6 MONTH)';

    my $db = $self->connect_db();
    $sql .= "  and $join";

    my $sth = $db->prepare($sql);
    $sth->execute();

    while (my $row = $sth->fetchrow_hashref) {
        push @$res, $row;
    }
    return $res;

}

1;
