#!/usr/bin/perl -w
use lib "/usr/local/man/man3";

use strict;
use diagnostics;
use Encode;
use JSON;
use Data::Dumper;

#my $json = new JSON;
my $json = JSON->new->utf8;
my $json_obj;

while(<>){
		s/^Avro-Json//;
		my $a = $_;
		$a =~ s/^\s*$//g;	

		if($a ne ""){
    $json_obj = $json->decode("$a");
    my $type = $json_obj->{'type'};   
    
    #get TASK_STARTED info
#    if($type eq "TASK_STARTED"){
#    	my $taskid = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskStarted'}->{'taskid'};
#    
#    	my $taskType = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskStarted'}->{'taskType'};
#    	my $startTime = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskStarted'}->{'startTime'};
#    	my $splitLocations = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskStarted'}->{'splitLocations'};
#
#			print "$taskid\t$taskType\t$splitLocations\n";
#    	}
    
    #get TASK_FINISHED info
#    if($type eq "TASK_FINISHED"){
#    	    	
#    	my $taskid = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskFinished'}->{'taskid'};
#    	
#    	my $tmp = $taskid;
#    	$tmp =~ /task_(\d+_\d+)/;
#    	my $mainkey = $1;
#    	
#    	my $taskType = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskFinished'}->{'taskType'};
#    	my $finishTime = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskFinished'}->{'finishTime'};
#    	my $status = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskFinished'}->{'status'};
#    	my $successfulAttemptId = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskFinished'}->{'successfulAttemptId'};
#    	
#    	
#    	print "$mainkey\t"."TASK_FINISHED\t"."$taskid\t$taskType\t$successfulAttemptId\t$finishTime\t$status\n";
#    	
#    	}
    	
    #get TASK_FAILED info
#    if($type eq "TASK_FAILED"){
#    	    	
#    	my $taskid = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskFailed'}->{'taskid'};
#    	
#    	my $tmp = $taskid;
#    	$tmp =~ /task_(\d+_\d+)/;
#    	my $mainkey = $1;
#    	
#    	my $taskType = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskFailed'}->{'taskType'};
#    	my $finishTime = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskFailed'}->{'finishTime'};
# #   	my $error = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskFailed'}->{'error'};
#    	
#    	
#    	print "$mainkey\t"."TASK_FAILED\t"."$taskid\t$taskType\t$finishTime\n";
#    	
#    	}
      
    
    #get MAP_ATTEMPT_STARTED info
        
    if($type eq "MAP_ATTEMPT_STARTED"){
    	    	
    	my $taskid = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptStarted'}->{'taskid'};
    	
    	my $tmp = $taskid;
    	$tmp =~ /task_(\d+_\d+)/;
    	my $mainkey = $1;
    	
    	my $taskType = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptStarted'}->{'taskType'};
    	my $attemptId = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptStarted'}->{'attemptId'};
    	my $startTime = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptStarted'}->{'startTime'};
    	my $trackerName = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptStarted'}->{'trackerName'};
    	my $httpPort = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptStarted'}->{'httpPort'};
    	my $shufflePort = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptStarted'}->{'shufflePort'};
    	my $containerId = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptStarted'}->{'containerId'};
    	
    	
    	print "$taskid"." $attemptId\t"."STARTED\t"."$containerId\t$taskType\t$trackerName\n";
    	
    	}
    	
    #get MAP_ATTEMPT_FINISHED info
    if($type eq "MAP_ATTEMPT_FINISHED"){
    	    	
    	my $taskid = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.MapAttemptFinished'}->{'taskid'};
    	
    	my $tmp = $taskid;
    	$tmp =~ /task_(\d+_\d+)/;
    	my $mainkey = $1;
    	
    	my $taskType = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.MapAttemptFinished'}->{'taskType'};
    	my $attemptId = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.MapAttemptFinished'}->{'attemptId'};
    	my $taskStatus = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.MapAttemptFinished'}->{'taskStatus'};
    	my $mapFinishTime = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.MapAttemptFinished'}->{'mapFinishTime'};
    	my $finishTime = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.MapAttemptFinished'}->{'finishTime'};
    	my $hostname = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.MapAttemptFinished'}->{'hostname'};
    	my $port = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.MapAttemptFinished'}->{'port'};
    	my $rackname = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.MapAttemptFinished'}->{'rackname'};
    	my $state = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.MapAttemptFinished'}->{'state'};
    	
    	
    	print "$taskid"." $attemptId\t"."FINISHED\t"."$taskStatus\n";
    	
    	}
    	
    	
    #get MAP_ATTEMPT_KILLED
    if($type eq "MAP_ATTEMPT_KILLED"){
    	    	
    	my $taskid = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'taskid'};
    	
    	my $tmp = $taskid;
    	$tmp =~ /task_(\d+_\d+)/;
    	my $mainkey = $1;
    	
    	my $taskType = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'taskType'};
    	my $attemptId = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'attemptId'};
    	my $finishTime = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'finishTime'};
    	my $hostname = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'hostname'};
    	my $port = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'port'};
    	my $rackname = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'rackname'};
    	my $status = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'status'};
	#   	my $error = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'error'};
    	
    	
    	print "$taskid"." $attemptId\t"."KILLED\t"."$status\n";
    	
    	}
    	
    	
    #get MAP_ATTEMPT_FAILED
    if($type eq "MAP_ATTEMPT_FAILED"){
    	    	
    	my $taskid = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'taskid'};
    	
    	my $tmp = $taskid;
    	$tmp =~ /task_(\d+_\d+)/;
    	my $mainkey = $1;
    	
    	my $taskType = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'taskType'};
    	my $attemptId = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'attemptId'};
    	my $finishTime = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'finishTime'};
    	my $hostname = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'hostname'};
    	my $port = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'port'};
    	my $rackname = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'rackname'};
    	my $status = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'status'};
 #   	my $error = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'error'};
    	
    	
    	print "$taskid"." $attemptId\t"."KILLED\t"."$status\n";
    	
    	}
    
    
    #get REDUCE_ATTEMPT_STARTED info
        
    if($type eq "REDUCE_ATTEMPT_STARTED"){
    	    	
    	my $taskid = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptStarted'}->{'taskid'};
    	
    	my $tmp = $taskid;
    	$tmp =~ /task_(\d+_\d+)/;
    	my $mainkey = $1;
    	
    	my $taskType = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptStarted'}->{'taskType'};
    	my $attemptId = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptStarted'}->{'attemptId'};
    	my $startTime = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptStarted'}->{'startTime'};
    	my $trackerName = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptStarted'}->{'trackerName'};
    	my $httpPort = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptStarted'}->{'httpPort'};
    	my $shufflePort = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptStarted'}->{'shufflePort'};
    	my $containerId = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptStarted'}->{'containerId'};
    	
    	
    	print "$taskid"." $attemptId\t"."STARTED\t"."$containerId\t$taskType\t$trackerName\n";
    	
    	}
    	
    #get REDUCE_ATTEMPT_FINISHED
    if($type eq "REDUCE_ATTEMPT_FINISHED"){
    	    	
    	my $taskid = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.ReduceAttemptFinished'}->{'taskid'};
    	
    	my $tmp = $taskid;
    	$tmp =~ /task_(\d+_\d+)/;
    	my $mainkey = $1;
    	
    	my $taskType = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.ReduceAttemptFinished'}->{'taskType'};
    	my $attemptId = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.ReduceAttemptFinished'}->{'attemptId'};
    	my $taskStatus = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.ReduceAttemptFinished'}->{'taskStatus'};
    	my $shuffleFinishTime = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.ReduceAttemptFinished'}->{'shuffleFinishTime'};
    	my $sortFinishTime = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.ReduceAttemptFinished'}->{'sortFinishTime'};
    	my $finishTime = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.ReduceAttemptFinished'}->{'finishTime'};
    	my $hostname = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.ReduceAttemptFinished'}->{'hostname'};
    	my $port = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.ReduceAttemptFinished'}->{'port'};
    	my $rackname = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.ReduceAttemptFinished'}->{'rackname'};
    	my $state = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.ReduceAttemptFinished'}->{'state'};
    	
    	
    	print "$taskid"." $attemptId\t"."FINISHED\t"."$taskStatus\n";
    	
    	}
    	
    	
    #get REDUCE_ATTEMPT_FAILED
    if($type eq "REDUCE_ATTEMPT_FAILED"){
    	    	
    	my $taskid = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'taskid'};
    	
    	my $tmp = $taskid;
    	$tmp =~ /task_(\d+_\d+)/;
    	my $mainkey = $1;
    	
    	my $taskType = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'taskType'};
    	my $attemptId = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'attemptId'};
    	my $finishTime = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'finishTime'};
    	my $hostname = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'hostname'};
    	my $port = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'port'};
    	my $rackname = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'rackname'};
    	my $status = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'status'};
#    	my $error = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'error'};
    	
    	
    	print "$taskid"." $attemptId\t"."FAILED\t"."$status\n";
    	
    	}
    	
    	
     #get REDUCE_ATTEMPT_KILLED
    if($type eq "REDUCE_ATTEMPT_KILLED"){
    	    	
    	my $taskid = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'taskid'};
    	
    	my $tmp = $taskid;
    	$tmp =~ /task_(\d+_\d+)/;
    	my $mainkey = $1;
    	
    	my $taskType = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'taskType'};
    	my $attemptId = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'attemptId'};
    	my $finishTime = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'finishTime'};
    	my $hostname = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'hostname'};
    	my $port = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'port'};
    	my $rackname = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'rackname'};
    	my $status = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'status'};
 #   	my $error = $json_obj->{'event'}->{'org.apache.hadoop.mapreduce.jobhistory.TaskAttemptUnsuccessfulCompletion'}->{'error'};
    	
    	
    	print "$taskid"." $attemptId\t"."KILLED\t"."$status\n";
    	
    	}
	}
  }
