#!/usr/bin/perl
use strict;

my @hosts = (106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177);
foreach my $host(@hosts){
        $host =  "192.168.89.".$host;
	print "$host\n";
	&PR("scp test.sh $host:~/");
        &PR("ssh $host sh test.sh");
        &PR("ssh $host rm test.sh");
}

sub PR{
        my ($cmd) = @_;
        print ("$cmd\n");
        system($cmd);
}