#!/usr/bin/perl
#use strict;

use DBI;
my $dsn = "DBI:mysql:database=eht_hlp;host=localhost";
my $user = 'root';
my $password = '';

my $dbh = DBI->connect($dsn,$user,$password);       #连接数据库


##basic table create
my $rv = $dbh->do("CREATE TABLE b_ctn_mem  (ctn_id varchar(40) NOT NULL PRIMARY KEY ,pmemused float ,pmemset float,vmemused float,vmemset float ,date DATE ,time TIME,appid varchar(20))");
print "b_ctn_mem created! $rv \n";

my $rv = $dbh->do("create table b_job_info(job_id varchar(40) NOT NULL PRIMARY KEY,submittime bigint,launchtime bigint,firstmaplaunchtime bigint,firstreducelaunchtime bigint,finishtime bigint,resourcespermap int,resourcesperreduce int,nummaps int,numreduces int,user varchar(255),queue varchar(50),stauts varchar(20),mapslotseconds int,reduceslotseconds int,jobname varchar(255),appid varchar(20))");
print "b_job_info created! $rv \n";

my $rv = $dbh->do("create table b_task_ctn(task_id varchar(40),attempt_id varchar(40),ctn_id varchar(40) NOT NULL PRIMARY KEY,tasktype varchar(6),hostname varchar(40),taskstatus varchar(20),attemptstarttime bigint,attemptfinishtime bigint,appid varchar(20))");
print "b_task_ctn created! $rv \n";

my $rv = $dbh->do("create table b_task_error (task_id varchar(40),attempt_id varchar(40) NOT NULL PRIMARY KEY ,tasktype varchar(6) ,hostname varchar(40),taskstatus varchar(20),error_info text ,appid varchar(20) )");
print "b_task_error created! $rv \n";


##logical table create include one view

my $rv = $dbh->do("CREATE TABLE `l_union_tc` ( `task_id`  varchar(40) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL , `attempt_id`  varchar(40) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL , `ctn_id`  varchar(40) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL , `tasktype`  varchar(6) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL , `hostname`  varchar(40) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL , `taskstatus`  varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL , `attemptstarttime`  bigint(20) NULL DEFAULT NULL , `attemptfinishtime`  bigint(20) NULL DEFAULT NULL , `pmemused`  float NULL DEFAULT NULL , `pmemset`  float NULL DEFAULT NULL , `vmemused`  float NULL DEFAULT NULL , `vmemset`  float NULL DEFAULT NULL , `date`  date NULL DEFAULT NULL , `time`  time NULL DEFAULT NULL , `appid`  varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL , PRIMARY KEY (`ctn_id`), INDEX `union_tcm` (`task_id`, `pmemused`) USING HASH )");
print "l_union_tc created! $rv \n";

my $rv = $dbh->do("CREATE TABLE `l_union_unique` ( `task_id`  varchar(40) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL , `attempt_id`  varchar(40) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL , `ctn_id`  varchar(40) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL , `tasktype`  varchar(6) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL , `hostname`  varchar(40) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL , `taskstatus`  varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL , `attemptstarttime`  bigint(20) NULL DEFAULT NULL , `attemptfinishtime`  bigint(20) NULL DEFAULT NULL , `pmemused`  float NULL DEFAULT NULL , `pmemset`  float NULL DEFAULT NULL , `vmemused`  float NULL DEFAULT NULL , `vmemset`  float NULL DEFAULT NULL , `date`  date NULL DEFAULT NULL , `time`  time NULL DEFAULT NULL , `appid`  varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL , PRIMARY KEY (`ctn_id`),INDEX `union_appid` (`appid`) USING HASH)");
print "l_union_unique created! $rv \n";

my $rv = $dbh->do("CREATE TABLE `l_union_queue` (`appid`  varchar(255),`task_id`  varchar(40),`attempt_id`  varchar(40),`ctn_id`  varchar(40),`tasktype`  varchar(6),`hostname`  varchar(40),`taskstatus`  varchar(20),`attemptstarttime`  bigint(20) NULL DEFAULT NULL ,`attemptfinishtime`  bigint(20) NULL DEFAULT NULL ,`pmemused`  float NULL DEFAULT NULL ,`pmemset`  float NULL DEFAULT NULL ,`vmemused`  float NULL DEFAULT NULL ,`vmemset`  float NULL DEFAULT NULL ,`date`  date NULL DEFAULT NULL ,`time`  time NULL DEFAULT NULL ,`user`  varchar(255),`jobname`  varchar(255),`queue`  varchar(50),`stauts`  varchar(20),PRIMARY KEY (`ctn_id`))");
print "l_union_queue created! $rv \n";

my $rv = $dbh->do("CREATE TABLE `task_sample_1min` (timestamp bigint(20),user varchar(255),queue varchar(20),jobname varchar(255),pmemused float,pmemset float,attemptstarttime bigint(20),attemptfinishtime bigint(20),INDEX `stamp` (`timestamp`) USING HASH)");
##need print out data table

#create mr_total and each queue mr;
my $rv = $dbh->do("CREATE TABLE mr_total (column1 int,column2 int,column3 int,column4 int)");
print "TABLE mr_total created! $rv \n";

my @queues = ("asr_dictt","asr_embed","asr_embedrecog","asr_trans","call_edu","call_music","eht","hw_tts","nlp","sre");

foreach my $queue(@queues){
	my $mr_appendix = "mr_".$queue;
	my $rv = $dbh->do("CREATE TABLE $mr_appendix LIKE mr_total");
	print "$mr_appendix created! $rv \n";
}


#create user tasks and time used
my $rv = $dbh->do("CREATE TABLE time_ratio (column1 int,column2 int,column3 int,column4 int,column5 int,column6 int)");
print "TABLE time_ratio created! $rv \n";
#user task top #user_time_toptotal
my $rv = $dbh->do("CREATE TABLE user_time_toptotal (user varchar(40),tasks_num int,time_used float)");
print "TABLE user_task_toptotal created! $rv \n";
#user time top
my $rv = $dbh->do("CREATE TABLE user_task_toptotal (user varchar(40),tasks_num int,time_used float)");
print "TABLE user_task_toptotal created! $rv \n";

##create user wait time table
my $rv = $dbh->do("CREATE TABLE user_wait_time (user varchar(40),avg_wait_time float)");
print "TABLE user_wait_time created! $rv \n";


##creat wrong_set
#wrong set map
my $rv = $dbh->do("CREATE TABLE wrong_set_map(user varchar(255),map_num int)");
print "TABLE wrong_set_map created! $rv \n";
#wrong set reduce
my $rv = $dbh->do("CREATE TABLE wrong_set_reduce(user varchar(255),reduce_num int)");
print "wrong_set_reduce created! $rv \n";
#wrong set job 
my $rv = $dbh->do("CREATE TABLE wrong_set_job (user varchar(255),jobnum int,jobtime float)");
print "wrong_set_job created! $rv \n";

#my $rv = $dbh->do("CREATE TABLE main_jymr(job_num int,yarn_num int,map_num int,reduce_num int)");
#print "TABLE main_jymr created! $rv \n";

##MAP REDUCE set 
#MAP SET
my $rv = $dbh->do("CREATE TABLE map_set_analysis(mem float,column1 int,column2 int,column3 int,column4 int)");
print "map_set_analysis created! $rv \n";
#MAP set failed analysis
my $rv = $dbh->do("CREATE TABLE map_set_failed_analysis (mem float,column1 int,column2 int,column3 int,column4 int)");
print " created! $rv \n";

#REDUCE SET
my $rv = $dbh->do("CREATE TABLE reduce_set_analysis(mem float,column1 int,column2 int,column3 int,column4 int)");
print " created! $rv \n";
#REDUCE SET failed analysis
my $rv = $dbh->do("CREATE TABLE reduce_set_failed_analysis(mem float,column1 int,column2 int,column3 int,column4 int)");
print " created! $rv \n";

##create main_jymr
my $rv = $dbh->do("CREATE TABLE main_jymr (total int,failed int,mem_failed int)");
print "TABLE main_jymr created   $rv\n";

my $rv = $dbh->do("CREATE TABLE mem_time_5s (timestamp int,asr_dictt float,asr_embed float,asr_embedrecog float,asr_trans float,call_edu float,call_music float,eht float,hw_tts float,nlp float,sre float,INDEX `index_time` (`timestamp`) USING HASH)");
print "mem_time_5s created! $rv \n";

my $rv = $dbh->do("CREATE TABLE mem_time_1min (timestamp int,asr_dictt float,asr_embed float,asr_embedrecog float,asr_trans float,call_edu float,call_music float,eht float,hw_tts float,nlp float,sre float,INDEX `index_time` (`timestamp`) USING HASH)");
print "mem_time_1min created! $rv \n";



$dbh->disconnect; 
