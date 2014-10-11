#!/usr/bin/perl
#
#
#
#
&PR("perl load_data.pl");
&PR("perl update_bctnmem.pl");
&PR("perl normal_procedure.pl");#to to normal procedure for analysis
&PR("perl anaylsis_data.pl");
&PR("perl frequency.pl");
&PR("perl frequency_mem_time.pl");

sub PR(){
	my ($cmd) = @_;
	print $cmd."\n";
	system $cmd;
}
