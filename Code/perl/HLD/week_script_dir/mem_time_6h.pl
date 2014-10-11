#!/usr/bin/perl
use DBI;
my $dsn = "DBI:mysql:database=eht_hlp;host=localhost";
my $user = 'root';
my $password = '';

my $dbh = DBI->connect($dsn,$user,$password);       #è¿~^?N¥æ~U°æ~M.?S

my $time_start= 1409500800;
my $interval1= 21600;
my $time_end = 1409500800+604800;
my $interval2 = 1800;

for(my $stamp = $time_start+$interval1;$stamp <= $time_end;$stamp += $interval1 ){
	my $end = $stamp+$interval;
    
	my ($sth,@ary);
	$sth = $dbh->prepare("SELECT sum(asr_dictt)/count(*),sum(asr_embed)/count(*),sum(asr_embedrecog)/count(*),sum(asr_trans)/count(*),sum(call_edu)/count(*),sum(call_music)/count(*),sum(eht)/count(*),sum(hw_tts)/count(*),sum(nlp)/count(*),sum(sre)/count(*) FROM mem_time_1min where `timestamp` >= $stamp and `timestamp` <= $end");   #
	$sth->execute();
	my $split;
	while(@ary = $sth->fetchrow_array()){
                       $split = join("\t",@ary);                     
        }                                                #?I~S?M°æ~J½å~O~Vç»~S?^~\
	$sth->finish;
	#print "$split\n";
	my @sum_6h = split(/\t/,$split);
print $sum_6h[0]."\t".$sum_6h[1]."\t".$sum_6h[2]."\t".$sum_6h[3]."\t".$sum_6h[4]."\t".$sum_6h[5]."\t".$sum_6h[6]."\t".$sum_6h[7]."\t".$sum_6h[8]."\t".$sum_6h[9]."\n";
	foreach my $tmp(@sum_6h){
		#print "$tmp[0]\n";
	}
    my $rv = $dbh->do("INSERT INTO mem_time_6h values ($end,$sum_6h[0],$sum_6h[1],$sum_6h[2],$sum_6h[3],$sum_6h[4],$sum_6h[5],$sum_6h[6],$sum_6h[7],$sum_6h[8],$sum_6h[9])");
    print "$rv\n";
}
print "mem_time_1min done!\n";

$dbh->disconnect;

