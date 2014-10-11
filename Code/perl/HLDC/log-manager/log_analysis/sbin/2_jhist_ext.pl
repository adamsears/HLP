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

while(1){
	my @date_info=localtime(time());
	my $week = $date_info[6];
	my $hour = $date_info[2];
	print "week now is $week\n";
	print "hour now is $hour\n";
	goto NEXTDAY if($week != 1);
	goto NEXTHOUR if($hour < 5);
  
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


#==========2============run jhist extract hadoop streaming==============================
	print "===========2=============run jhist extract hadoop streaming===========\n";
	my $jhist_mapred_flie = "../jhist_mapper.pl,../jhist_reducer.pl";
	my $jhist_ext_yaxu_2 = "6_jhist_ext_t_yaxu";

	$cmd = "hadoop jar $hadoop_streaming_jar "
				."-files $jhist_mapred_flie "
				."-Dmapred.job.name=$jhist_ext_yaxu_2 "
				."-mapper \"perl jhist_mapper.pl\" "
				."-reducer \"perl jhist_reducer.pl\" "
				."-input $jhist_input_dir "
				."-output $period_dir\/6_jhist_ext_t_out/ ";

	&PR($cmd);
	print "=====================================================================\n";
###############end of jhist extract hadoop streaming############
	


	




	print "==================================================================\n";

	NEXTDAY:
		&MySleep();
	NEXTHOUR:
  		&MySleepHour();
}


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
