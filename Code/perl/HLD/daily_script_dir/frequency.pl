#!/usr/bin/perl


#1409155200 2014-08-28
use DBI;
my $dsn = "DBI:mysql:database=eht_hlp;host=localhost";
my $user = 'root';
my $password = '';

my $dbh = DBI->connect($dsn,$user,$password);       #连接数据库
#1408896000 2014-08-25 00:00
my $time_start = 1408896000;
my $time_end = 1408896000+604800;
#each 30 min do frenquency
for(my $time_stamp = $time_start;$time_stamp < $time_end;$time_stamp += 1800){
	
	my $compare_time = $time_stamp*1000;
	
	
	my ($sth,@ary);
	$sth = $dbh->prepare("select user,queue,jobname,pmemused,pmemset,attemptstarttime,attemptfinishtime from l_union_queue");
	$sth->execute();
	
	while(@ary = $sth->fetchrow_array()){
				
		if($compare_time > $ary[5] && $compare_time < $ary[6]){
			my $rv = $dbh->do("insert into task_sample_1min values ($time_stamp,'$ary[0]','$ary[1]','$ary[2]',$ary[3],$ary[4],$ary[5],$ary[6])");
		}
	}                                                #insert data
	$sth->finish;                                    #结束句柄
}

$dbh->disconnect;                                #断开
