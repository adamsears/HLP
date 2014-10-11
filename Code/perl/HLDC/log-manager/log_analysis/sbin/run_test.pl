##This script will be automatically run one week per time
#
#
#
#
#To solve this problem we have four things to do :
#   1.To series the procedure of the scripts
#   2.To make this perl script run automatically
#



#for the first one we need to solve several key problem:
#   (1)where are input files,how to get them.
#      jhist file in : /mr-history/done/2014/07/06/0000*/*.jhist
#      nodemanager logfile in: /mr-history/local-service-log/201407/*.tar.gz
#      Jobhistory in /mr-history/local-service-log/201407/*tar.gz

#   (2)where will the output files go.
#      outputfile should like /mr-history/log-analysis/201407/0715-0722/.
#                       under this file has some necessary middle files 

#while(1){
	my @date_info=localtime(time());
	my $week = $date_info[6];
	my $hour = $date_info[2];
	print "week now is $week\n";
	print "hour now is $hour\n";
	#goto NEXTDAY if($week != 5);
	#goto NEXTHOUR if($hour != 3);
  
	my $days_before = 7;
	my $day_index = 1;
	my $input_day = $date_info[3];
	$input_day = ($day < 10)? "0$day" : "$day";
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

	my $input_targz_dir = $input_targz_root_dir.$year_month."/".$mem_tar_ymd."*";

	$input_tartgz_dir = "/mr-history/local-service-log/201407/20140711*.tar.gz";
	print "$hadoop_streaming_jar\n";
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
	my $mem_mapred_file = "../bin/cat_mapper.pl,../bin/get_container_max_reducer.pl";
	my $mem_ext_yaxu_1 = "mem_ext_yaxu_1";
	$cmd = "hadoop jar $hadoop_streaming_jar "
			."-files $mem_mapred_file "
			."-Dmapred.job.name=$mem_ext_yaxu_1 "
			."-mapper \"perl cat_mapper.pl\" "
			."-reducer \"perl get_container_max_reducer.pl\" "
			."-input $mem_input_file "
			."-output $period_dir\/1_mem_ext_out/ ";

	&PR($cmd);
	print "======================================================================\n";
#############end of memory extract hadoop streaming#########
	

#==========2============run jhist extract hadoop streaming==============================
	print "===========2=============run jhist extract hadoop streaming===========\n";
	my $jhist_mapred_flie = "../bin/jhist_mapper.pl,../bin/jhist_reducer.pl";
	my $jhist_ext_yaxu_2 = "2_jhist_ext_yaxu";

	$cmd = "hadoop jar $hadoop_streaming_jar "
				."-files $jhist_mapred_flie "
				."-Dmapred.job.name=$jhist_ext_yaxu_2 "
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

	my $jobsum_mapred_flie = "../bin/job_sum_mapper.pl";
	my $jobsum_ext_yaxu_3 = "3_jobsum_ext_yaxu";
	my $jobsum_input_dir = "/logfile/mapred-hadoop*";
	$cmd = "hadoop jar $hadoop_streaming_jar "
				."-files $jobsum_mapred_flie "
				."-Dmapred.job.name=$jobsum_ext_yaxu_3 "
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
	my $jm_mapred_file = "../bin/union_ctn_jhi_mapper.pl,../bin/union_ctn_jhi_reducer.pl";
	my $jm_union_yaxu_4 = "4_jhist_mem_union_yaxu";
	$cmd = "hadoop jar $hadoop_streaming_jar "
				."-files $jm_mapred_file "
				."-Dmapred.job.name=$jm_union_yaxu_4 "
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
	my $tm_mapred_file = "../bin/task_mapper.pl,../bin/task_reducer.pl";
	my $tm_process_yaxu_5 = "5_task_ctn_union_yaxu";
	$cmd = "hadoop jar $hadoop_streaming_jar "
				."-files $tm_mapred_file "
				."-Dmapred.job.name=$tm_process_yaxu_5 "
				."-mapper \"perl task_mapper.pl\" "
				."-reducer \"perl task_reducer.pl\" "
				."-input $tm_input_file "
				."-output $period_dir\/5_task_ctn_union_out/ ";

	&PR($cmd);
	print "===================================================================\n";
###############end of task_memory proccess streaming#################
	



#=========7=========run analysis proccess hadoop streaming============================
	print "=========7=========run analysis proccess hadoop streaming==========\n";
#check input file if exist
	my @juge_file_4 = `hdfs dfs -ls $period_dir\/5_task_ctn_union_out/_SUCCESS`;
	die if($juge_file_4[0] !~ /^Found/);

	my $ana_input_file = "$period_dir\/5_task_ctn_union_out/";
	my $ana_mapred_file = "../bin/analysis_mapper.pl,../bin/analysis_reducer.pl";
	my $ana_yaxu_7 = "7_analysis_mr_mem_yaxu";
	$cmd = "hadoop jar $hadoop_streaming_jar "
			."-files $ana_mapred_file "
			."-Dmapred.job.name=$ana_yaxu_7 "
			."-mapper \"perl analysis_mapper.pl\" "
			."-reducer \"perl analysis_reducer.pl\" "
			."-input $ana_input_file "
			."-output $period_dir\/7_analysis_mr_mem_out/ ";

	&PR($cmd);


###############end of analysis proccess streaming####################
	print "==================================================================\n";

	NEXTDAY:
		&MySleep();
	NEXTHOUR:
  		&MySleepHour();
#}


#subprocess
sub MySleep(){
	my $sleep_time = 24*3600;
	print "I'm sleeping z Z Z ...Wake up one week later z Z Z ...\n";
	sleep($sleep_time);
}

sub MySleepHour(){
	my $sleep_time = 3600;
	print "I'm sleeping z Z Z ...Wake up one hour later z Z Z ...\n";
	sleep($sleep_time);
}
