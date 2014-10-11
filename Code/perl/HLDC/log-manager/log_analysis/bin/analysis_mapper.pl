#!/usr/bin/perl
use strict;

while(<>){
	chomp();
	my @elems = split(/\t/,$_);
	
	my $type = $elems[3];
	
	print "$type\t$_\n";	
}