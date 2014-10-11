#!/usr/bin/perl
use strict;

while(<>){
	chomp();
	my @elems = split(/\t/,$_);
	my $tmp_id = $elems[0];
	$tmp_id =~ /^container_(\d+_\d+)_/;
	my $appid = $1;
	
	
	print "$elems[0]\t$elems[1]\t$elems[3]\t$elems[5]\t$elems[7]\t$elems[9]\t$elems[10]\t$appid\n";
}