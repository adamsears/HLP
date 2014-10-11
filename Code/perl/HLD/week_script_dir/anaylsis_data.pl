#!/usr/bin/perl

use DBI;
my $dsn = "DBI:mysql:database=eht_hlp;host=localhost";
my $user = 'root';
my $password = '';

my $dbh = DBI->connect($dsn,$user,$password);       #连接数据库

##map reduce analysis   !!!table 1
#mr_total
print "==================================mr_total start!=================================\n";
my $rv = $dbh->do("insert into mr_total values ( (select count(*) from l_union_unique where tasktype = 'MAP' and taskstatus = 'SUCCEEDED' and pmemused <1),( select count(*) from l_union_unique where tasktype = 'MAP' and taskstatus = 'SUCCEEDED' and pmemused >= 1 and pmemused <1.5),(select count(*) from l_union_unique where tasktype = 'MAP' and taskstatus = 'SUCCEEDED' and pmemused >= 1.5 and pmemused <2),(select count(*) from l_union_unique where tasktype = 'MAP' and taskstatus = 'SUCCEEDED' and pmemused >= 2))");
print "TABLE mr_total value 1 inserted! $rv \n";
my $rv = $dbh->do("insert into mr_total values ( (select count(*) from l_union_unique where tasktype = 'MAP' and taskstatus <> 'SUCCEEDED' and pmemused <1),( select count(*) from l_union_unique where tasktype = 'MAP' and taskstatus <> 'SUCCEEDED' and pmemused >= 1 and pmemused <1.5),(select count(*) from l_union_unique where tasktype = 'MAP' and taskstatus <> 'SUCCEEDED' and pmemused >= 1.5 and pmemused <2),(select count(*) from l_union_unique where tasktype = 'MAP' and taskstatus <> 'SUCCEEDED' and pmemused >= 2))");
print "TABLE mr_total value 2 inserted! $rv \n";
my $rv = $dbh->do("insert into mr_total values ( (select count(*) from l_union_unique where tasktype = 'REDUCE' and taskstatus = 'SUCCEEDED' and pmemused <2),( select count(*) from l_union_unique where tasktype = 'REDUCE' and taskstatus = 'SUCCEEDED' and pmemused >= 2 and pmemused <3),(select count(*) from l_union_unique where tasktype = 'REDUCE' and taskstatus = 'SUCCEEDED' and pmemused >= 3 and pmemused <4),(select count(*) from l_union_unique where tasktype = 'REDUCE' and taskstatus = 'SUCCEEDED' and pmemused >= 4))");
print "TABLE mr_total value 3 inserted! $rv \n";
my $rv = $dbh->do("insert into mr_total values ( (select count(*) from l_union_unique where tasktype = 'REDUCE' and taskstatus <> 'SUCCEEDED' and pmemused <2),( select count(*) from l_union_unique where tasktype = 'REDUCE' and taskstatus <> 'SUCCEEDED' and pmemused >= 2 and pmemused <3),(select count(*) from l_union_unique where tasktype = 'REDUCE' and taskstatus <> 'SUCCEEDED' and pmemused >= 3 and pmemused <4),(select count(*) from l_union_unique where tasktype = 'REDUCE' and taskstatus <> 'SUCCEEDED' and pmemused >= 4))");
print "==================================TABLE mr_total value 4 inserted! $rv ==================================\n";


#queues map reduce analysis  !!! table 1*10 = 10
my @queues = ("asr_dictt","asr_embed","asr_embedrecog","asr_trans","call_edu","call_music","eht","hw_tts","nlp","sre");

foreach my $queue(@queues){
	print "==================================TABLE mr_ $queue start\n";
	my $mr_appendix = "mr_".$queue;
	my $rv = $dbh->do("insert into $mr_appendix values ( (select count(*) from v_unique_queue where tasktype = 'MAP' and taskstatus = 'SUCCEEDED' and pmemused <1 and queue = '$queue'),( select count(*) from v_unique_queue where tasktype = 'MAP' and taskstatus = 'SUCCEEDED' and pmemused >= 1 and pmemused <1.5  and queue = '$queue'),(select count(*) from v_unique_queue where tasktype = 'MAP' and taskstatus = 'SUCCEEDED' and pmemused >= 1.5 and pmemused <2  and queue = '$queue'),(select count(*) from v_unique_queue where tasktype = 'MAP' and taskstatus = 'SUCCEEDED' and pmemused >= 2 and queue = '$queue'))");
	print "TABLE $mr_appendix value 1 inserted! $rv \n";
	my $rv = $dbh->do("insert into $mr_appendix values ( (select count(*) from v_unique_queue where tasktype = 'MAP' and taskstatus <> 'SUCCEEDED' and pmemused <1 and queue = '$queue'),( select count(*) from v_unique_queue where tasktype = 'MAP' and taskstatus <> 'SUCCEEDED' and pmemused >= 1 and pmemused <1.5  and queue = '$queue'),(select count(*) from v_unique_queue where tasktype = 'MAP' and taskstatus <> 'SUCCEEDED' and pmemused >= 1.5 and pmemused <2  and queue = '$queue'),(select count(*) from v_unique_queue where tasktype = 'MAP' and taskstatus <> 'SUCCEEDED' and pmemused >= 2 and queue = '$queue'))");
	print "TABLE $mr_appendix value 2 inserted! $rv \n";
	my $rv = $dbh->do("insert into $mr_appendix values ( (select count(*) from v_unique_queue where tasktype = 'REDUCE' and taskstatus = 'SUCCEEDED' and pmemused <2 and queue = '$queue'),( select count(*) from v_unique_queue where tasktype = 'REDUCE' and taskstatus = 'SUCCEEDED' and pmemused >= 2 and pmemused <3  and queue = '$queue'),(select count(*) from v_unique_queue where tasktype = 'REDUCE' and taskstatus = 'SUCCEEDED' and pmemused >= 3 and pmemused <4  and queue = '$queue'),(select count(*) from v_unique_queue where tasktype = 'REDUCE' and taskstatus = 'SUCCEEDED' and pmemused >= 4 and queue = '$queue'))");
	print "TABLE $mr_appendix value 3 inserted! $rv \n";
	my $rv = $dbh->do("insert into $mr_appendix values ( (select count(*) from v_unique_queue where tasktype = 'REDUCE' and taskstatus <> 'SUCCEEDED' and pmemused <2 and queue = '$queue'),( select count(*) from v_unique_queue where tasktype = 'REDUCE' and taskstatus <> 'SUCCEEDED' and pmemused >= 2 and pmemused <3  and queue = '$queue'),(select count(*) from v_unique_queue where tasktype = 'REDUCE' and taskstatus <> 'SUCCEEDED' and pmemused >= 3 and pmemused <4  and queue = '$queue'),(select count(*) from v_unique_queue where tasktype = 'REDUCE' and taskstatus <> 'SUCCEEDED' and pmemused >= 4 and queue = '$queue'))");
	print "TABLE $mr_appendix value 4 inserted! $rv \n";
	print "==================================TABLE $mr_appendix done!==================================\n";
}


##user task toptotal and user wait_time  !!! table 3
print "==================================top info user task toptotal and user wait_time==================================\n";
#time top
my $rv = $dbh->do("INSERT into user_time_toptotal SELECT user,count(*) as total_tasks,round(SUM(attemptfinishtime-attemptstarttime)/3600000,2) as total_time FROM l_union_queue GROUP BY user order by total_time desc");
print "user_time_toptotal inserted! $rv \n";
#task_top
my $rv = $dbh->do("INSERT into user_task_toptotal SELECT user,count(*) as total_tasks,round(SUM(attemptfinishtime-attemptstarttime)/3600000,2) as total_time FROM l_union_queue GROUP BY user order by total_tasks desc");
print "user_task_toptotal inserted! $rv \n";
#user wait time
my $rv = $dbh->do("INSERT INTO user_wait_time select user,round(SUM(launchtime-submittime)/count(*)/1000,2) as avg_wait_time from b_job_info GROUP BY user");
print "user_wait_time(seconds) inserted! $rv \n";
print "==================================top info done!==================================\n";


##wrong set user    !!!tables 3
#map wrong set
#print "==================================wrong set started!==================================\n";
#my $rv = $dbh->do("insert into wrong_set_map select user,sum(nummaps) as tasknum from (SELECT appid,max(pmemused) as pmemused,pmemset from l_union_unique where tasktype = 'MAP' and pmemset <> 1.5 GROUP BY appid) as ta,b_job_info where b_job_info.appid = ta.appid and ta.pmemused < ta.pmemset/2 GROUP BY b_job_info.`user` ORDER BY tasknum desc");
#print "wrong_set_map inserted! $rv \n";
#reduce wrong set
#my $rv = $dbh->do("insert into wrong_set_reduce select user,sum(numreduces) as tasknum from (SELECT appid,max(pmemused) as pmemused,pmemset from l_union_unique where tasktype = 'REDUCE' and pmemset <> 3 GROUP BY appid) as ta,b_job_info where b_job_info.appid = ta.appid and ta.pmemused < ta.pmemset/2 GROUP BY b_job_info.`user` ORDER BY tasknum desc");
#print "wrong_set_reduce inserted! $rv \n";
#job wrong set
#my $rv = $dbh->do("insert into wrong_set_job SELECT user,count(*) as jobnum,round(sum(finishtime-launchtime)/3600000,2) as jobtime FROM b_job_info,(SELECT appid FROM (SELECT appid,max(pmemused) as maxmem,pmemset from l_union_unique where (pmemset <> 2 and tasktype = 'MAP')or (pmemset <> 3 and tasktype = 'REDUCE') GROUP BY appid)as ta WHERE ta.maxmem < ta.pmemset/2) as ta where ta.appid = b_job_info.appid GROUP BY user ORDER BY jobtime desc");
#print "wrong_set_job_time inserted! $rv \n";
#print "==================================wrong set completed!==================================\n";


##map reduce job calculate
print "==================================time ratio calculate==================================\n";
#map type
my $rv = $dbh->do("insert into time_ratio values ((SELECT count(*) FROM l_union_unique where tasktype ='MAP' and (attemptfinishtime-attemptstarttime)/60000 <1),(SELECT count(*) FROM l_union_unique where tasktype ='MAP' and (attemptfinishtime-attemptstarttime)/60000 >=1 and (attemptfinishtime-attemptstarttime)/60000 <5),(SELECT count(*) FROM l_union_unique where tasktype ='MAP' and (attemptfinishtime-attemptstarttime)/60000 >=5 and (attemptfinishtime-attemptstarttime)/60000 <10),(SELECT count(*) FROM l_union_unique where tasktype ='MAP' and (attemptfinishtime-attemptstarttime)/60000 >=10 and (attemptfinishtime-attemptstarttime)/60000 <30),(SELECT count(*) FROM l_union_unique where tasktype ='MAP' and (attemptfinishtime-attemptstarttime)/60000 >=30 and (attemptfinishtime-attemptstarttime)/60000 <60),(SELECT count(*) FROM l_union_unique where tasktype ='MAP' and (attemptfinishtime-attemptstarttime)/60000 >=60))");
print "time_ratio insert MAP type data!\n";
#reduce type
my $rv = $dbh->do("insert into time_ratio values ((SELECT count(*) FROM l_union_unique where tasktype ='REDUCE' and (attemptfinishtime-attemptstarttime)/60000 <1),(SELECT count(*) FROM l_union_unique where tasktype ='REDUCE' and (attemptfinishtime-attemptstarttime)/60000 >=1 and (attemptfinishtime-attemptstarttime)/60000 <5),(SELECT count(*) FROM l_union_unique where tasktype ='REDUCE' and (attemptfinishtime-attemptstarttime)/60000 >=5 and (attemptfinishtime-attemptstarttime)/60000 <10),(SELECT count(*) FROM l_union_unique where tasktype ='REDUCE' and (attemptfinishtime-attemptstarttime)/60000 >=10 and (attemptfinishtime-attemptstarttime)/60000 <30),(SELECT count(*) FROM l_union_unique where tasktype ='REDUCE' and (attemptfinishtime-attemptstarttime)/60000 >=30 and (attemptfinishtime-attemptstarttime)/60000 <60),(SELECT count(*) FROM l_union_unique where tasktype ='REDUCE' and (attemptfinishtime-attemptstarttime)/60000 >=60))");
print "time_ratio insert REDUCE type data!\n";
#job
my $rv = $dbh->do("insert into time_ratio values ((SELECT count(*) from b_job_info where (finishtime-launchtime) /3600000 <0.5),(SELECT count(*) from b_job_info where (finishtime-launchtime) /3600000 >=0.5 and (finishtime-launchtime) /3600000 <1),(SELECT count(*) from b_job_info where (finishtime-launchtime) /3600000 >=1 and (finishtime-launchtime) /3600000 <2),(SELECT count(*) from b_job_info where (finishtime-launchtime) /3600000 >=2 and (finishtime-launchtime) /3600000 <4),(SELECT count(*) from b_job_info where (finishtime-launchtime) /3600000 >=4 and (finishtime-launchtime) /3600000 <8),(SELECT count(*) from b_job_info where (finishtime-launchtime) /3600000 >=8))");
print "time_ratio insert job data!\n";
print "-------------------------------time ratio calculate done!\n";


##map reduce set count map,reduce
#map type				!!!please add two table
my @map_setm;
my ($sth,@ary);
$sth = $dbh->prepare("SELECT DISTINCT pmemset FROM l_union_unique where tasktype = 'MAP' ORDER BY pmemset");
$sth->execute();
while(@ary = $sth->fetchrow_array()){
	push @map_setm,$ary[0];
}
$sth->finish;
foreach my $mem(@map_setm){
	my $rv = $dbh->do("INSERT INTO map_set_analysis values($mem,(SELECT count(*) FROM l_union_unique where pmemset = $mem and pmemused <1 and tasktype = 'MAP'),(SELECT count(*) FROM l_union_unique where pmemset = $mem and pmemused >=1 and pmemused <1.5 and tasktype = 'MAP'),(SELECT count(*) FROM l_union_unique where pmemset = $mem and pmemused >=1.5 and pmemused <2 and tasktype = 'MAP'),(SELECT count(*) FROM l_union_unique where pmemset = $mem and pmemused >2 and tasktype = 'MAP'))");
	print "---------map mem set $mem : insert total num into map_set_analysis ---->>>>$rv\n";
}
foreach my $mem(@map_setm){
	my $rv = $dbh->do("INSERT INTO map_set_failed_analysis values($mem,(SELECT count(*) FROM l_union_unique where pmemset = $mem and pmemused <1 and tasktype = 'MAP' and taskstatus <> 'SUCCEEDED'),(SELECT count(*) FROM l_union_unique where pmemset = $mem and pmemused >=1 and pmemused <1.5 and tasktype = 'MAP' and taskstatus <> 'SUCCEEDED'),(SELECT count(*) FROM l_union_unique where pmemset = $mem and pmemused >=1.5 and pmemused <2 and tasktype = 'MAP' and taskstatus <> 'SUCCEEDED'),(SELECT count(*) FROM l_union_unique where pmemset = $mem and pmemused >2 and tasktype = 'MAP' and taskstatus <> 'SUCCEEDED'))");
	print "---------map mem set $mem : insert failed num into map_set_failed_analysis ---->>>>$rv\n";
}

#reduce type            !!!please add two table
my @reduce_setm;
my ($sth,@ary);
$sth = $dbh->prepare("SELECT DISTINCT pmemset FROM l_union_unique where tasktype = 'REDUCE' ORDER BY pmemset");
$sth->execute();
while(@ary = $sth->fetchrow_array()){
	push @reduce_setm,$ary[0];
}
$sth->finish;
foreach my $mem(@reduce_setm){
	my $rv = $dbh->do("INSERT INTO reduce_set_analysis values($mem,(SELECT count(*) FROM l_union_unique where pmemset = $mem and pmemused <2 and tasktype = 'REDUCE'),(SELECT count(*) FROM l_union_unique where pmemset = $mem and pmemused >=2 and pmemused <3 and tasktype = 'REDUCE'),(SELECT count(*) FROM l_union_unique where pmemset = $mem and pmemused >=3 and pmemused <4 and tasktype = 'REDUCE'),(SELECT count(*) FROM l_union_unique where pmemset = $mem and pmemused >4 and tasktype = 'REDUCE'))");
	print "----------reduce mem set $mem : insert total num into reduce_set_analysis ---->>>>$rv\n";
}
foreach my $mem(@reduce_setm){
	my $rv = $dbh->do("INSERT INTO reduce_set_failed_analysis values($mem,(SELECT count(*) FROM l_union_unique where pmemset = $mem and pmemused <2 and tasktype = 'REDUCE' and taskstatus <> 'SUCCEEDED'),(SELECT count(*) FROM l_union_unique where pmemset = $mem and pmemused >=2 and pmemused <3 and tasktype = 'REDUCE' and taskstatus <> 'SUCCEEDED'),(SELECT count(*) FROM l_union_unique where pmemset = $mem and pmemused >=3 and pmemused <4 and tasktype = 'REDUCE' and taskstatus <> 'SUCCEEDED'),(SELECT count(*) FROM l_union_unique where pmemset = $mem and pmemused >4 and tasktype = 'REDUCE' and taskstatus <> 'SUCCEEDED'))");
	print "-----------reduce mem set $mem : insert failed num into reduce_set_failed_analysis ---->>>>$rv\n";
}

##main_jymr job yarn map reduce ---->>>/total /failed /failed by memory
#please create a table name main_jymr   /case need to output a table we set column unnormal job yarn map reduce !!!
#insert job values
print "--------------------------do insert into main_jymr \n";
my $rv = $dbh->do("insert into main_jymr values ((SELECT count(*) FROM b_job_info),(SELECT count(*) FROM b_job_info where stauts <> 'SUCCEEDED'),(SELECT count(*) FROM b_job_info,(SELECT appid FROM l_union_unique WHERE pmemused >= pmemset GROUP BY appid)as ta where ta.appid = b_job_info.appid and b_job_info.stauts <> 'SUCCEEDED'))");
print "job values insert into main_jymr $rv\n";
#insert yarn values
my $rv = $dbh->do("insert into main_jymr values (0,0,0)");
print "yarn values insert into main_jymr $rv\n";
#insert map values
my $rv = $dbh->do("insert into main_jymr values ((SELECT count(*) FROM l_union_unique where tasktype = 'MAP'),(SELECT count(*) FROM l_union_unique where tasktype = 'MAP' and taskstatus <> 'SUCCEEDED'),(SELECT count(*) FROM l_union_unique where tasktype = 'MAP' and taskstatus <> 'SUCCEEDED' and pmemused >= pmemset))");
print "map values insert into main_jymr $rv\n";
#insert reduce values
my $rv = $dbh->do("insert into main_jymr values ((SELECT count(*) FROM l_union_unique where tasktype = 'REDUCE'),(SELECT count(*) FROM l_union_unique where tasktype = 'REDUCE' and taskstatus <> 'SUCCEEDED'),(SELECT count(*) FROM l_union_unique where tasktype = 'REDUCE' and taskstatus <> 'SUCCEEDED' and pmemused >= pmemset))");
print "reduce values insert into main_jymr $rv\n";
print "---------------------------done insert into main_jymr \n";

##queue usage and user usage
#queue usage
#get sample mem total





$dbh->disconnect;
