#!/usr/bin/perl
use strict;

my @elems;

my $tmp_key;
my $pre_key = "";

my $job_value;
my @ctn_values;

my $ctn_index = 0;



while(<>){
	
	chomp();
	@elems = split(/\t/);
	
	$tmp_key = shift @elems;
#	print "$tmp_key\n";
	
	my $type = shift @elems;
#	print "$type\n";
	my $tmp_value;
	if($pre_key eq "") {
		$pre_key = $tmp_key;
		
		
		if($type eq "job") {
			foreach my $elem(@elems){
					$job_value .= "$elem\t";
				}
		#		print "$job_value\n";
		}else{
			foreach my $elem(@elems){
				$tmp_value .= "$elem\t";
			}
		#	print "$tmp_value\n";	
			$ctn_values[$ctn_index] = $tmp_value;		
		#	print "$ctn_values[$ctn_index]\n";
			$ctn_index++;
		}
		
		
	}elsif($pre_key eq $tmp_key) {
		
				
		
		if($type eq "job") {
			foreach my $elem(@elems){
					$job_value .= "$elem\t";
				}
		}else{
			foreach my $elem(@elems){
				$tmp_value .= "$elem\t";	
			}
#			print "$tmp_value\n";
			$ctn_values[$ctn_index] = $tmp_value;		
			#print "$ctn_values[$ctn_index]\n";
			$ctn_index++;
			}
			
			
			
		}
		else{
			
			if($job_value ne ""){
			for (my $index = 0;$index<@ctn_values;$index++){
				
				print $pre_key."\t".$job_value."\t".$ctn_values[$index]."\n";
				
			}
		
				
			}	
				
			$ctn_index = 0;
			$pre_key = $tmp_key;
			$job_value = "";
			@ctn_values = ();
			if($type eq "job") {
			foreach my $elem(@elems){
					$job_value .= "$elem\t";
				}
			#	print "$job_value\n";
			}else{
			foreach my $elem(@elems){
				$tmp_value .= "$elem\t";	
			}
			$ctn_values[$ctn_index] = $tmp_value;		
			$ctn_index++;
			}	
		
		}
	
	
	
}