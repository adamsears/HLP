# 队列使用情况统计，划定比例和实际比例对比，柱状图
# 加载其他库
library(ggplot2)
library(RODBC)
library(RColorBrewer)
# 设置当前路径，在R终端用source()函数加载脚本时有用
#setwd("E:/CODE/r/queue_capacity_used")
# 重定向文本输出
sink("./queue_capacity_used.txt", append=TRUE, split=TRUE)
# 重定向图片输出
ppi=400
png("../img/queue_capacity_used_percent.png", width=12*ppi, height=6*ppi, units="px", pointsize=12, res=ppi)
# 创建数据库连接，需要安装mysql connector，在控制面板-管理工具-数据源中配置mysql odbc远程访问信息并下载R的RODBC库
dbConn <- odbcConnect("eht_hlp")
capacitySet <- as.matrix(sqlFetch(dbConn, "queue_capacity_set", rows_at_time=10, rownames=FALSE))
capacityUsed <- as.matrix(sqlFetch(dbConn, "queue_capacity_used", rows_at_time=10, rownames=FALSE))
close(dbConn)

# 计算两张表的宽度和长度，获取队列名
countSet <- length(dimnames(capacitySet)[[1]])
countUsed <- length(dimnames(capacityUsed)[[1]])
numQueueSet <- length(dimnames(capacitySet)[[2]])
numQueueUsed <- length(dimnames(capacityUsed)[[2]])
queueNames <- colnames(capacitySet)

# 将矩阵转成画图所需的数据框
dataFrameSet <- data.frame(Queue=queueNames, Percent=capacitySet[1,], Type="Set")
dataFrameUsed <- data.frame(Queue=queueNames,Percent=as.double(capacityUsed[countUsed,2:numQueueUsed]), Type="Used")
dataFrameAll <- rbind(dataFrameSet, dataFrameUsed)
rownames(dataFrameAll) <- NULL
# 画直方图
p <- ggplot(dataFrameAll,aes(x=Queue,y=Percent,fill=Type)) + geom_bar(stat="identity", position="dodge")
# 在图片上加上具体比例数值
p <- p + geom_text(aes(label=Percent),position=position_dodge(0.9),size=4,vjust=1.5)
# 加图片标题,并修改字体
p <- p + ggtitle("各队列预设资源与实际使用资源对比") + theme(plot.title=element_text(size=rel(1.5),face="bold"))
# 修改横纵坐标轴标签及格式
p <- p + xlab("队列") + ylab("资\n源\n使\n用\n占\n总\n使\n用\n量\n比\n例\n(%)") + theme(axis.title=element_text(face="bold",size=15), axis.title.y=element_text(angle=0) )
# 坐标字体调整
p <- p + theme(axis.text = element_text(hjust=1,vjust=1,face="bold",color="grey20"), axis.text.x = element_text(angle=30))
# 调整右侧标签显示的文字，移除标题
p <- p + scale_fill_discrete(labels=c("设定比例","实际比例")) + guides(fill=guide_legend(title=NULL))
# 输出图片
p

# 准备队列使用趋势折线图的数据
png("../img/queue_capacity_used_tendency.png", width=12*ppi, height=6*ppi, units="px", pointsize=12, res=ppi)
capacityUsedTendency <- data.frame()
for( index in 1:countUsed ){
	newDataFrame <- data.frame(Time=capacityUsed[index,1],Queue=queueNames,Percent=as.double(capacityUsed[index,2:numQueueUsed]))
	capacityUsedTendency <- rbind(capacityUsedTendency,newDataFrame)
}

# 画折线图,声明颜色通过Queue来区分，将线条适当加粗
p <- ggplot(capacityUsedTendency,aes(x=Time,y=Percent,group=Queue,colour=Queue)) + geom_line(linetype="solid", size=1.2) + geom_point(size=3)
# 设定每个队列的折线的颜色
queueColor <- brewer.pal(8,"Set2")
queueColor <- c(queueColor,"#56B4E9","#999999","darkseagreen3")
# 注意这里scale_colour_manual 和 scale_fill_manual的区别，后者是专门用来填充的
p <- p + scale_colour_manual(values=queueColor)
# 在图片上加上具体比例数值
p <- p + geom_text(aes(label=Percent),size=4,vjust=-0.2,hjust=-0.2)
# 加图片标题,并修改字体
p <- p + ggtitle("队列使用资源比例趋势图") + theme(plot.title=element_text(size=rel(1.5),face="bold"))
# 修改横纵坐标轴标签及格式
p <- p + xlab(NULL) + ylab("资\n源\n使\n用\n占\n总\n使\n用\n量\n比\n例\n(%)") + theme(axis.title.y=element_text(angle=0,face="bold",size=15))
# 坐标字体调整
p <- p + theme(axis.text = element_text(face="bold",color="grey20"))
# 修改右侧标签标题
p <- p + guides(colour=guide_legend(title="队列"))
# 输出图片
p
# 打印可能被隐藏的warning信息，如没有warning，将打印出null
warnings()
# 关闭图片和文本重定向，在R终端用source加载脚本时有用
dev.off()
sink()

# 这一段代码当初为了匹配簇状图的数据格式，手动转格式，现已找到更好的方法，所以废弃了，移到最下面
# 计算两张表的宽度和长度
#countSet <- length(dimnames(capacitySet)[[1]])
#countUsed <- length(dimnames(capacityUsed)[[1]])
#numQueueSet <- length(dimnames(capacitySet)[[2]])
#numQueueUsed <- length(dimnames(capacityUsed)[[2]])
# 将设定值和最新的实际值重新组成一个数据框
#data <- data.frame(Queue=dimnames(capacitySet)[[2]], Set=capacitySet[1,], Used=capacityUsed[countUsed,2:numQueueUsed)
#dataFrameUsed <- data.frame(Queue=dimnames(capacityUsed)[[2]][2:numQueueUsed],Percent=capacityUsed[countUsed,2:numQueueUsed],Type="Used")
# 注意这里有个坑，c(1:3)表示1,2,3，c(1:3-1)表示0,1,2，c(1:(3-1))表示1,2
# dimnames(a)[[1]] 几乎等于 rownames(a)，请参照help(dimnames)
#rownames(dataFrameUsed) <- c(2:numQueueUsed-1)
#dataFrameSet <- data.frame(Queue=dimnames(capacitySet)[[2]],Percent=capacitySet[1,],Type="Set")
#rownames(dataFrameSet) <- c(numQueueUsed:(numQueueSet+numQueueUsed-1))
# 画出簇状条形图
#ggplot(dataCompare,aes(x=Queue,y=Percent,fill=Type)) + geom_bar(stat="identity", position="dodge")
#ggplot(dataCompare,aes(Percent)) + geom_bar()