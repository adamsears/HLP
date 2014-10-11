#!/usr/bin/perl
use strict;

my $line;
my @elems;

my $tmp_key;
my $pre_key = "";

my $str_value;
my $tmp_value;
my @vals;
my @final_vals;
my $tmp_mem;
my $max_mem;

my $tmp_index;
#get the max physical memory used per container.
while($line = <STDIN>){
	chomp($line);
	#split the key-value.
	@elems = split(/\t/, $line);
	$tmp_key = $elems[0];	
	$str_value = $elems[1];
	@vals = split(/ /, $str_value);
	$tmp_mem = $vals[0];
	#if-elsif-else algorithm implementation.
	if(!defined($pre_key) || $pre_key eq "") {
		$pre_key = $tmp_key;
		$max_mem = $tmp_mem;
		@final_vals = @vals;
	}elsif($pre_key eq $tmp_key){
		if($max_mem < $tmp_mem){
			$max_mem = $tmp_mem;
			@final_vals = @vals;
		}
  	}else{
  		$str_value = $final_vals[1];
  		for($tmp_index = 2; $tmp_index < @final_vals; $tmp_index++){
  			$str_value = $str_value."\t".$final_vals[$tmp_index];
  		}  	
  		print $pre_key."\t".$max_mem."\t".$str_value."\n";
  	
  		$pre_key = $tmp_key;
  		$max_mem = $tmp_mem;
  		@final_vals = @vals;
 	 }
}
#proc last sentence
$str_value = $final_vals[1];
for($tmp_index = 2; $tmp_index < @final_vals; $tmp_index++){
        $str_value = $str_value."\t".$final_vals[$tmp_index];
}
print $pre_key."\t".$max_mem."\t".$str_value."\n";
