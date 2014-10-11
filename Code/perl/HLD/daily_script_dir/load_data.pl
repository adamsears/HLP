#!/usr/bin/perl
use strict;


use DBI;
my $dsn = "DBI:mysql:database=eht_hlp;host=localhost";
my $user = 'root';
my $password = '';

my $dbh = DBI->connect($dsn,$user,$password);       #连接数据库

my $rv = $dbh->do("LOAD DATA LOCAL INFILE '/home/hadoop/log-database/dataclean/mysql_loadfile/ctnmem_20140901' INTO TABLE b_ctn_mem");
print "b_ctn_mem LOADED! $rv \n";

my $rv = $dbh->do("LOAD DATA LOCAL INFILE '/home/hadoop/log-database/dataclean/mysql_loadfile/taskctn_20140901' INTO TABLE b_task_ctn");
print "b_task_ctn LOADED! $rv \n";

my $rv = $dbh->do("LOAD DATA LOCAL INFILE '/home/hadoop/log-database/dataclean/mysql_loadfile/jobinfo_20140901' INTO TABLE b_job_info");
print "b_job_info LOADED! $rv \n";

$dbh->disconnect;                                #断开
