#!/usr/bin/perl -w
use strict;

my @elems;

my $pre_key = "";
my $tmp_key;


my $start_value;
my $status_value;
#my $ctn_value;
#my $task_key;
#my $attempt_key;

while(<>){
	chomp();
	@elems = split(/\t/,$_);
	
	$tmp_key = shift @elems;
	my $type = shift @elems;
	
	my $tmp_value;
	foreach my $elem(@elems){
		$tmp_value .= "$elem\t";
	}
	
	if($pre_key eq "") {
		$pre_key = $tmp_key;
				
		if($type eq "STARTED") {
			$start_value = $tmp_value;
		}else{
				$status_value = $tmp_value;
		}		
	}elsif($pre_key eq $tmp_key){	
					
		if($type eq "STARTED") {
			$start_value = $tmp_value;
		}else{
				$status_value = $tmp_value;
		}
		#output the jhist union info
		print "$pre_key\t$start_value\t$status_value\n";		
	}else{
		$pre_key = $tmp_key;
		$start_value = "";
		$status_value = "";
	
		if($type eq "STARTED") {
			$start_value = $tmp_value;
		}else{
			$status_value = $tmp_value;
		}		
	}
}
