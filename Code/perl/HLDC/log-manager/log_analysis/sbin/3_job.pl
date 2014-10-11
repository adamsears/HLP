#!/usr/bin/perl
use strict;
sub PR{
                my ($cmd) = @_;
                print ("$cmd\n");
                system($cmd);
        }
#========3======run jobsummary extract hadoop streaming==================================
        print "========3======run jobsummary extract hadoop streaming===============\n";
        #check input file if exist      

                        my $jobsum_mapred_flie = "../bin/job_sum_mapper.pl";
                                my $jobsum_ext_yaxu_3 = "3_jobsum_ext_yaxu";
                                        my $jobsum_input_dir = "/mr-history/local-service-log/201408/20140801*.tar.gz,/mr-history/local-service-log/201408/20140804*.tar.gz";
                                               my $cmd = "hadoop jar /home/hadoop/hadoop-2.3.0-cdh5.0.0/share/hadoop/tools/lib/hadoop-streaming-2.3.0-cdh5.0.0.jar "
                                                                                ."-files $jobsum_mapred_flie "
                                                                                                                ."-Dmapred.job.name=$jobsum_ext_yaxu_3 "
                                                                                                                                                ."-mapper \"perl job_sum_mapper.pl\" "
                                                                                                                                                                                ."-input $jobsum_input_dir "
                                                                                                                                                                                                                ."-output /mr-history/log-analysis/201408/0725-0803/3_jobsum_ext_out/ ";

                                                                                                                                                                                                                        &PR($cmd);
                                                                                                                                                                                                                                print "=====================================================================\n";

