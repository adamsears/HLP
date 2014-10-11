#!/usr/bin/perl
use strict;

my $valid_hosts = "/home/hadoop/hadoop2/etc/hadoop/slaves";
my @hosts = ();
my $line;
print "\nload valid hosts ...\n";
  open INPUT, "<$valid_hosts";
  while($line = <INPUT>){
    chomp($line);
    $line =~ s/\s+//g;
    next if($line eq "" || $line=~/^#/);
    push @hosts, $line;
  }
close INPUT;

foreach my $host(@hosts){
	print "$host\n";
	&PR("scp JSON-2.90.tar.gz deploy_JSON.sh $host:~/");
	&PR("ssh $host sh deploy_JSON.sh");
	&PR("ssh $host rm deploy_JSON.sh");
}

sub PR{
	my ($cmd) = @_;
	print ("$cmd\n");
	system($cmd);
}
