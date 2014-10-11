#!/usr/bin/perl

use Encode;
use utf8;
use DBI;

binmode(STDIN,':encoding(utf8)');
binmode(STDOUT,':encoding(utf8)');
binmode(STDERR,':encoding(utf8)');

my $dsn = "DBI:mysql:database=eht_hlp;host=192.168.136.90";
my $user = 'eht';
my $password = '1qaz2wsx';

my $dbh = DBI->connect($dsn,$user,$password);
#=============read origin data from database without analysis==========
print "=============read origin data from database without analysis==========\n";

my @tables=(main_jymr,map_set_analysis,map_set_failed_analysis,mr_total,reduce_set_analysis,reduce_set_failed_analysis,time_ratio,user_wait_time,user_task_toptotal,user_time_toptotal,queue_capacity_set,queue_capacity_used);

my (@main_jymr,@map_set_analysis,@map_set_failed_analysis,@mr_total,@reduce_set_analysis,@reduce_set_failed_analysis,@time_ratio,@user_wait_time,@user_task_toptotal,@user_time_toptotal,@queue_capacity_set,@queue_capacity_used);


@main_jymr = &SQLREAD(main_jymr);
@map_set_analysis = &SQLREAD(map_set_analysis);
@map_set_failed_analysis = &SQLREAD(map_set_failed_analysis);
@mr_total = &SQLREAD(mr_total);
@reduce_set_analysis = &SQLREAD(reduce_set_analysis);
@reduce_set_failed_analysis = &SQLREAD(reduce_set_failed_analysis);
@time_ratio = &SQLREAD(time_ratio);
@user_wait_time = &SQLREAD(user_wait_time);
@user_task_toptotal = &SQLREAD(user_task_toptotal);
@user_time_toptotal = &SQLREAD(user_time_toptotal);


#foreach my $table(@tables){
#	print "~~~~~~~~~~~~result of table $table~~~~~~~~~~~~~~~\n";
	# foreach my $tmp(@user_time_toptotal){
		# print $tmp."\n";
	# } 
		
	# print "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n";
	
#}
	


#=============analysis origin data===================
print "=============analysis origin data===================\n";


print "~~~~~~~~~~~~main_jymr~~~~~~~~~~~~~~~\n";
#main_jymr analysis
#=====================================#
#4106   300     4406     93.19% 4223  #
#0       0       0       0.00%   0    #
#2529764 33265   2563029  98.70% 1763 #
#56999   903     57902    98.44% 263  #
#=====================================#

my (@job,@yarn,@map,@reduce);

for(my $i=0;$i<4;$i++){
	if($i eq 0){
		@job = &ANA_JYMR($main_jymr[$i]);
	}
	elsif($i eq 1){
		@yarn =	&ANA_JYMR($main_jymr[$i]);
	}elsif($i eq 2){
		@map = &ANA_JYMR($main_jymr[$i]);
	}elsif($i eq 3){
		@reduce = &ANA_JYMR($main_jymr[$i]);
	}
}

print "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n";

print "~~~~~~~~~~~~~~~~~~~time_ratio no need to change~~~~~~~~~~~\n";
#============================================#
#1823765 646365  47329   28336   9569    7665#
#16100   24546   5186    7846    2380    1844#
#3964    138     65      114     72      53  #
#============================================#

print "~~~~~~~~~~~~~~~~user queue usage~~~~~~~~~~~~~~\n";



print "~~~~~~~~~~~~~~~~map-reduce usage~~~~~~~~~~~~~~~\n";
	# foreach my $tmp(@mr_total){
		# print $tmp."\n";
	# }

my (@map_usage,@reduce_usage);	
my (@mr_m_s,@mr_m_f,@mr_m_t,@mr_m_ratio,@mr_m_dis,@mr_r_s,@mr_r_f,@mr_r_t,@mr_r_ratio,@mr_r_dis);


@map_usage = &ANA_MR_USAGE($mr_total[0],$mr_total[1]);
@reduce_usage = &ANA_MR_USAGE($mr_total[2],$mr_total[3]);
#map_usage each line data;
@mr_m_s = split(/\t/,$map_usage[0]);
@mr_m_f = split(/\t/,$map_usage[1]);
@mr_m_t = split(/\t/,$map_usage[2]);
@mr_m_ratio = split(/\t/,$map_usage[3]);
@mr_m_dis = split(/\t/,$map_usage[4]);
#reduce_usage each line data
@mr_r_s = split(/\t/,$reduce_usage[0]);
@mr_r_f = split(/\t/,$reduce_usage[1]);
@mr_r_t = split(/\t/,$reduce_usage[2]);
@mr_r_ratio = split(/\t/,$reduce_usage[3]);
@mr_r_dis = split(/\t/,$reduce_usage[4]);

print "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n";

print "=============analysis or data end===================\n";
#=============analysis or data end===================

#==============read week.md and insert data =================
open IN,"<:encoding(utf8)","E:/MarkDown/weekout.md";
open OUT,">>","E:/MarkDown/weekout0922.md";

while(<IN>){
#MARK_CLUSTER
#MARK_HDFS

	if($_ =~ /MARK_JYMR/){
	
		print OUT encode("utf8","<tr><td>成功</td><td>$job[0]</td><td>$yarn[0]</td><td>$map[0]</td><td>$reduce[0]</td></tr>\n");
		print OUT encode("utf8","<tr><td>失败</td><td>$job[1]</td><td>$yarn[1]</td><td>$map[1]</td><td>$reduce[1]</td></tr>\n");
		print OUT encode("utf8","<tr><td>总计</td><td>$job[2]</td><td>$yarn[2]</td><td>$map[2]</td><td>$reduce[2]</td></tr>\n");
		print OUT encode("utf8","<tr><td>成功率</td><td>$job[3]</td><td>$yarn[3]</td><td>$map[3]</td><td>$reduce[3]</td></tr>\n");
		print OUT "<tr><td>OOM</td><td>$job[4]</td><td>$yarn[4]</td><td>$map[4]</td><td>$reduce[4]</td></tr>\n";
		
	}elsif($_ =~ /MARK_TIMERATIO1/){
	
		my @map_split = split(/\t/,$time_ratio[0]);
		print OUT encode("utf8","|MAP|$map_split[0]|$map_split[1]|$map_split[2]|$map_split[3]|$map_split[4]|$map_split[5]|\n"); 
		my @reduce_split = split(/\t/,$time_ratio[1]);
		print OUT encode("utf8","|REDUCE|$reduce_split[0]|$reduce_split[1]|$reduce_split[2]|$reduce_split[3]|$reduce_split[4]|$reduce_split[5]|\n"); 
		
	}elsif($_ =~ /MARK_TIMERATIO2/){
	
		my @job_split = split(/\t/,$time_ratio[2]);
		print OUT encode("utf8","|JOB个数|$job_split[0]|$job_split[1]|$job_split[2]|$job_split[3]|$job_split[4]|$job_split[5]|\n"); 
		
	}elsif($_ =~ /MARK_QUEUERATIO/){
		my @splits1 = split(/\t/,@queue_capacity_set);
		print OUT encode("utf8","|划分占比|$splits1[1]|$splits1[2]|$splits1[3]|$splits1[4]|$splits1[5]|$splits1[6]|$splits1[7]|$splits1[8]|$splits1[9]|$splits1[10]|$splits1[11]|");
		my $lenth=@queue_capacity_used;
		for(my $i=0;$i<$lenth;$i++){
			my @splits = split(/\t/,$queue_capacity_used[$i]);
			print OUT encode("utf8","|$splits[0]|$splits[1]|$splits[2]|$splits[3]|$splits[4]|$splits[5]|$splits[6]|$splits[7]|$splits[8]|$splits[9]|$splits[10]|$splits[11]");
		}
	}elsif($_ =~ /MARK_MAPTOTAL/){
	
		print OUT encode("utf8","<tr><td>成功</td><td>$mr_m_s[0]</td><td>$mr_m_s[1]</td><td>$mr_m_s[2]</td><td>$mr_m_s[3]</td><td>$mr_m_s[4]</td></tr>\n");
		print OUT encode("utf8","<tr><td>失败</td><td>$mr_m_f[0]</td><td>$mr_m_f[1]</td><td>$mr_m_f[2]</td><td>$mr_m_f[3]</td><td>$mr_m_f[4]</td></tr>\n");
		print OUT encode("utf8","<tr><td>总计</td><td>$mr_m_t[0]</td><td>$mr_m_t[1]</td><td>$mr_m_t[2]</td><td>$mr_m_t[3]</td><td>$mr_m_t[4]</td></tr>\n");
		print OUT encode("utf8","<tr><td>成功率</td><td>$mr_m_ratio[0]</td><td>$mr_m_ratio[1]</td><td>$mr_m_ratio[2]</td><td>$mr_m_ratio[3]</td><td>$mr_m_ratio[4]</td></tr>\n");
		print OUT encode("utf8","<tr><td>分布占比</td><td>$mr_m_dis[0]</td><td>$mr_m_dis[1]</td><td>$mr_m_dis[2]</td><td>$mr_m_dis[3]</td><td></td></tr>\n");
		
	}elsif($_ =~ /MARK_REDUCETOTAL/){

		print OUT encode("utf8","<tr><td>成功</td><td>$mr_r_s[0]</td><td>$mr_r_s[1]</td><td>$mr_r_s[2]</td><td>$mr_r_s[3]</td><td>$mr_r_s[4]</td></tr>\n");
		print OUT encode("utf8","<tr><td>失败</td><td>$mr_r_f[0]</td><td>$mr_r_f[1]</td><td>$mr_r_f[2]</td><td>$mr_r_f[3]</td><td>$mr_r_f[4]</td></tr>\n");
		print OUT encode("utf8","<tr><td>总计</td><td>$mr_r_t[0]</td><td>$mr_r_t[1]</td><td>$mr_r_t[2]</td><td>$mr_r_t[3]</td><td>$mr_r_t[4]</td></tr>\n");
		print OUT encode("utf8","<tr><td>成功率</td><td>$mr_r_ratio[0]</td><td>$mr_r_ratio[1]</td><td>$mr_r_ratio[2]</td><td>$mr_r_ratio[3]</td><td>$mr_r_ratio[4]</td></tr>\n");
		print OUT encode("utf8","<tr><td>分布占比</td><td>$mr_r_dis[0]</td><td>$mr_r_dis[1]</td><td>$mr_r_dis[2]</td><td>$mr_r_dis[3]</td><td></td></tr>\n");
		
	}elsif($_ =~ /MARK_MAPSET/){
	
		foreach my $tmp(@map_set_analysis){
			my @split_set = split(/\t/,$tmp);
			print OUT encode("utf8","|$split_set[0]|$split_set[1]|$split_set[2]|$split_set[3]|$split_set[4]|\n");
		}
		
	}elsif($_ =~ /MARK_REDUCESET/){
		
		foreach my $tmp(@reduce_set_analysis){
			my @split_set = split(/\t/,$tmp);
			print OUT encode("utf8","|$split_set[0]|$split_set[1]|$split_set[2]|$split_set[3]|$split_set[4]|\n");
		}
		
	}elsif($_ =~ /MARK_USERTASK/){
	
		for(my $i=1;$i<=10;$i++){
			my @split_set = split(/\t/,$user_task_toptotal[$i-1]);
			print OUT encode("utf8","|$i|$split_set[0]|$split_set[1]|$split_set[2]|\n");
		}
	
	}elsif($_ =~ /MARK_USERTIME/){
	
		for(my $i=1;$i<=10;$i++){
			my @split_set = split(/\t/,$user_time_toptotal[$i-1]);
			print OUT encode("utf8","|$i|$split_set[0]|$split_set[1]|$split_set[2]|\n");
		}
	
	}elsif($_ =~ /MARK_USERHDFS/){
		
		
	}elsif($_ =~ /MARK_USERWAIT/){
		
		
	}elsif($_ =~ /MARK_USERWSET/){
		
		
	}else{
		print OUT encode("utf8","$_");
	}

} 	

close OUT;
close IN;
#===============read week.md and insert data end==============





###===============sub process==========================
sub SQLREAD(){
	my ($table) = @_;
	my $sth = $dbh->prepare("select * from $table");
	$sth->execute();
	my @return_arry;

	my @ary;
	while(@ary = $sth->fetchrow_array()){
        push @return_arry,join("\t",@ary);
	}                                                #
	$sth->finish;                                    #
	
	return @return_arry;
}

#analysis main_jymr data 
#@return format analysis data  
sub ANA_JYMR(){
	my ($tmp) = @_;
	my @format_data;
	my @split_num = split(/\t/,$tmp);

	push @format_data,$split_num[0]-$split_num[1];  #success
	push @format_data,$split_num[1];  #failed
	push @format_data,$split_num[0];  #total
	push @format_data,$split_num[0] == 0 ? "0.00%":sprintf("%6.2f"."%",($split_num[0]-$split_num[1])/$split_num[0]*100);  #success ratio
	push @format_data,$split_num[2];
	
	return @format_data;
}
#analysis mr_total data
#@return format analysis data
sub ANA_MR_USAGE(){
	my ($success,$failed) = @_;
	
	my @rslt = ();
	
	my (@split_total,@split_ratio,@split_dis);
	
	my @split_success = split(/\t/,$success);
	my $sum_success = $split_success[0]+$split_success[1]+$split_success[2]+$split_success[3];
	my @split_failed = split(/\t/,$failed);
	my $sum_failed = $split_failed[0]+$split_failed[1]+$split_failed[2]+$split_failed[3];
	#success
	push @split_success,$sum_success;
	push @rslt,join("\t",@split_success);
	#failed
	push @split_failed,$sum_failed;
	push @rslt,join("\t",@split_failed);
	#total
	for(my $i=0;$i<4;$i++){
		push @split_total,$split_success[$i]+$split_failed[$i];
	}
	my $total = $sum_success+$sum_failed;
	push @split_total,$total;
	push @rslt,join("\t",@split_total);
	#ratio
	for(my $i=0;$i<4;$i++){
		push @split_ratio,$split_total[$i] == 0 ? "0.00%":sprintf("%6.2f"."%",$split_success[$i]/$split_total[$i]*100);
	}
	push @split_ratio,$total == 0 ? "0.00%":sprintf("%6.2f"."%",$sum_success/$total*100);
	push @rslt,join("\t",@split_ratio);
	#distribution
	for(my $i=0;$i<4;$i++){
		push @split_dis,$total == 0 ? "0.00%":sprintf("%6.2f"."%",$split_total[$i]/$total*100);
	}
	push @split_dis,"null";
	push @rslt,join("\t",@split_dis);
	
	# foreach my $tmp(@rslt){
		# print $tmp."\n";
	# }
	return @rslt;
	
}