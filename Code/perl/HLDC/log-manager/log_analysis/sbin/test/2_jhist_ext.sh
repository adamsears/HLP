${HADOOP_HOME}/bin/hadoop jar /home/hadoop/hadoop-2.2.0/share/hadoop/tools/lib/hadoop-streaming-2.2.0.jar  \
-files ../bin/jhist_mapper.pl,../bin/jhist_reducer.pl \
-Dmapred.job.name="2_jhist_ext_yaxu" \
 -input /logfile/jhist0706/*  \
 -output /yaxu/2_jhist_ext_out/  \
 -mapper "perl jhist_mapper.pl"  \
 -reducer "perl jhist_reducer.pl"
