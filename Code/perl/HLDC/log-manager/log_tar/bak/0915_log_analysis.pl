#!/usr/bin/perl
use strict;
use File::Spec::Functions;
#本脚本主要功能：
#将过期超过一星期的日志进行打包，上传至HDFS

#具体操作如下：
#1.确定哪些日志需要上传
#  如果多过一星期，刚按日志的实际日期所属周的周一日期为打包文件名进行打包
#  打包文件命令格式：打包log开始日期_打包log结束日期_打包日期时间_hostname.tar
#  如打包后文件名：201406301420_dn-150_locallog.tar
#  如果后缀名存在".1"、".2"之类文件也一并打包
#2.将打包好的日志文件传至/mr-history/local-service-log按年月进行存放

my $valid_hosts = "/home/hadoop/hadoop2/etc/hadoop/slaves";
my $data_dir = "/home/hadoop/log-manager/service_log_merge";
#my $tar_bak_dir = "/home/hadoop/log-manager/log_tar_bak";
my $hadoop_log_dir = "/home/hadoop/hadoop_logs";
my $hdfs_log_dst = "/mr-history/local-service-log";
my @main_nodes = ("192.168.136.98", "192.168.136.99", "192.168.136.100");

$hadoop_log_dir =~ s/\/$//g;
my @hosts = @main_nodes;
my $line;
my @lines;
my $host;

while(1) {
  
  
  
  
  
  #Do the DATA EXTRACT Procedure
  my @date_info=localtime(time());
	my $week = $date_info[6];
	my $hour = $date_info[2];
	print "week now is $week\n";
	print "hour now is $hour\n";

  
	my $days_before = 7;
	my $day_index = 1;
	my $input_day = $date_info[3];
	$input_day = ($input_day < 10)? "0$input_day" : "$input_day";
	my $month_output = $date_info[4]+1;
	$month_output = ($month_output < 10)? "0$month_output" : "$month_output";
	my $year_output = $date_info[5]+1900;
  
	my $output_year_month_dir = "$year_output$month_output";
	my $outputday_dir;
	my @jhist_y_m_d_dir;
	my $year_month = $output_year_month_dir;
	my $mem_tar_ymd = $year_month.$input_day;
 
	while($day_index <= $days_before){
		my $day;
  		my $month;
		my $year;
		my $y_m_d;
    
		@date_info = localtime(time() - 86400*$day_index);
		$day = $date_info[3];
		$day = ($day < 10)? "0$day" : "$day"; 
		$month = $date_info[4]+1;
		$month = ($month < 10)? "0$month" : "$month";  
		$year = $date_info[5]+1900;
    
    
		if($day_index == 1){
			$outputday_dir = "$month$day";
		}
		if($day_index == 7){
			$outputday_dir = "$month$day"."-".$outputday_dir;
		}
		$y_m_d = $year."/".$month."/".$day;
		push @jhist_y_m_d_dir,$y_m_d;
		$day_index++;
	}
	
	
	foreach my $tmp(@jhist_y_m_d_dir){
		print "$tmp\n";		
	}
		
	my $jhist_root_dir = "/mr-history/done";
###############get the path of jhist file dir###################
	print "===========start to get the path of jhist file dir===========\n";

	my $cmd;
	my @jhist_000x_dir;
	my $jhist_input_dir;
	my @jhist_file;

	foreach my $dir(@jhist_y_m_d_dir){
		my @tmp_jhist_000x_dir = `hdfs dfs -ls $jhist_root_dir/$dir `;
		foreach my $tmp_000x_dir(@tmp_jhist_000x_dir){
			my @tmp =split(/\s+/,$tmp_000x_dir);
			push @jhist_000x_dir,$tmp[7];
		}
	}

	foreach my $dir(@jhist_000x_dir){
		my @tmp_jhist_file_dir = `hdfs dfs -ls $dir`;
		foreach my $tmp_jhist_file(@tmp_jhist_file_dir){
			my @tmp =split(/\s+/,$tmp_jhist_file);
			push @jhist_file,$tmp[7];
		}
	}

	for(my $i = 0;$i<@jhist_000x_dir;$i++){
		chomp($jhist_000x_dir[$i]);
		$jhist_000x_dir[$i] =~ s/^\s*$//g;	
		if($jhist_000x_dir[$i] ne ""){
			if($jhist_000x_dir[$i] ne "output"){
				if($i != @jhist_000x_dir - 1){
					$jhist_input_dir .= $jhist_000x_dir[$i]."/*.jhist".",";
				}
				else{
					$jhist_input_dir .= $jhist_000x_dir[$i]."/*.jhist";
				}
			}
		}
	}
	print "\n$jhist_input_dir\n";
	print "=================end of get jhist file dir=================\n";
#################end of get jhist file dir########################

#public variable & function
	print "====================public hadoop streaming variable=============\n";
	my $hadoop_streaming_jar = "/home/hadoop/hadoop-2.3.0-cdh5.0.0/share/hadoop/tools/lib/hadoop-streaming-2.3.0-cdh5.0.0.jar";
	my $output_root_dir = "/mr-history/log-analysis/";
	my $this_period_month_dir = "$output_year_month_dir/";
	my $this_period_day_dir = $outputday_dir;
	my $period_dir = $output_root_dir.$this_period_month_dir.$this_period_day_dir;
	my $input_targz_root_dir = "/mr-history/local-service-log/";
	my $input_targz_dir = "/mr-history/local-service-log/201409/201409080349.tar.gz";
#	my $input_linshi_tar = $input_targz_root_dir.$year_month."/20140827*".",".$input_targz_root_dir.$year_month."/20140828*";
	my $excute_script_root_dir = "/home/hadoop/log-manager/log_analysis/bin";
	print "$hadoop_streaming_jar\n";
	print "$excute_script_root_dir\n";
	print "$output_root_dir\n";
	print "$period_dir\n";
	print "$input_targz_dir\n";
	print "================================================================\n";



	sub PR{
		my ($cmd) = @_;
		print ("$cmd\n");
		system($cmd);
	}

#run Hadoop Streaming

#==========1============run memory extract hadoop streaming==============================
	print "==========1============run memory extract hadoop streaming=============\n";
#check input file if exist
	my @juge_file_0 = `hdfs dfs -ls $input_targz_dir`;
	die if($juge_file_0[0] !~ /^Found/);

	my $mem_input_file = $input_targz_dir;
	my $mem_mapred_file = "$excute_script_root_dir/cat_mapper.pl,$excute_script_root_dir/get_container_max_reducer.pl";
	my $mem_ext_yaxu_1 = "1_mem_ext_yaxu";
	$cmd = "hadoop jar $hadoop_streaming_jar "
			."-files $mem_mapred_file "
			."-Dmapred.job.name=$mem_ext_yaxu_1 "."-Dmapreduce.job.queuename=eht "
			."-mapper \"perl cat_mapper.pl\" "
			."-reducer \"perl get_container_max_reducer.pl\" "
			."-input $mem_input_file "
			."-output $period_dir\/1_mem_ext_out/ ";

	&PR($cmd);
	print "======================================================================\n";
#############end of memory extract hadoop streaming#########
	

#==========2============run jhist extract hadoop streaming==============================
	print "===========2=============run jhist extract hadoop streaming===========\n";
	my $jhist_mapred_flie = "$excute_script_root_dir/jhist_mapper.pl,$excute_script_root_dir/jhist_reducer.pl";
	my $jhist_ext_yaxu_2 = "2_jhist_ext_yaxu";

	$cmd = "hadoop jar $hadoop_streaming_jar "
				."-files $jhist_mapred_flie "
				."-Dmapred.job.name=$jhist_ext_yaxu_2 "."-Dmapreduce.job.queuename=eht "
				."-mapper \"perl jhist_mapper.pl\" "
				."-reducer \"perl jhist_reducer.pl\" "
				."-input $jhist_input_dir "
				."-output $period_dir\/2_jhist_ext_out/ ";

	&PR($cmd);
	print "=====================================================================\n";
###############end of jhist extract hadoop streaming############
	


#========3======run jobsummary extract hadoop streaming==================================
	print "========3======run jobsummary extract hadoop streaming===============\n";
#check input file if exist	
	die if($juge_file_0[0] !~ /^Found/);

	my $jobsum_mapred_flie = "$excute_script_root_dir/job_sum_mapper.pl";
	my $jobsum_ext_yaxu_3 = "3_jobsum_ext_yaxu";
	my $jobsum_input_dir = $input_targz_dir;
	$cmd = "hadoop jar $hadoop_streaming_jar "
				."-files $jobsum_mapred_flie "
				."-Dmapred.job.name=$jobsum_ext_yaxu_3 "."-Dmapreduce.job.queuename=eht "
				."-mapper \"perl job_sum_mapper.pl\" "
				."-input $jobsum_input_dir "
				."-output $period_dir\/3_jobsum_ext_out/ ";

	&PR($cmd);
	print "=====================================================================\n";
###############end of jobsummary extract hadoop streaming############
	


#======4======run jhist_memory union hadoop streaming===================================
	print "======4======run jhist_memory union hadoop streaming=================\n";
#check input file if exist
	my @juge_file_1 = `hdfs dfs -ls $period_dir\/1_mem_ext_out/_SUCCESS`;
	my @juge_file_2 = `hdfs dfs -ls $period_dir\/2_jhist_ext_out/_SUCCESS`;
	die if($juge_file_1[0] !~ /^Found/);
	die if($juge_file_2[0] !~ /^Found/);
	
	my $jm_input_file = "$period_dir\/1_mem_ext_out/,$period_dir\/2_jhist_ext_out/";
	my $jm_mapred_file = "$excute_script_root_dir/union_ctn_jhi_mapper.pl,$excute_script_root_dir/union_ctn_jhi_reducer.pl";
	my $jm_union_yaxu_4 = "4_jhist_mem_union_yaxu";
	$cmd = "hadoop jar $hadoop_streaming_jar "
				."-files $jm_mapred_file "
				."-Dmapred.job.name=$jm_union_yaxu_4 "."-Dmapreduce.job.queuename=eht "
				."-mapper \"perl union_ctn_jhi_mapper.pl\" "
				."-reducer \"perl union_ctn_jhi_reducer.pl\" "
				."-input $jm_input_file "
				."-output $period_dir\/4_jhist_mem_union_out/ ";

	&PR($cmd);
	print "====================================================================\n";
###############end of jhist_memory union hadoop streaming############
	



#=========5=========run task_memory proccess hadoop streaming==========================
	print "=========5=========run task_memory proccess hadoop streaming========\n";
#check input file if exist
	my @juge_file_3 = `hdfs dfs -ls $period_dir\/4_jhist_mem_union_out/_SUCCESS`;
	die if($juge_file_3[0] !~ /^Found/);

	my $tm_input_file = "$period_dir\/4_jhist_mem_union_out/";
	my $tm_mapred_file = "$excute_script_root_dir/task_mapper.pl,$excute_script_root_dir/task_reducer.pl";
	my $tm_process_yaxu_5 = "5_task_ctn_union_yaxu";
	$cmd = "hadoop jar $hadoop_streaming_jar "
				."-files $tm_mapred_file "
				."-Dmapred.job.name=$tm_process_yaxu_5 "."-Dmapreduce.job.queuename=eht "
				."-mapper \"perl task_mapper.pl\" "
				."-reducer \"perl task_reducer.pl\" "
				."-input $tm_input_file "
				."-output $period_dir\/5_task_ctn_union_out/ ";

	&PR($cmd);
	print "===================================================================\n";
###############end of task_memory proccess streaming#################
	
#==========6============run jhist extract hadoop streaming==============================
	print "===========6=============run jhist extract hadoop streaming===========\n";
	my $jhist_mapred_flie = "/home/hadoop/log-manager/log_analysis/jhist_mapper.pl,/home/hadoop/log-manager/log_analysis/jhist_reducer.pl";
	my $jhist_ext_yaxu_6 = "6_jhist_ext_t_yaxu";

	$cmd = "hadoop jar $hadoop_streaming_jar "
				."-files $jhist_mapred_flie "
				."-Dmapred.job.name=$jhist_ext_yaxu_6 "."-Dmapreduce.job.queuename=eht "
				."-mapper \"perl jhist_mapper.pl\" "
				."-reducer \"perl jhist_reducer.pl\" "
				."-input $jhist_input_dir "
				."-output $period_dir\/6_jhist_ext_t_out/ ";

	&PR($cmd);
	print "=====================================================================\n";
###############end of jhist extract hadoop streaming############


#=========7=========run analysis proccess hadoop streaming============================
	print "=========7=========run analysis proccess hadoop streaming==========\n";
#check input file if exist
	my @juge_file_4 = `hdfs dfs -ls $period_dir\/5_task_ctn_union_out/_SUCCESS`;
	die if($juge_file_4[0] !~ /^Found/);

	my $ana_input_file = "$period_dir\/5_task_ctn_union_out/";
	my $ana_mapred_file = "$excute_script_root_dir/analysis_mapper.pl,$excute_script_root_dir/analysis_reducer.pl";
	my $ana_yaxu_7 = "7_analysis_mr_mem_yaxu";
	$cmd = "hadoop jar $hadoop_streaming_jar "
			."-files $ana_mapred_file "
			."-Dmapred.job.name=$ana_yaxu_7 "."-Dmapreduce.job.queuename=eht "
			."-mapper \"perl analysis_mapper.pl\" "
			."-reducer \"perl analysis_reducer.pl\" "
			."-input $ana_input_file "
			."-output $period_dir\/7_analysis_mr_mem_out/ ";

	&PR($cmd);


###############end of analysis proccess streaming####################
	print "==================================================================\n";
	
NEXTDAY:
  &MySleep();
	
}

##########################################################
######################Local Functions#####################
##########################################################
sub MakeDirIfNotExist {
    my ($strPathname) = @_;
    if ( !-e $strPathname ) {
        mkdir -p $strPathname,
          0755 || die "ERROR: Cannot make directory $strPathname: $!\n";
    }
}

sub PR {
    my ($cmd) = @_;
    print $cmd."\n";
    return system $cmd;
}

sub MySleep(){
  my $sleep_time = 24*3600;
  print "I'm sleeping z Z Z ...\n";
  sleep($sleep_time);
}

sub MakeHadoopDirIfNotExist {
    my ($hadooppath) = @_;
    my $result = system("hdfs dfs -test -e $hadooppath");
    if ( $result ne 0 ) {    # 0:exist 1:not exist
        my $hadoopmkdircmd = `hdfs dfs -mkdir -p $hadooppath`;
    }
}
