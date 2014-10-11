#!/usr/bin/perl
#please create table to insert !!!
use DBI;
my $dsn = "DBI:mysql:database=eht_hlp;host=localhost";
my $user = 'root';
my $password = '';

my $dbh = DBI->connect($dsn,$user,$password);       #连接数据库
my $rv = $dbh->do("CREATE TABLE mem_time_1min (timestamp datetime,asr_dictt float,asr_embed float,asr_embedrecog float,asr_trans float,call_edu float,call_music float,eht float,hw_tts float,nlp float,sre float,INDEX `index_time` (`timestamp`) USING HASH)");
print "mem_time_1min created! $rv \n";
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
	my $rv = $dbh->do("INSERT INTO mem_time_1min values ( FROM_UNIXTIME($timestamp),$queue_value[0],$queue_value[1],$queue_value[2],$queue_value[3],$queue_value[4],$queue_value[5],$queue_value[6],$queue_value[7],$queue_value[8],$queue_value[9])");
}
print "mem_time_1min done!\n";

#my $rv = $dbh->do("insert into queue_capacity_used values('2014-09-15',(SELECT round(sum(asr_dictt)/sum(asr_dictt+asr_embed+asr_embedrecog+asr_trans+call_edu+call_music+eht+hw_tts+nlp+sre)*100,2) FROM mem_time_1min),(SELECT round(sum(asr_trans)/sum(asr_dictt+asr_embed+asr_embedrecog+asr_trans+call_edu+call_music+eht+hw_tts+nlp+sre)*100,2) FROM mem_time_1min),(SELECT round(sum(asr_embedrecog)/sum(asr_dictt+asr_embed+asr_embedrecog+asr_trans+call_edu+call_music+eht+hw_tts+nlp+sre)*100,2) FROM mem_time_1min),(SELECT round(sum(call_edu)/sum(asr_dictt+asr_embed+asr_embedrecog+asr_trans+call_edu+call_music+eht+hw_tts+nlp+sre)*100,2) FROM mem_time_1min),(SELECT round(sum(nlp)/sum(asr_dictt+asr_embed+asr_embedrecog+asr_trans+call_edu+call_music+eht+hw_tts+nlp+sre)*100,2) FROM mem_time_1min),(SELECT round(sum(eht)/sum(asr_dictt+asr_embed+asr_embedrecog+asr_trans+call_edu+call_music+eht+hw_tts+nlp+sre)*100,2) FROM mem_time_1min),(SELECT round(sum(sre)/sum(asr_dictt+asr_embed+asr_embedrecog+asr_trans+call_edu+call_music+eht+hw_tts+nlp+sre)*100,2) FROM mem_time_1min),(SELECT round(sum(asr_embed)/sum(asr_dictt+asr_embed+asr_embedrecog+asr_trans+call_edu+call_music+eht+hw_tts+nlp+sre)*100,2) FROM mem_time_1min),(SELECT round(sum(hw_tts)/sum(asr_dictt+asr_embed+asr_embedrecog+asr_trans+call_edu+call_music+eht+hw_tts+nlp+sre)*100,2) FROM mem_time_1min),(SELECT round(sum(call_music)/sum(asr_dictt+asr_embed+asr_embedrecog+asr_trans+call_edu+call_music+eht+hw_tts+nlp+sre)*100,2) FROM mem_time_1min))");
print $rv."\n";


$dbh->disconnect;


