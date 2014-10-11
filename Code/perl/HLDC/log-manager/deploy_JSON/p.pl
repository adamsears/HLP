#!/usr/bin/perl
use strict;

while(<>){
	chomp();
	split(/ /,$_);
	print "$1\n";
}
print "\n";
