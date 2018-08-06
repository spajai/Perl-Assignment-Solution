Assignment to performe ELT on csv data and storing the data in structured DB.


##### uses Mysql & Perl


##### Edit db credential before use replace with your DB credential
https://github.com/spajai/Perl-Assignment-Solution/blob/master/Assignment-1/Perl%20based%20ELT%20and%20Shop%20management/DB.pm#L19

##### Run the given sql file before procceeding 

https://github.com/spajai/Perl-Assignment-Solution/blob/master/Assignment-1/Perl%20based%20ELT%20and%20Shop%20management/shop.sql


##### install following cpan module

(Command :- sudo cpan install DBI DBD::mysql)

####script uses /Run 

#### Run elt scrip first :-
Replace the path with your csv path 
```
perl etl.pl --file = 'data-load.csv'
```

#### Run retrive.pl next
```
retrive.pl  [--sc1 | --sc2 | --sc3 ] {--man 'MANAGER ID XXX' | --maf 'MANAFACTURER ID XXX'} 

eg for assignment scenario 1 :-  retrive.pl --sc1 
              or 
           etrive.pl --sc1  --man 'MAN ID XXXX'
           
eg. for assignment scenario 2 :- retrive.pl --sc2
            retrive.pl --sc2 --maf 'MAF XXXXX'

eg. for assignment scenario 3 :- retrive.pl --sc3 
               or 
               retrive.pl --sc3  --man 'MAN ID XXX'  --maf 'MAF ID XXXX'
```
