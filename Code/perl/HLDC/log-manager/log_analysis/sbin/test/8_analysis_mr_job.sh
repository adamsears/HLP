${HADOOP_HOME}/bin/hadoop jar /home/hadoop/hadoop-2.2.0/share/hadoop/tools/lib/hadoop-streaming-2.2.0.jar  \
-files ../bin/analysis_job_name_mapper.pl,../bin/analysis_job_name_redcuer.pl  \
-Dmapred.job.name="8_analysis_mr_job_yaxu" \
-input /yaxu/3_jobsum_ext_out/    \
-output /yaxu/8_analysis_mr_job_out/   \
-mapper "perl analysis_job_name_mapper.pl" \
-reducer "perl analysis_job_name_redcuer.pl"
