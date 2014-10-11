#!/usr/bin/perl

use DBI;
my $dsn = "DBI:mysql:database=eht_hlp;host=localhost";
my $user = 'root';
my $password = '';

my $dbh = DBI->connect($dsn,$user,$password);       #连接数据库

my($sth,@ary);
my @need_ch_appid;

$sth = $dbh->prepare("select appid from b_job_info where resourcespermap = 1536");
$sth->execute();
while(@ary = $sth->fetchrow_array()){
	push @need_ch_appid,$ary[0];
}
$sth->finish;

foreach my $appid(@need_ch_appid){
	my $sth = $dbh->prepare("update b_ctn_mem set pmemset=1.5 where b_ctn_mem.appid = '$appid' and b_ctn_mem.pmemset = 2"); 
	$sth->execute();
}

$dbh->disconnect;
