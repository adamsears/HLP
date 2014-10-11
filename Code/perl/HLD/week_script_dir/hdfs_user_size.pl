#!/usr/bin/perl

use DBI;
my $dsn = "DBI:mysql:database=eht_hlp;host=localhost";
my $user = 'root';
my $password = '';

my $dbh = DBI->connect($dsn,$user,$password);

my @root_contents = `hdfs dfs -ls / `;
my @first_dirs;
my @output;
foreach my $tmp(@root_contents){
        print $tmp."\n";
}

foreach my $root_content(@root_contents){
      chomp($root_content);
      next if($root_content =~ /^Found/);
	next if($root_content !~ /\/[d|g]/);
      $root_content =~ /(\/[d|g]\w+)/;
      my $root_dir = $1;
     print $root_dir."\n";
      push @first_dirs,$root_dir;
}

foreach my $first_dir(@first_dirs){
	chomp($first_dir);
	my @user_sizes = `hdfs dfs -du -s $first_dir/*`;
	foreach my $tmp(@user_sizes){
		chomp($tmp);
		#print $tmp."\n";
		$tmp =~ /(\d+)\s+(\/\w+)\/(\w+)/;
		my $size = $1;
		my $dir = $2;
		my $user = $3;
		my $line = $user."\t".$size."\t".$dir;
		print $line."\n";
		my $rv = $dbh->do("INSERT INTO b_user_hdfs_size values('$user',$size,'$dir')");
		print "user_hdfs_size(Bytes) inserted! $rv \n";
		#push @output,$line;
	}
	#my @second_contents = `hdfs dfs -ls $first_dir`;
#	foreach my $second_content(@second_contents){
#		chomp($second_content);
 #    		next if($second_content =~ /^Found/);
  #    		$second_content =~ /(\/\w+\/\w+)/;
   #   		my $next_dir = $1;
#		print $next_dir."\n";
#		`hdfs dfs -du -s -h $next_dir`;
#	}	
	
}
$dbh->disconnect;
