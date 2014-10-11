${HADOOP_HOME}/bin/hadoop jar /home/hadoop/hadoop-2.3.0-cdh5.0.0/share/hadoop/tools/lib/hadoop-streaming-2.3.0-cdh5.0.0.jar  \
-files ./bin/analysis_mapper.pl,./bin/analysis_reducer.pl  \
-Dmapred.job.name="7_analysis_mr_mem_yaxu" \
-input /mr-history/log-analysis/201408/0811-0817/5_task_ctn_union_out/    \
-output /mr-history/log-analysis/201408/0811-0817/7_analysis_mr_mem_out/   \
-mapper "perl analysis_mapper.pl" \
-reducer "perl analysis_reducer.pl"
