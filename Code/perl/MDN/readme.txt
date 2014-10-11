该阶段为使用Perl将数据库中的分析数据利用标记替换的方式替换MarkDown中的数据。

目前的替换标记有:
1、MARK_CLUSTER ：集群整体使用情况 AVG、MAX；包含项为CPU、LOAD、MEM、HDFS、NET IN、NET OUT。目前收集方式为手动，自动可行，需要大量收集各项参数。
2、MARK_HDFS ：集群HDFS使用趋势的数据，包含近几周的具体信息，可供画出对应的HDFS使用情况，直观地反映数据盘使用情况
3、MARK_JYMR ：集群任务基本运行情况统计，包含任务级别：JOB和REDUCE，TASK级别：MAP和REDUCE。
4、MARK_TIMERATIO1 ：MAP、REDUCE层面的执行时间分析。（可查看任务占用情况）
5、MARK_TIMERATIO2 ：JOB层面的执行时间分析。
6、MARK_QUEUERATIO ：队列使用占比统计数据，反映各队列相对占用资源的比例情况。（对和）
7、MARK_MAPTOTAL ：
8、MARK_REDUCETOTAL ：
9、MARK_MAPSET ：
10、MARK_REDUCESET ：
11、MARK_USERTASK ：
12、MARK_USERTIME ：
13、MARK_USERHDFS ：
14、MARK_USERWAIT ：
15、MARK_USERWSET ：