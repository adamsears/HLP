#!/usr/bin/perl
use strict;
use File::Spec::Functions;

#���ű���Ҫ���ܣ�
#��Hadoop��Job��־�������������ش�������ϴ�HDFS

#����������£�
#1.ȷ�����β���������־��Χ
#2.���漰��־���������ؽ��д��
#3.�������־�ϴ���HDFS
#4.��������־�ļ�������ļ�

my $data_dir = "/home/hadoop/log-manager/job_log_merge";
my $hdfs_log_src = "/mr-history/done";
my $hdfs_log_dst = "/mr-history/hdfs-job-log";

$data_dir =~ s/\/$//g;
$hdfs_log_src =~ s/\/$//g;
$hdfs_log_dst =~ s/\/$//g;

while(1) {
  #ֻ�����壨���賿��ʼ����������������
  my @date_info=localtime(time());
  my $week = $date_info[6];
  goto NEXTDAY if($week != 5);
  print `date`;
	
  print "\nenumerate HDFS job conditioned log files,and get it to $data_dir ...\n";
  &PR("mkdir -p $data_dir") if(!-e $data_dir);

  my $hdfs_log_oper_src;
  my @hdfs_log_paths;
  my $hdfs_log_path;
  my @ret_lines;
  my $tmp_line;
  
  #��ȡһ��ǰ����ǰ->��/��/ʱ/��
  my $days_before = 7;
  my $day_index = 1;
  
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
  	
    $hdfs_log_oper_src = $hdfs_log_src."/$year/$month/$day";
    @ret_lines = `hdfs dfs -ls $hdfs_log_oper_src`;
    foreach $tmp_line(@ret_lines){
      chomp($tmp_line);
      next if($tmp_line !~ /\s+($hdfs_log_oper_src\/.*)$/);  		
      push @hdfs_log_paths, $1;
    }
  }
  
  #����������־������
  foreach $hdfs_log_path(@hdfs_log_paths){
    &PR("hdfs dfs -get $hdfs_log_path/* $data_dir");
  }
  
  # change current operation dir to Log_Dir
  chdir $data_dir;
  
  #��������ļ�
  #��$data_dir�ļ����������ļ���������
  print("\nread log files in --> $data_dir ...\n");
  opendir (DIR, $data_dir) || die "Error in opening dir $data_dir\n";
  my @log_files = ();
  my $log_file_path;
  while((my $filename = readdir(DIR))){
    $log_file_path = $filename;
  next if($log_file_path !~ /(\.jhist$)|(conf\.xml$)/);
    push @log_files, $log_file_path;
  }
  closedir(DIR);
	
  #�����ǰû�з�����������־�ļ����򲻽��д���
  goto NEXTDAY if(0 == @log_files);  
  
  #��ȡ��ǰ->��/��/��/ʱ/��
  my $min = $date_info[1];
  $min = ($min < 10)? "0$min" : "$min"; 
  my $hour = $date_info[2];
  $hour = ($hour < 10)? "0$hour" : "$hour";  
  my $day = $date_info[3];
  $day = ($day < 10)? "0$day" : "$day";
  my $month = $date_info[4]+1;
  $month = ($month < 10)? "0$month" : "$month";
  my $year = $date_info[5]+1900;
  
  #201406301420.tar.gz
  my $tar_file = catfile $data_dir, "$year$month$day$hour$min".".tar.gz";
  
  my $tar_cmd = "tar -zcvf $tar_file";
  my $log_file;
  foreach $log_file(@log_files){
    $tar_cmd .= " $log_file";
  }
  print "\ntar file ...\n";
  &PR($tar_cmd) == 0 || die "\"$tar_cmd\" failed: $?";
	
  # upload tar file to hdfs
  my $log_parent_dir = catfile $hdfs_log_dst,"$year$month";
  &MakeHadoopDirIfNotExist($log_parent_dir);
  my $upload_cmd = "/home/hadoop/hadoop2/bin/hdfs dfs -put $tar_file $log_parent_dir";
  print "\nupload tar file to HDFS ...\n";
  &PR($upload_cmd);
  
  # check: if tar file on hdfs size is zero, stop clean local service log
  my $hdfs_tar_file = catfile $log_parent_dir, (split(/\//,$tar_file))[-1];
  my $ret_size = `/home/hadoop/hadoop2/bin/hdfs dfs -du -s $hdfs_tar_file`;  
  print "\ncheck HDFS tar file size ...\n";
  $ret_size =~ /([\d]+)\s+$hdfs_tar_file/ || die "check size of HDFS FILE --> $hdfs_tar_file failed: $?";
  print "HDFS tar file --> $hdfs_tar_file: $1 bytes\n";
  
  # clean local log files
  print "\nclean local tarED log file ...\n";
  my $clean_cmd;
  foreach $log_file(@log_files){
    $clean_cmd = "rm -rf $log_file";
    &PR($clean_cmd);
  }
  
  #comment following command, prevent losing logs 
  #administrator can delete tar files manually  
  $clean_cmd = "rm -rf $tar_file";
  &PR($clean_cmd);
  
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
