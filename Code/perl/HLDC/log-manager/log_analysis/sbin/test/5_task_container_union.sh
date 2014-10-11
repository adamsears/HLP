${HADOOP_HOME}/bin/hadoop jar /home/hadoop/hadoop-2.2.0/share/hadoop/tools/lib/hadoop-streaming-2.2.0.jar  \
-files ../bin/task_mapper.pl,../bin/task_reducer.pl  \
-Dmapred.job.name="5_task_ctn_union_yaxu" \
-input /yaxu/4_jhist_mem_union_out/   \
-output /yaxu/5_task_ctn_union_out/   \
-mapper "perl task_mapper.pl" \
-reducer "perl task_reducer.pl"
