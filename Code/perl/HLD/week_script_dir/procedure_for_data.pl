#!/usr/bin/perl
#

&PR("perl ");
&PR("perl ");
&PR("perl ");

sub PR(){
        my ($cmd) = @_;
        print $cmd."\n";
        system $cmd;
}
