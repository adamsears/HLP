#!/usr/bin/perl
use strict;

while(<>){
        if(/jobhistory.JobSummary/){
                my @jobsummary=split();
                my @jobsumInfo=split(/,/,$jobsummary[4]);
                for my $temp(@jobsumInfo) {
                        my @jobInfo=split(/=/,$temp);
                        print "$jobInfo[1]\t";

                }
                print "\n";
                #print OUT "@jobsumInfo\n";
                #print  OUT "$jobsumInfo[0]\t$jobsumInfo[4]\t\n";
        }
}
close OUT;