#!/usr/bin/perl
#use strict;

use DBI;
my $dsn = "DBI:mysql:database=eht_hlp;host=localhost";
my $user = 'root';
my $password = '';

my $dbh = DBI->connect($dsn,$user,$password);       #连接数据库

my @date_info=localtime(time()-86400);

my $day = $date_info[3];  #yesterday
$day = ($day < 10)? "0$day" : "$day";
my $month = $date_info[4]+1;  #Month
$month = ($month < 10)? "0$month" : "$month";
my $year = $date_info[5]+1900;  #year
my $appendix = $year."".$month."".$day;


my @tables = ("b_ctn_mem","b_job_info","b_task_ctn","b_task_error","l_union_tc","l_union_unique","l_union_queue","time_ratio","mr_total","mr_asr_dictt","mr_asr_embed","mr_asr_embedrecog","mr_asr_trans","mr_call_edu","mr_call_music","mr_eht","mr_hw_tts","mr_nlp","mr_sre","user_task_toptotal","user_time_toptotal","user_wait_time","wrong_set_map","wrong_set_reduce","wrong_set_job","main_jymr","map_set_analysis","map_set_failed_analysis","reduce_set_analysis","reduce_set_failed_analysis","mem_time_5s","mem_time_1min","task_sample_1min","task_sample_5s");
foreach my $table(@tables){
	my $alter_name = $appendix."_".$table;
	my $statement = "ALTER TABLE $table RENAME $alter_name";
	my $rv = $dbh->do($statement);
	print "$table is $rv\n";	
}
$dbh->disconnect;                                #断开
