create database shop;

create table if not exists shop.manager (id int not null auto_increment, manager_name varchar(45) default null, managerid varchar(20), primary key(id)) engine = innodb default charset = utf8 collate = utf8_general_ci;

create table if not exists shop.customer(
    id int not null auto_increment,
    customer_name varchar(45) default null,
    managerid varchar(45) default null,
    asset varchar(45),
    primary key(id)
  ) engine = innodb default charset = utf8 collate = utf8_general_ci;

create table if not exists shop.manufacturer(
    id int not null auto_increment,
    manufacturer_id varchar(45) default null,
    manufacturer varchar(45) default null,
    replace_date date default null,
    manufacture_date date,
    asset varchar(45),
    primary key(id)
  ) engine = innodb default charset = utf8 collate = utf8_general_ci;

create table if not exists shop.log(
    id int not null auto_increment,
    script_name varchar(200) default null,
    start_time timestamp default current_timestamp,
    finish_time timestamp null default null on update current_timestamp,
    params json default null,
    finish varchar(1) default null,
    primary key(id)
  ) engine = innodb default charset = utf8 collate = utf8_general_ci;
