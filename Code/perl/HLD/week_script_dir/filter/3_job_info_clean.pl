#!/usr/bin/perl
use strict;

while(<>){
	chomp();
	my @elems = split(/\t/,$_);
	my $tmp_id = $elems[0];
	$tmp_id =~ /^job_(\d+_\d+)/;
	my $appid = $1;
	
	print "$elems[0]\t$elems[1]\t$elems[2]\t$elems[3]\t$elems[4]\t$elems[5]\t$elems[6]\t$elems[7]\t$elems[8]\t$elems[9]\t$elems[10]\t$elems[11]\t$elems[12]\t$elems[13]\t$elems[14]\t$elems[15]\t$appid\n";
}