<h1 align="center"><b>训练平台集群运行周报<b/></h1>



<p align="right"><b>2014/9/15-2014/9/21</b></p>

## 一、	硬件层面运行统计

### 1.	硬件资源概览 


<p align="center"><b>表1.1 Hadoop2平台资源总体概览</b></p>


|节点类型|NameNode|DataNode|ResourceManager|Develop|Monitor|
|:--------:|:--------:|:--------:|:--------:|:--------:|:------:|
|**节点数量**|2|107|1|7|1|
</div>


表1.1是Hadoop2集群现有的硬件节点分布统计，目前共有节点118个。其中：<font color="red"><b>DataNode</b></font>提供HDFS存储与计算服务；<font color="red"><b>NameNode</b></font>采用HA主热备切换技术，保证NameNode的安全性，<font color="red"><b>ResorceManager</b></font>对集群计算资源进行统一管理与调配；<font color="red"><b>DevelopNode</b></font>为开发机用于用户提交计算任务；<font color="red"><b>Monitor</b></font>为监控节点，采用Nagios与Ganglia结合的方式，监控所有节点的运行状况，另外该节点也作为日志分析的主要节点。

<p align="center"><b>表1.2 计算节点资源信息统计</b></p>

<table cellspacing="0" cellpadding="0" style="border:1px solid #ccc"> 
<tr> 
<td> </td> 
<td colspan="3" align="center" ><b/>CPU</td><td colspan="3" align="center" ><b/>内存</td> <td colspan="4" align="center"><b/>硬盘</td>
</tr> 
<tr> 
<td align="center"><b/>型号</td><td align="center"><b/>逻辑核</td><td align="center"><b/>超线程</td><td align="center"><b/>等价核</td><td align="center"><b/>总内存(GB)</td><td align="center"><b/>保留(GB)</td><td align="center"><b/>计算(GB)</td><td align="center"><b/>总量(PB)</td><td align="center"><b/>系统(TB)</td><td align="center"><b/>HDFS(PB)</td><td align="center"><b/>NON 
HDFS(TB)</td>
</tr> 
<tr> 
<td align="center">R710</td>
<td align="center">304</td>
<td align="center">360</td>
<td align="center">332</td>
<td align="center">800</td>
<td align="center">148</td>
<td align="center">652</td>
<td align="center">0.43</td>
<td align="center">30</td>
<td rowspan="3" align="center">1.78</td>
<td rowspan="3" align="center">99</td>
</tr> 
<tr> 
<td align="center">R720</td> 
<td align="center">648</td> 
<td align="center">1296</td> 
<td align="center">972</td>
<td align="center">3712</td>
<td align="center">232</td> 
<td align="center">3480</td> 
<td align="center">1.434</td> 
<td align="center">34.8</td>
</tr> 
<tr> 
<td align="center">R720xd</td> 
<td align="center">144</td> 
<td align="center">288</td> 
<td align="center">216</td>
<td align="center">576</td>
<td align="center">36</td> 
<td align="center">540</td> 
<td align="center">0.35</td> 
<td align="center">5.4</td>
</tr>
<tr> 
<td align="center">合计</td> 
<td align="center">1096</td> 
<td align="center">1944</td> 
<td align="center">1520</td>
<td align="center">5088</td>
<td align="center">416</td> 
<td align="center">4672</td> 
<td align="center">2.2</td> 
<td align="center">67</td>
<td align="center">1.78</td>
<td align="center">99</td>
</tr>
</table>

<font color="red"><b>注：由于集群存在异构性，分别统计各硬件资源情况</b></font>
<font color="red"><b>相关项解释：</b></font>

<font color="red"><b>CPU</b></font> ：<font color="red"><b>逻辑核</b></font>，CPU逻辑核心；<font color="red"><b>超线程</b></font>，CPU超频后虚拟核心，R710只有部分CPU可超频，R720、R720xd全部设置超频；<font color="red"><b>等价核</b></font>，CPU虽然超频但无法达到理论的两倍， Hadoop环境下相当于逻辑核*1.5。

<font color="red"><b>内存：总内存</b></font>，硬件实际内存；<font color="red"><b>保留内存</b></font>，分配给系统使用内存以及未加入计算的内存；<font color="red"><b>计算内存</b></font>，平台可提供的计算内存量。

<font color="red"><b>硬盘：总量</b></font>，计算节点所有硬盘容量总和；<font color="red"><b>系统</b></font>，由稳定、高转速磁盘组成的系统盘；<font color="red"><b>HDFS</b></font>，由企业级硬盘组成的HDFS存储磁盘容量；<font color="red"><b>NON HDFS</b></font>，存储磁盘中被Linux系统用于管理磁盘而划分出去的硬盘容量。   

### 2.	硬件资源使用情况

------------------------------------------------------------------------

<p align="center"><b>表1.3 资源使用情况统计</b></p>

<img align="right" src="./pic/cluster_usage_report_stars.png" style="border:1px solid black" width="400px" />

|**监控项**|**平均值**|**最大使用值**|
|:--------:|:--------:|:--------:|
|**CPU利用率**|47.40%|87.80%|
|**负载**|57.89%|136.63%|
|**内存使用率**|25.00%|33.33%|
|**HDFS使用率**|83.04%|85.16%|
|**网络入口负载**|10.25%|38.25%|
|**网络出口负载**|10.99%|38.92%|


图中硬件资源使用的极限蜘蛛图。其中，橙黄线是集群上周最大使用率的连线；绿线为集群上周平均使用率的连线。从图中我们可以看到集群各硬件资源使用情况，CPU、负载使用较高，内存实际使用平稳，HDFS资源使用率过高，网络可以满足目前的运行需求。

<font color="red"><b>注: 负载出现136.63%的解释，比值=实际load值/理论满负荷load值；除此之外的剩余项的最大可用百分比为100%。</b></font>

------------------------------------------------------------------------

<p align="center"><b>表1.4HDFS使用情况统计</b></p>

|**统计时刻**|**HDFS总量(TB)**|**HDFS使用量(TB)**|**非HDFS使用量(TB)**|**DFS 剩余量(TB)**|
|:------------:|:--------------:|:------------:|:--------------:|:------------:|
|2014-09-01 11:13:11	|1925.12	|1402.88 (73.10%)|98.86 (5.13%)|418.91 (21.77%)|
|2014-09-08 11:13:46	|1925.12	|1484.8 (76.53%)|98.54 (5.10%)|	355.22 (18.37%)|
|2014-09-15 11:13:56	|1925.12	|1515.52 (78.66%)|98.91 (5.14%)|311.63 (16.20%)|
|2014-09-22 10:57:40	|1822.72	|1515.52 (83.04%)|94.8	(5.20%)|214.19 (11.76%)|

<div align="center"><img src="./pic/hdfs_report.png" style="border:1px solid black"/></div>


<font color="red"><b>注：从目前HDFS的使用情况来说，已经连续几周处在较高水平，对部分用户的任务运行造成了一定的影响。为了增加HDFS资源，相关硬盘设备的采购正在流程处理中；另外，为保证HDFS资源合理使用，请集群使用人员及时删除HDFS中的临时数据。</b></font>

------------------------------------------------------------------------

## 二、	软件层面周运行统计

### 1.	任务运行分析

<p align="center"><b>表2.1 任务运行情况统计</b></p>

<table>
MARK_JYMR
</table>


<div align="center"><img src="./pic/mem_fail_percent_ggplot.png" style="border:1px solid black"/></div>

<font color="red"><b>注：OOM为因内存溢出而失败的情况</b></font>

<p align="center"><b>表2.2 Map-Reduce时间范围下的Task分布</b></p>

|时间范围|0~1min|1~5min|5~10min|10~30min|30~60min|>60min|
|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|
MARK_TIMERATIO1

<p align="center"><b>表2.3 JOB在执行时间范围下的任务数分布</b></p>

|时间范围|0~0.5h|0.5~1h|1~2h|2~4h|4~8h|>8h|
|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|
MARK_TIMERATIO2

<div align="center"><img src="./pic/time_ratio_ggplot_mapred.png" style="border:1px solid black" /></div>

<div align="center"><img src="./pic/time_ratio_ggplot_job.png" style="border:1px solid black" width="480px"/></div>


<font color="red"><b>MAP执行时间主要集中在5分钟以内;REDUCE则在分布较大，大部分集中在30分钟内；JOB大多数可以在半个小时内完成，但可以看到较长执行时间的也是存有一定的比例。另本周平均等待时间为5分03秒，等待时间超过两分钟以上的任务数为537个，占比10.6%，进一步观察统计可以看出仅jxzhu就有289个大于2分钟的等待，因此，我们统计了去除jxzhu的任务得出的周任务平均等待时间为<font color="blue"><b>39.63秒。</b></font></b></font>

### 2.	队列统计

------------------------------------------------------------------------

<p align="center"><img align="middle" src="./pic/mem_time_1min.png"  style="border:1px solid black"/></p>

<font color="red"><b>上图为上周各队列的实时内存使用情况分布，从图中，可以看出上周集群一直保持在高使用率的状态下,asr_dictt、asr_trans仍然为资源使用排名靠前的组别，eht上周任务有所增加。
综合分析，由于目前各组用户的训练任务都较以前有增加趋势，所以建议各组人员在使用本队列内部资源时，如果单用户高并发同时提交大量任务，请及时告知各自队列管理人员，以免影响组内其他用户的使用。</b></font>

<p align="center"><b>表2.4队列预划分与实际使用占比</b></p>

|队列名|asr_dictt|asr_trans|asr_embedrecog|call_edu|nlp|eht|sre|asr_embed|hw_tts|call_music|
|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|
|划分占比|31.0|20.0|6.0|4.0|6.0|6.0|6.0|6.0|12.0|3.0|
|20140825-0831|37.36|21.98|12.35|9.12|7.92|5.9|4.19|0.82|0.35|0.02|
|20140901-0907|51.54|5.89|25.39|4.3|0.46|8.39|0.57|1.13|2.33|0|
|20140908-0914|15.79|24.97|5.9|7.99|6.74|3.19|34.77|0.31|0.34|0|
|20140915-0921|39.27|26.53|5.77|3.99|6.51|10.99|4.06|2.38|0.02|0.47|

<font color="red"><b>注：本周最后几天调整新增的hw_only队列未纳入本次统计范围，将于下周开展相应统计。</b></font>


<p align="center"><img align="middle" src="./pic/queue_capacity_used_percent.png"  style="border:1px solid black"/></p>

<p align="center"><img align="middle" src="./pic/queue_capacity_used_tendency.png"  style="border:1px solid black"/></p>

<font color="red"><b>从几周的队列相对使用占比分析可以看出，总体预划分的比例是合理的。但各小组在不同时间段任务数量会随着其工作安排有变化，整体趋势上来看，asr_dictt一直保持较高的使用率；另外，我们在预设配比基础上开放了部分集群资源，以便在集群闲置状态下满足各小组的资源使用需求，同时也对早期预设的各队列超额使用比例进行了调整，具体可详见<a href="http://192.168.136.98:8088/cluster/scheduler">http://192.168.136.98:8088/cluster/scheduler</a>。</b></font>



### 3.	基于MAP-REDUCE的统计分析

------------------------------------------------------------------------

<p align="center"><b>表2.5 Map-Reduce内存使用占比统计</b></p>

<table>
<tr><th rowspan="6">MAP</th><th>内存分布</th><th>0~1GB</th><th>1~1.5GB</th><th>1.5~3GB</th><th>> 3GB</th><th>总计</th></tr>
MARK_MAPTOTAL
<tr><th rowspan="6">REDUCE</th><th>内存分布</th><th>0~2GB</th><th>2~3GB</th><th>3~4GB</th><th>> 4GB</th><th>总计</th></tr>
MARK_REDUCETOTAL
</table>

<p align="center"><b>表2.6实际设定内存下所有任务的MAP内存实际使用分布</b></p>

||0~1GB|1~1.5GB|1.5~2GB|>2GB|
|:--------:|:--------:|:--------:|:--------:|:--------:|
MARK_MAPSET

上表是实际任务设定的Map内存下，内存实际使用分布情况。其中，第一列为具体MAP设定的内存值，第一行为相应设定值下的分布范围。
下图为对应的分布直方图

<p align="center"><img align="middle" src="./pic/mem_set_analysis_map.png" style="border:1px solid black"/></p>


<p align="center"><b>表2.7实际设定内存下所有任务的REDUCE内存实际使用分布</b></p>

||0~2GB|2~3GB|3~4GB|>4GB|
|:--------:|:--------:|:--------:|:--------:|:--------:|
MARK_REDUCESET

上表是实际任务设定的REDUCE内存下，内存实际使用分布情况，下图为对应的分布直方图

<p align="center"><img align="middle" src="./pic/mem_set_analysis_reduce.png" style="border:1px solid black"/></p>

### 4.	用户信息

--------------------------------------------------------------

<p align="center"><img align="middle" src="./pic/user_queue_ratio.png" style="border:1px solid black"/></p>


上图是用户资源相对使用情况统计，图中我们可以看出用户一周内占用资源的比例情况，各队列管理人员可以根据通过查找组内人员，换算出组内各人员所占用的比例情况。

<p align="center"><b>表2.8任务运行总数</b></p>

|Top|用户|map-reduce总数|时间(h)|
|:--------:|:--------:|:--------:|:--------:|
MARK_USERTASK

<p align="center"><b>表2.9任务运行时间</b></p>
|Top|用户|map-reduce总数|时间(h)|
|:--------:|:--------:|:--------:|:--------:|
MARK_USERTIME

<font color="red"><b>以上两表统计的是用户map/reduce的周运行总数及相应的资源耗时统计，目前对资源耗时统计进行调整，统计是：每个map/reduce执行时间。</b></font>

<p align="center"><b>表2.10 HDFS使用情况</b></p>

|Top|用户|总量|大小/目录|
|:--------:|:--------:|:--------:|:--------:|
|1|weiguo2|126.48 TB|117.81	TB/dasr 8.67 TB/gasr|
|2|taoyu|108.37 TB|33.09 TB/dasr 75.28 TB/gasr|
|3|lishang|	51.74 TB|6.71 TB/dasr 45.03	TB/dembed|
|4|lixu|39.89 TB|6.30 TB/dasr 33.59 TB/gasr|
|5|hadoop_89|32.19 TB|32.19	TB/geht|
|6|gbwu3|16.99 TB|16.99 TB/gasr|
|7|jfxu2|14.90 TB|3.82 TB/dasr 11.08 TB/gasr|
|8|jiapan|12.04 TB|10.96 TB/dasr 1.08 TB/gasr|
|9|cqkong|10.80 TB|9.14 TB/dasr1.66 TB/gasr|
|10|chaozhao|10.79 TB|10.44 TB/dcall 0.35 TB/gcall|


我们统计了等待时间较长的几位用户。<font color="red"><b>请超长等待用户关注下脚本中是否存在本地大数据量上传操作，或者自身队列资源较少的情况；如无请进一步与平台人员沟通。</b></font>

<p align="center"><b>表2.11 等待时间较长用户统计</b></p>

|用户|等待时间(分)|用户|等待时间(分)|
|:--------:|:--------:|:--------:|:--------:|
|jxzhu|77.46|cqkong|4.58|
|xiangzhang4|3.73|jenkins|3.63|
|skxu|2.82|yuanzhong|2.81|
|jwhu2|2.23|leifang|1.87|


<p align="center"><b>表2.12 错误配置内存的统计分析</b></p>

|TOP|用户|Map数|MAP资源使用耗时(小时)|Reduce数|Reduce资源使用耗时(小时)|错误配置资源总耗时(小时)|
|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|:--------:|
|1|jxzhu	|36066|	5835.88	|3601	|2048.82	|7884.70|
|2|cqkong|	43231	|4079.58	|114|	105.76	|4185.34|
|3|zheli	|13629	|3121.50	|205|	61.36	|3182.86|
|4|xiangzhang4	|72764|	1903.19|	8	|0.81	|1904.00|
|5|jenkins	|2946	|1738.98	|0|	0.00	|1738.98|
|6|ynsong|	1114|	1439.90	|0|	0.00	|1439.90|
|7|slyuan2|	360	|1388.95	|0	|0.00|	1388.95|
|8|junhuang	|5941|	681.24|	0	|0.00|	681.24|
|9|panzhou	|10835	|238.84	|270	|10.53	|249.37|
|10|jwhu2	|196|	203.59	|47|	0.46|	204.05|
|11|hflu	|1411	|117.24	|741	|70.63|	187.87|
|12|juesun	|4709	|151.89	|40	|5.57|	157.46|
|13|chaozhao|	153	|91.35|	0	|0.00	|91.35|
|14|jjli7	|1218	|70.38|	96	|18.79|	89.17|
|15|qungao|	155	|80.77	|0	|0.00	|80.77|
|16|htxing	|299	|77.07	|0	|0.00	|77.07|
|17|lixu	|198	|39.36|	385	|2.03|	41.39|
|18|jieding	|32	|10.39|	0	|0.00|	10.39|
|19|jfxu2	|896	|3.51	|0	|0.00	|3.51|
|20|kailiu3	|68	|1.67	|14|	0.35|	2.02|
|21|yjhu	|2	|0.06	|0|	0.00	|0.06|



<font color="red"><b>注：错误配置用户为未按照集群默认配置使用资源的用户（Map 1.5GB、Reduce 3GB），上表中出现的用户实际最大内存使用值小于自设的50%，另外，上表统计的为各用户错误配置的map、reduce数及其对应的资源耗时。请表2.9中的用户关注是否存在错误配置资源耗时占据各自总资源耗时比例较大的情况。
另外，本周我们开始向任务配置错误的用户开放了错误配置的具体信息，请上表中的用户点击下方链接下载表格，并结合实际任务情况予以适当调整，谢谢配合！</b></font>

<a href="./user_wrongset_for_user.xlsx">点击下载错误配置的明细</a>

<div align="center">网站主页:<a href="http://mtp.iflytek.cn">http://mtp.iflytek.cn</a></div>

<p align="center">&copy; 2014 训练平台 版权所有</p>