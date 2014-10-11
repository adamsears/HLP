#!/usr/bin/perl
use strict;

while(<>){
	chomp();
	my @elems = split(/\t/,$_);
	print "$elems[15]\t$elems[0]\t$elems[8]\t$elems[9]\t$elems[10]\n";	
}
