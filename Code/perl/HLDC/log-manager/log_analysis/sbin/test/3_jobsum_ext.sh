${HADOOP_HOME}/bin/hadoop jar /home/hadoop/hadoop-2.2.0/share/hadoop/tools/lib/hadoop-streaming-2.2.0.jar  \
-files ../bin/job_sum_mapper.pl  \
-Dmapred.job.name="3_jobsum_ext_yaxu" \
-input /logfile/mapred-hadoop*  \
-output /yaxu/3_jobsum_ext_out/  \
-mapper "perl job_sum_mapper.pl" 
