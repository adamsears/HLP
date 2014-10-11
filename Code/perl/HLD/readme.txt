This folder include all of the scripts of hadoop_log_database sequences.

注：第一次建立数据库需要建立两个视图：v_union_tcm、v_unique_queue

#我们将脚本分成周和天两种数据库处理脚本

目前开放使用的是周数据库处理脚本

现在看到的是数据库处理脚本模块化的处理方式，每次处理执行/week_script_dir/procedure.pl即可
各模块包括有：
1、week_table_rename.pl
将所有需要回滚的数据表进行日期回滚操作

2、datbase_new_table.pl
此处用于生成新的因回滚缺失的数据表

3、Load_data.pl
将最基本的HDFS数据过滤后的数据批量导入数据库；涉及3张表，b_ctn_mem、b_task_ctn、b_job_info;

4、update_bctnmem.pl
由于Hadoop自身存在设定值自动取整，会导致目前的配置中设置1.5被转化为2。在完成基本数据导入后首先完成对该bug的修正工作；

5、normal_procedure.pl
完成基本数据的数据关联处理，以便后续进行数据分析

6、anaylsis_data.pl
基本的数据分析。包含：
	1）任务总览统计（main_jymr）
	2）
	
	
7、hdfs_user_size.pl
采集用户/d、/g下的真实数据大小

8、user_job_maxset.pl
用于统计每个任务下最大的用户map、reduce内存使用值，资源耗时

9、frequency.pl
周采样脚本，从上周一凌晨开始至周末结束，包含各时间下用户的资源使用情况

10、frequency_mem_time.pl
统计各采样时间点下的数据，并转化为datetime进行存储

11、frequency_insert.pl
插入各队列的实际使用情况。
