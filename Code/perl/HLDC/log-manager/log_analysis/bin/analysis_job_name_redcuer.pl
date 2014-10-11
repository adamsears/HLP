#!/usr/bin/perl
use strict;
my $task_count;
my $job_name = "";
my $job_count = 0;
my $count=0;
my $count_task = 0;

while(<>){
	chomp();
	my @elems = split(/\t/,$_);
  my $tmp_name = $elems[0];
  my $job_id = $elems[1];
	if($job_name eq ""){
		  $job_name = $tmp_name;
		  
			$task_count = $elems[2]+$elems[3];
			$job_count ++;
	}
	elsif($job_name eq $tmp_name){
			
		$task_count = $task_count + $elems[2]+$elems[3];
		$job_count++;
	}else{
		print "$job_name\t$job_count\t$job_id\t$task_count\n";
		$count += $job_count;
		$count_task += $task_count;
		$job_name = $tmp_name;
		$job_count=0;
		$task_count = 0;
		$task_count = $elems[2]+$elems[3];
		$job_count ++;
		}

}
print "this all :$count  $count_task\n";
