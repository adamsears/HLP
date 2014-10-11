#!/usr/bin/perl
use strict;
use File::Spec::Functions;
#本脚本主要功能：
#删除超过一星期的日志

my $valid_hosts = "/home/hadoop/hadoop2/etc/hadoop/slaves";
my $hadoop_log_dir = "/home/hadoop/hadoop_logs";
my @main_nodes = ("192.168.136.98", "192.168.136.99", "192.168.136.100");

$hadoop_log_dir =~ s/\/$//g;
my @hosts = @main_nodes;

my $line;
my @lines;
my $host;

while(1) {
  print "\nload valid hosts ...\n";
  open INPUT, "<$valid_hosts";
  while($line = <INPUT>){
    chomp($line);
    $line =~ s/\s+//g;
    next if($line eq "" || $line=~/^#/);	
    push @hosts, $line;
  }
  close INPUT;	
	
  #获取近一周的日期
  my $days_before = 7;
  my $day_index = 0;
  my @dates_strs=();
  my $dates_regex;
  my @date_info;   
 
  while($day_index <= $days_before){
    my $min;
    my $hour;
    my $day;
    my $month;
    my $year;
  		
    @date_info = localtime(time() - 86400*$day_index);
    $day = $date_info[3];
    $day = ($day < 10)? "0$day" : "$day";  	
    $month = $date_info[4]+1;
    $month = ($month < 10)? "0$month" : "$month";  	
    $year = $date_info[5]+1900; 
  	
    $day_index++;
  	push @dates_strs, "$year-$month-$day";
  }
  $dates_regex = join("|", @dates_strs);

  foreach $host(@hosts){
    print "\nssh $host ls $hadoop_log_dir/*.log.20*\n";
    @lines = `ssh $host 'ls $hadoop_log_dir/*.log.20*'`;
    print "ssh $host ls $hadoop_log_dir/*.out.*\n";
    push @lines, `ssh $host 'ls $hadoop_log_dir/*.out.*'`;
		
    foreach $line(@lines){
      chomp($line);
      next if($line =~ /^ls: cannot access/);
      $line =~ s/\s+//g;
      next if($line eq "");
			
			if($line !~ /$dates_regex/){
				my $log_path = $hadoop_log_dir."/".$line;
				&PR("ssh hadoop\@$host rm -rf $line");
			}
    }	
  } 	
  my $sleep_time = 86400;
  sleep($sleep_time);	
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
