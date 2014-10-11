#!/usr/bin/perl
use strict;

while(<>){
	chomp();
	my @elems = split(/\t/);
	shift @elems;
	my $task_id = shift @elems;
	my $task_value;
	foreach my $elem(@elems){
				if($elem ne ""){
					$task_value .= "$elem\t";
				}
				
	}
	print "$task_id\t"."$task_value\n";
}