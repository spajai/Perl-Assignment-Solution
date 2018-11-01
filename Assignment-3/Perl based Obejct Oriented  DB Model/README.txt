################################################################################
oDesk Perl Test

Welcome! This is the oDesk Perl Test!

It is designed to replicate a very small project. The test is designed to test
your proficiency in the following areas:

	- basic unix systems administration
	- perl environment setup
	- relational database schema and usage
	- perl language profiency
	- basic computer science algorithms and concepts
	- test driven development
	- english reading and comprehension

This test is an "open book" test. You can use any reference materials (books, man
pages, google, etc) you would like.  You cannot use someone elses answer. That
would be considered cheating. You are free to use any open source (eg CPAN)
libraries.

WHAT YOU WILL NEED:

	- unix operating system (linux, freebsd, mac os x, etc)
	- perl (this test was created using version 5.16)
	- various CPAN libraries
	- sqlite3
	- git
	- macports (mac os x specific)

Chances are, if you are a perl developer, you probably have all of these things
already.

################################################################################

INITIALIZE GIT

Untar the tarball (which you probably already did) into a directory. Navigate to
the root directory of the tarball and initialize a git repository like so:

	git init

Now you are ready to use git to track your changes. 

################################################################################

CHANGE TRACKING

We would like you to treat this as a real work project. That means committing
changes to git at intervals you would normally use in a corporate team
development environment. We will be looking through your commits to see how you
arrived at the solution. Although it's probably possible that someone would
arrive at the solution on their first attempt, it's not very likely. So with
that in mind, a single commit at the end is not very helpful. 

################################################################################

DESIGN AND ARCHITECTURE

You are free to come up with whatever design or architecture you like.
If you do use any design patterns, please make a comment about it in the code.
The only constraint is that the unit tests must remain. You can add unit tests
if you want. But you cannot remove any.

################################################################################

CODE DOCUMENTATION

Please add documentation to your code as you would in a corporate team
environment.  More documentation is usually better.

################################################################################

CODE STYLE

Although playing perl golf is very fun, we are looking for easily readable (and 
therefore maintainable) code. Feel free to code in whatever style you like. But
keep in mind that we will be looking for code that is well structured,
organized, consistent in style and easy to read and understand.

################################################################################

PERFORMANCE and OPTIMIZATION

When writing computionally intensive code, try to write efficient code.

################################################################################

DATABASE

For the purposes of this test, we have selected SQLite3 for it's portability and
ease of setup. We have also provided a database as well. The database file is
located in db/odesk.db. During the course of this project, you are free to
modify the schema.

The database already has some tables and records for your convienience. Making a
backup of the database would be a good idea.

################################################################################

OVERVIEW

Everyone who has worked on a complex perl software application has most likely
had to work with code that manages reading, writing and modifying data from a
relational database.

The test project involves creating a set of classes to work with modelling 
contractors, countries and skills. These are fairly basic in nature (as you will
see in the unit tests).  Basically, over the course of the 5 excercises, you 
will be building up to creating models for all three things (contractors,
countries, and skills).  

This test could take anywhere from 2 hours to 10 hours. This will depend on your
skill level and familiarity with the various components.

If you have any questions about anything related to this test, please contact
the person who emailed you the test.

################################################################################

THINGS TO KEEP IN MIND

The state of the database can become corrupted if one of your tests fails. You
should keep track of what commands are sent to the database and what the state
should be. This means, you might have to manually reset the state of the
database during the course of these excercises.

################################################################################

EXCERCISE 1

Design and write the class oDesk::DB. This class should implement the singleton
design pattern and should pass all the tests in t/02-oDesk-DB.t. 

Use oDesk::Config class from within oDesk::DB to get the path of the SQLite3
database file (db/odesk.db) like so:

  my $config = oDesk::Config->new;
  $db_path = $config->db_path;

You will also need to use DBI and DBD::SQLite to connect to the database as
well.

################################################################################

EXCERCISE 2

Design, write and unit test a model class for 'country'. The class name should
be oDesk::Model::Country. The unit test is already provided for you. It is
located here: 

  t/03-oDesk-Model-Country.t

################################################################################

EXCERCISE 3

Design, write and unit test a model class for 'skill'. The class name should be
oDesk::Model::Skill. The unit test is already provided for you. It is located
here: 

  t/04-oDesk-Model-Skill.t

################################################################################

EXCERCISE 4

Alter the database schema and add table(s) to store contractor information. Also
keep in mind that:
	1. Contractors live in one country.
	2. Contractors can have any where from zero to multliple skills.

Please record any database schema changes you make by putting them in
db/schema.sql.

################################################################################

EXCERCISE 5

Design, write and unit test a model class for 'contractor'. The class name
should be oDesk::Model::Contractor. The unit test is already provided for you.
It is located here:

  t/05-oDesk-Model-Contractor.t

################################################################################

EXCERCISE 6

Design, write and unit test a class to retrieve and parse the following URL for
a complete list of programming languages:

http://en.wikipedia.org/wiki/List_of_programming_languages

Name the class oDesk::Parser::ProgrammingLanguages::Wikipedia.

The unit test is located at:

  t/06-oDesk-Parser-ProgrammingLanguages-Wikipedia

################################################################################

BONUS POINTS

Write a method that finds all the programming language names
that are anagrams (case-insensitive) of another programming language name. This 
method should be named 'get_anagrams'.

Alter the unit test, t/06-oDesk-Parser-ProgrammingLanguages-Wikipedia, to mock
out the actual retrieval of the URL.

