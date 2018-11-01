Assignment to insert json data files to DB and retieve.


#### uses Mysql & Perl

#### Install following cpan modules.

Try::Tiny 
DBI
DBD::mysql

(Command :- sudo cpan install Try::Tiny DBI DBD::mysql)

#### Question 

August 2017


Instructions

Read the document: Instructions.txt before starting the questions.


Q1.  The top-level script for reading VirusTotal.com JSON files is vt_read.pl in
     the scripts directory. It is a skeleton script, missing a single line. The
     line missing is a call to the read_json_file() function in the VT module.

     Modify the script to insert the correct call to the read_json_file()
     function in VT. Be sure to pass the correct argument. Try to run the 
     script from the command line:

        perl scripts/vt_read.pl

     Provide a JSON file from the reports directory (for instance, provide the
     file: reports/97ee759084b139101bb13bb1d2ab90c0). With the correct
     arguments, the script should print out the results returned by the VT
     module. This may be redirected on the command line to a new file in the
     logs directory.


Q2.  Create a new function named: read_json() in the VT module. It should accept
     a single argument, which is either a file or a directory.

     If the argument provided is a file, read_json() should call
     read_json_file() and return the result.

     If the argument provided is a directory, read_json() should find all the
     files in the directory and, for each one, call read_json_file(). Return the
     results from read_json_file() together. Process any nested subdirectories,
     returning the results of read_json_file() for any file they may contain.


Q3.  Modify the script: vt_read.pl to accept on the command line:

        - one or more JSON files
        - one or more directories containing any number of JSON files
        - any combination of both (files or directories)

     For each file or directory provided as input, the script should call the
     new read_json() function in the VT module.

     The result of the VT module should be printed for each file processed.


Q4.  When processing several JSON files from the command line or from a
     directory, some could be malformed. For example, the file or directory
     provided:

        - may be empty
	- may not be (or may not contain) a valid JSON file
        - may not exist

     Modify the script vt_read.pl in Q3 above, or the read_json_file() or
     read_json() functions in the VT module, to ensure that any such scenarios
     could be handled properly. The script (or module) should print out an error
     message, but continue to process any remaining files or directories.


Q5.  The output of the script: vt_read.pl includes various fields from the
     original VirusTotal.com JSON file. It is intended to extract and save these
     fields and their corresponding value into a database.

     Define a relational database schema to match the data structure. You may
     review either the original JSON file, the Perl object printed by vt_read.pl
     or both. The result page displayed by VirusTotal.com (by searching for an
     MD5 sum, or by following "permalink" in a JSON file) may also be of help.

     Write the SQL commands that could be used to make the new database
     table(s). The database schema may have several different tables linked
     together with appropriate reference key(s).

     Consider the MD5 sum in each JSON file to be unique. Similarly, the SHA1 or
     SHA256 will usually be unique. If there are any cases where two JSON files
     have the same MD5 sum, these should be treated as undesired duplicates for
     now.


Q6.  Write a new function in the VT module named save2db() that:

        - accepts the output of read_json(), and the connection information to a
	  database
        - connects to the database specified
        - makes new database table(s) as above
        - saves the output received from read_json() into the database

     The function: save2db() should make new table(s) only once, not every time
     it gets called (since the table structures will be the same).

     New private functions may be added into VT and called as required.

     You may use any relational database server: MySQL, PostgreSQL, SQLite, etc.

     The Perl DBI module may be useful for this purpose.


Q7.  Write a simple script called vt_read2db.pl similar to vt_read.pl. It should
     accept any number of VirusTotal.com JSON files or directories of such
     files. For each given JSON file, it should call from the VT module, the new
     read_json(), and the new save2db() function created in Q6, to save all the 
     entries into a database.

     You may provide the database connection information as an input to the new
     script: vt_read2db.pl, or as variables inside the script.
