${HADOOP_HOME}/bin/hadoop jar /home/hadoop/hadoop-2.3.0-cdh5.0.0/share/hadoop/tools/lib/hadoop-streaming-2.3.0-cdh5.0.0.jar  \
-files ../jhist_mapper.pl,../jhist_reducer.pl \
-Dmapred.job.name="2_jhist_ext_yaxu_test" \
 -input /mr-history/done/2014/07/18/000000/*.jhist,/mr-history/done/2014/07/19/000000/*.jhist,/mr-history/done/2014/07/20/000000/*.jhist,/mr-history/done/2014/07/21/000000/*.jhist,/mr-history/done/2014/07/22/000000/*.jhist,/mr-history/done/2014/07/23/000000/*.jhist,/mr-history/done/2014/07/24/000000/*.jhist  \
 -output /mr-history/log-analysis/201407/0718-0724/2_jhist_ext_out_test  \
 -mapper "perl jhist_mapper.pl"  \
 -reducer "perl jhist_reducer.pl"
