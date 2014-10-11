#!/usr/bin/perl
#please create table to insert !!!
use DBI;
my $dsn = "DBI:mysql:database=eht_hlp;host=localhost";
my $user = 'root';
my $password = '';

my $dbh = DBI->connect($dsn,$user,$password);       #连接数据库
#queues
my @queues = ("asr_dictt","asr_embed","asr_embedrecog","asr_trans","call_edu","call_music","eht","hw_tts","nlp","sre");

my @timestamps=();
my ($sth,@ary);
$sth = $dbh->prepare("SELECT `timestamp` FROM task_sample_1min GROUP BY `timestamp` ORDER BY `timestamp`");   #准备
$sth->execute();
while(@ary = $sth->fetchrow_array()){
	push @timestamps,$ary[0];
}
$sth->finish;
print "got timestamps >>>> go to count insert\n";
foreach my $timestamp(@timestamps){
	my @queue_value;
	foreach my $queue(@queues){
		my @ary;
		my $sth = $dbh->prepare("SELECT sum(pmemset) FROM task_sample_1min WHERE `timestamp` = $timestamp  and queue = '$queue'");
		$sth->execute();
		while(@ary = $sth->fetchrow_array()){
			if($ary[0] eq ''){
				push @queue_value,0;
			}else{
				push @queue_value,$ary[0];
			}
			
		}                                                #打印抽取结果
		$sth->finish;
	}
	my $rv = $dbh->do("INSERT INTO mem_time_1min values ($timestamp,$queue_value[0],$queue_value[1],$queue_value[2],$queue_value[3],$queue_value[4],$queue_value[5],$queue_value[6],$queue_value[7],$queue_value[8],$queue_value[9])");
}
print "mem_time_1min done!\n";

$dbh->disconnect;


