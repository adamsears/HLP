#!/usr/bin/perl

use DBI;
my $dsn = "DBI:mysql:database=eht_hlp;host=localhost";
my $user = 'root';
my $password = '';

my $dbh = DBI->connect($dsn,$user,$password);       #连接数据库

#l_union_queue
#there is bug user <=> jobname

my @appids;

my ($sth,@ary);
$sth = $dbh->prepare("select appid from b_job_info");
$sth->execute();
while(@ary = $sth->fetchrow_array()){
	push @appids,@ary;
}

foreach my $appid(@appids){

	my @lines;
	
	my ($sth,@ary);
	$sth = $dbh->prepare("select user,jobname,count(*),ROUND(sum(attemptfinishtime-attemptstarttime)/3600000,2) as time,max(pmemused) as max,pmemset from l_union_queue where appid ='$appid' and tasktype = 'MAP'");
	$sth->execute();
	while(@ary = $sth->fetchrow_array()){
		push @lines,@ary;
	}
	
	my ($sth,@ary);
	$sth = $dbh->prepare("select count(*),ROUND(sum(attemptfinishtime-attemptstarttime)/3600000,2) as time,max(pmemused) as max,pmemset from l_union_queue where appid ='$appid' and tasktype = 'REDUCE'");
	$sth->execute();
	while(@ary = $sth->fetchrow_array()){
		my @test = @ary;
		if($test[0] eq 0){
			my @ary = (0,0,0,0);
			push @lines,@ary;
		}else{
			push @lines,@ary;
		}
	}
	
	my $sth;
	$sth = $dbh->do("INSERT INTO l_user_job_max_set values ('$appid','$lines[0]','$lines[1]',$lines[2],$lines[3],$lines[4],$lines[5],$lines[6],$lines[7],$lines[8],$lines[9])");
		
}


# foreach my $tmp(@appids){
	# print $tmp."\n";
# }
                                                #打印抽取结果
$sth->finish;                                    #结束句柄
$dbh->disconnect;  
