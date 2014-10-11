#!/usr/bin/perl
use strict;

#2014-06-24 08:53:45,760 INFO org.apache.hadoop.yarn.server.nodemanager.containermanager.monitor.ContainersMonitorImpl: Memory usage of ProcessTree 451007 for container-id container_1403513876102_0039_01_000057: 205.5 MB of 3 GB physical memory used; 3.0 GB of 10.8 GB virtual memory used



while(<>){
	#filter the memory with regular expression.
	if(/([\d]{4}-[\d]{2}-[\d]{2}\s+[\d]{2}:[\d]{2}:[\d]{2}).+?ContainersMonitorImpl.+?ProcessTree.+?(container_[\d]+_[\d]+_[\d]+_[\d]+):\s?([\d|\.]+)\s?([M|G]?B)\s+of\s?([\d|\.]+)\s?([M|G]B) physical memory used;\s?([\d|\.]+)\s?([M|G]?B)\s+of\s?([\d|\.]+)\s?([M|G]B) virtual memory used/ ){
		
	my $pmem=$3;
	#format MB|B to GB.
	my $gb=$4;
	if($gb eq "MB" |$gb eq "B"){
		$pmem = $pmem/1024;
	}
	$gb="GB";
	#print the format message and set containerID as key ,others as value.
	print "$2\t$pmem $gb $5 $6 $7 $8 $9 $10 $1\n";	
	
	}
}
