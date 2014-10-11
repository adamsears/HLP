#!/usr/bin/perl
use strict;

sub formatduring{
	my ($mss)=@_;
	my $days = int($mss/86400000);
        my $hours = int(($mss%86400000)/3600000);
        my $minutes = int(($mss%3600000)/60000);
        my $seconds = ($mss%60000)/1000;
	
	return ($days."days ".$hours."hours ".$minutes."minutes ".$seconds."seconds ");
}

while(<>){
	if(/^job/){
		my $jobinfo = $_;
		my @jobsplit = split();
		$_ =~ /job_(\d+_\d+)/;
		my $jobid = $1;
		
		my $executetimemill = $jobsplit[5]-$jobsplit[2];

		my $executetime = formatduring($executetimemill);
		
		my $jobvalue="job\t"."$jobsplit[0]\t$jobsplit[10]\t$jobsplit[15]\t$executetime\t$jobsplit[12]\t$jobsplit[8]\t$jobsplit[9]\t";
		
		print "$jobid\t$jobvalue\n";
	}
	elsif(/^container/){
		my $containerinfo = $_;
    my @containersplit = split();
    $_ =~ /container_(\d+_\d+)/;
    my $containerid = $1;
		my $containervalue="container\t".$containerinfo;
		
		print "$containerid\t$containervalue";
	}
}
