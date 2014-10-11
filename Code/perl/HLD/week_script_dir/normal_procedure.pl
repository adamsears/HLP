#!/usr/bin/perl

use DBI;
my $dsn = "DBI:mysql:database=eht_hlp;host=localhost";
my $user = 'root';
my $password = '';

my $dbh = DBI->connect($dsn,$user,$password);       #连接数据库

#use view to insert data to l_union_tc

my $rv = $dbh->do("INSERT INTO l_union_tc SELECT * FROM v_tcm");
print "l_union_tc completed! $rv \n";

my $rv = $dbh->do("insert into l_union_unique select l_union_tc.* from (select task_id,max(pmemused) as pmemused from l_union_tc where taskstatus = 'SUCCEEDED' group by task_id) as ta join l_union_tc on ta.task_id = l_union_tc.task_id and ta.pmemused = l_union_tc.pmemused");
print "insert SUCCEEDED into l_union_unique completed! $rv \n";

my $rv = $dbh->do("insert ignore into l_union_unique select l_union_tc.* from (select task_id,max(pmemused) as pmemused from l_union_tc where taskstatus <> 'SUCCEEDED' group by task_id) as ta join l_union_tc on ta.task_id = l_union_tc.task_id and ta.pmemused = l_union_tc.pmemused");
print "insert non SUCCEEDED into l_union_unique completed! $rv \n";

my $rv = $dbh->do("insert into l_union_queue select * from v_unique_queue");
print "insert l_union_queue $rv \n";

$dbh->disconnect;                                #断开
