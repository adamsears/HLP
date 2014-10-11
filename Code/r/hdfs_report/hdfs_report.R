# HDFS使用情况统计，近几周的变化趋势，折线图
# 加载其他库
library(ggplot2)
library(RODBC)
library(RColorBrewer)
# 设置当前路径，在R终端用source()函数加载脚本时有用
#setwd("E:/CODE/r/hdfs_report")
# 重定向文本输出
sink("./hdfs_report.txt", append=TRUE, split=TRUE)
# 设定图片清晰度
ppi=400
# 创建数据库连接，需要安装mysql connector，在控制面板-管理工具-数据源中配置mysql odbc远程访问信息并下载R的RODBC库
dbConn <- odbcConnect("eht_hlp")
oriData <- sqlFetch(dbConn, "hdfs_report", rows_at_time=10, rownames=FALSE)
close(dbConn)

# 准备队列使用趋势折线图的数据
dataFrameUsed <- data.frame(Time=oriData$timestamp,Type="HDFS使用容量",Percent=round(as.double(oriData$used_hdfs_ratio),1))
#dataFrameNon <- data.frame(Time=oriData$timestamp,Type="非HDFS使用容量",Percent=round(as.double(oriData$non_hdfs_ratio),1))
#dataFrameRemain <- data.frame(Time=oriData$timestamp,Type="HDFS剩余容量",Percent=round(as.double(oriData$remain_hdfs_ratio),1))
#dataFrameAll <- rbind(dataFrameUsed,dataFrameNon,dataFrameRemain)

# 画折线图,声明颜色通过Queue来区分，将线条适当加粗
p <- ggplot(dataFrameUsed,aes(x=Time,y=Percent)) + geom_line(linetype="solid", size=1.2, colour="deepskyblue2") + geom_point(size=3,colour="darkgreen")
# 使用主题，隐去后面框线
p <- p + theme_bw()
# 在图片上加上具体比例数值
p <- p + geom_text(aes(label=Percent),size=4,vjust=-0.5)
# 加图片标题,并修改字体
p <- p + ggtitle("HDFS使用量统计趋势图") + theme(plot.title=element_text(size=rel(1.5),face="bold"))
# 修改横纵坐标轴标签及格式
p <- p + xlab(NULL) + ylab("占\n总\n存\n储\n量\n百\n分\n比\n(%)") + theme(axis.title.y=element_text(angle=0,face="bold",size=15))
# 坐标字体调整
p <- p + theme(axis.text = element_text(face="bold",color="grey20"))
# 重定向图片输出
png("../img/hdfs_report.png", width=12*ppi, height=6*ppi, units="px", pointsize=12, res=ppi)
# 输出图片
p
# 打印可能被隐藏的warning信息，如没有warning，将打印出null
warnings()
# 关闭图片和文本重定向，在R终端用source加载脚本时有用
dev.off()
sink()