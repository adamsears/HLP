#!/usr/bin/perl
use strict;

while(<>){
	chomp();
	
	if(/^task/){
		my $task_info = $_;
		my @task_split = split(/\t/,$_);
		
		my $ctn_id = $task_split[1];
		
		print "$ctn_id\t"."task\t"."$task_info\n";
	}
	elsif(/^container/){
		my $ctn_info = $_;
    my @ctn_split = split(/\t/);
    my $ctn_id = $ctn_split[0];
		
		print "$ctn_id\t"."ctn\t"."$ctn_info\n";
	}
}
