/*
* A table to hold records for countries.
* This table is already populated
*/

create table country (
	id integer PRIMARY KEY,
	name varchar not null unique
);

/*
* A table to hold records for skills.
* This table is already populated
*/

create table skill (
	id integer PRIMARY KEY,
	name varchar not null unique
);

/*
* A table to hold records for contractor.
*/

create table contractor(
   id integer primary key autoincrement,
   first_name      text  not null,
   last_name       text  not null,
   country_id     integer not null,
   hourly_rate     varchar(20),
   FOREIGN KEY(country_id) REFERENCES country(id)
);

/*
* A table to hold records for contractor_skill.
* With foreign keys
*/

create table contractor_skill(
   id integer primary key autoincrement,
   skill_id      integer  not null,
   contractor_id integer   not null,
   FOREIGN KEY(skill_id) REFERENCES skill(id),
   FOREIGN KEY(contractor_id) REFERENCES contractor(id)
);
