#!/usr/bin/perl -w
use strict;

my @elems;

my $pre_key = "";
my $tmp_key;
my $task_value;
my $ctn_value;
my $task_key;
my $attempt_key;

while(<>){
	chomp();
	@elems = split(/\t/,$_);
	
	$tmp_key = shift @elems;
	my $type = shift @elems;
	
	if($pre_key eq "") {
		$pre_key = $tmp_key;
				
		if($type eq "task") {
			
			my $key = shift @elems;
			my @tmp = split(/ /,$key);
			$task_key = $tmp[0];
			$attempt_key = $tmp[1];
			
			foreach my $elem(@elems){
					$task_value .= "$elem\t";
				}
		}else{
			shift @elems;
			foreach my $elem(@elems){
				$ctn_value .= "$elem\t";
				}		
			}
	}elsif($pre_key eq $tmp_key) {	
					
		if($type eq "task") {
			my $key = shift @elems;
			my @tmp = split(/ /,$key);
			$task_key = $tmp[0];
			$attempt_key = $tmp[1];
			foreach my $elem(@elems){
					$task_value .= "$elem\t";
				}
		}else{
			shift @elems;
			foreach my $elem(@elems){
				$ctn_value .= "$elem\t";
				}		
		}
		#output the jhist union info
		print "$pre_key\t$task_key\t$attempt_key\t$task_value\t$ctn_value\n";
	}else{
			$pre_key = $tmp_key;
			$task_value = "";
			$ctn_value = "";
			$task_key = "";
			$attempt_key = "";
			if($type eq "task") {
				
				my $key = shift @elems;
				my @tmp = split(/ /,$key);
				$task_key = $tmp[0];
				$attempt_key = $tmp[1];
			
				foreach my $elem(@elems){
					$task_value .= "$elem\t";
				}
			}else{
				shift @elems;
				foreach my $elem(@elems){
					$ctn_value .= "$elem\t";
				}		
			}
	}
	
}
