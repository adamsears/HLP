${HADOOP_HOME}/bin/hadoop jar /home/hadoop/hadoop-2.2.0/share/hadoop/tools/lib/hadoop-streaming-2.2.0.jar  \
-files ../bin/cat_mapper.pl,../bin/get_container_max_reducer.pl  \
-Dmapred.job.name="1_mem_ext_yaxu" \
-input /*.tar.gz  \
-output /yaxu/1_mem_ext_out/  \
-mapper "perl cat_mapper.pl" \
-reducer "perl get_container_max_reducer.pl"
