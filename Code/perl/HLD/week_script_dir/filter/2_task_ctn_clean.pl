#!/usr/bin/perl
use strict;

while(<>){
	chomp();
	my @elems = split(/\t/,$_);
	
	my $tmp_id = $elems[0];
	$tmp_id =~ /^task_(\d+_\d+)/;
	my @separate_key = split(/ /,$tmp_id);
	my $appid = $1;

	print "$separate_key[0]\t$separate_key[1]\t$elems[1]\t$elems[2]\t$elems[3]\t$elems[6]\t$elems[4]\t$elems[7]\t$appid\n";
}
