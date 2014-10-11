#!/usr/bin/perl
use strict;

my $pre_key="";
my $max_mem = 0;
my $final_value;

my $tag = "UNSUC";

while(<>){
		chomp();
		my @elems = split(/\t/,$_);
		
		my $tmp_key = shift @elems;
		my $tmp_mem = $elems[5];
		my $status = $elems[4];
		#print "$tmp_mem\n";
		my $tmp_string;
		foreach my $elem(@elems){
					$tmp_string .= "$elem\t";
					
			}
		my $tmp_value = $tmp_string;	
		
		if($pre_key eq ""){
			$pre_key = $tmp_key;
			if($status eq "SUCCEEDED"){
				$tag = "SUCCEEDED";
				$max_mem = $tmp_mem;
				$final_value = $tmp_value;
			}else{
				if($max_mem < $tmp_mem){
				$max_mem = $tmp_mem;
				$final_value = $tmp_value;
				}
			}				
		}
		elsif($pre_key eq $tmp_key){
			if($status eq "SUCCEEDED"){
				$tag = "SUCCEEDED";
			}
			if($tag eq "SUCCEEDED"){
				if($status eq $tag){
					$max_mem = $tmp_mem;
					$final_value = $tmp_value;
				}	
			}else{
				if($max_mem < $tmp_mem){
				$max_mem = $tmp_mem;
				$final_value = $tmp_value;
				}
			}
		}
		else{
		  print "$pre_key\t"."$final_value\n";
		  #print "$max_mem\n";
			$pre_key = $tmp_key;
			$max_mem = 0;
			$tag = "UNSUC";
			if($status eq "SUCCEEDED"){
				$tag = "SUCCEEDED";
				$max_mem = $tmp_mem;
				$final_value = $tmp_value;
			}else{
				if($max_mem < $tmp_mem){
				$max_mem = $tmp_mem;
				$final_value = $tmp_value;
				}
			}
			
		}
	}
print "$pre_key\t"."$final_value\n";