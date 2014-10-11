${HADOOP_HOME}/bin/hadoop jar /home/hadoop/hadoop-2.2.0/share/hadoop/tools/lib/hadoop-streaming-2.2.0.jar  \
-files ../bin/union_ctn_jhi_mapper.pl,../bin/union_ctn_jhi_reducer.pl  \
-Dmapred.job.name="4_jhist_mem_union_yaxu" \
-input /yaxu/1_mem_ext_out/,/yaxu/2_jhist_ext_out/  \
-output /yaxu/4_jhist_mem_union_out/   \
-mapper "perl union_ctn_jhi_mapper.pl" \
-reducer "perl union_ctn_jhi_reducer.pl"