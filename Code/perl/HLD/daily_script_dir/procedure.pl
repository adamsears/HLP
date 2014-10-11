#!/usr/bin/perl
#
#
#
#
&PR("perl frequency.pl");
&PR("perl frequency_mem_time.pl");
&PR("perl anaylsis_data.pl");

sub PR(){
	my ($cmd) = @_;
	print $cmd."\n";
	system $cmd;
}
