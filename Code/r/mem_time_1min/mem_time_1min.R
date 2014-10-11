# 队列内存占用实时统计，面积堆积图
# 加载其他库
library(ggplot2)
library(RODBC)
library(RColorBrewer)
# 设置当前路径，在R终端用source()函数加载脚本时有用
#setwd("E:/CODE/r/mem_time_1min")
# 重定向文本输出
sink("./mem_time_1min.txt", append=TRUE, split=TRUE)
# 重定向图片输出
ppi=400
png("../img/mem_time_1min.png", width=12*ppi, height=6*ppi, units="px", pointsize=12, res=ppi)
# 创建数据库连接，需要安装mysql connector，在控制面板-管理工具-数据源中配置mysql odbc远程访问信息并下载R的RODBC库
dbConn <- odbcConnect("eht_hlp")
data <- sqlFetch(dbConn, "mem_time_1min",rows_at_time=10, rownames=FALSE)
close(dbConn)
colnames <- dimnames(data)[[2]]
time <- c()
queue <- c()
memory <- c()
format <- "%Y-%m-%d %H:%M:%S"
for( rowIndex in c(1:length(data[,1])) ){
#for( rowIndex in c(1:3) ){
	for( colIndex in c(2:length(colnames)) ){
		#print (as.character(data[rowIndex,1],format))
		#die
		#time <- c(time,as.character(data[rowIndex,1],format))
		#time <- c(time,as.POSIXlt(data[rowIndex,1]))
		#time <- c(time,as.Date(data[rowIndex,1]))
		#time <- c(time,format(data[rowIndex,1],format))
		#print(data[rowIndex,1])
		#print (format(data[rowIndex,1],format))
		time <- c(time,data[rowIndex,1])
		#data$timestamp[rowIndex] <- as.Date(data$timestamp[rowIndex])
		queue <- c(queue,colnames[colIndex])
		memory <- c(memory,data[rowIndex,colIndex])
	}
}
class(time) <- c('POSIXt','POSIXct')
dataConvert <- data.frame(time,queue, memory)

#p <- ggplot(data,aes(timestamp,y=asr_dictt))+geom_line()
#datebreaks <- seq(as.Date(data[1,1]), as.Date(data[length(data[,1]),1]), by="2 month")
#p + scale_x_date(breaks=datebreaks) + theme(axis.text.x = element_text(angle=30,hjust=1))
#dataConvert

# 输出堆积图
p <- ggplot(dataConvert, aes(x=time,y=memory,fill=queue)) + geom_area()
# 修改分类堆积图例颜色
queueColor <- brewer.pal(8,"Set2")
queueColor <- c(queueColor,"#56B4E9","#999999","darkseagreen3")
p <- p + scale_fill_manual(values=queueColor)
# 加分类标题，并修改字体
p <- p + labs(fill="队列") + theme(legend.title=element_text(size=18))
# 加图片标题,并修改字体
p <- p + ggtitle("各队列实时内存使用情况") + theme(plot.title=element_text(size=rel(1.5),face="bold"))
# 移除横坐标轴标签
p <- p + theme(axis.title.x=element_blank())
# 将纵坐标轴标签调正,修改纵坐标轴文字
p <- p + ylab("内\n存\n使\n用\n总\n量\n(GB)") + theme(axis.title.y=element_text(angle=0,face="bold",size=15))
# 坐标字体调整
p <- p + theme(axis.text = element_text(hjust=1,vjust=1,face="bold",color="grey20"), axis.text.x = element_text(angle=30))
p
# 打印可能被隐藏的warning信息，如没有warning，将打印出null
warnings()
# 关闭图片和文本重定向，在R终端用source加载脚本时有用
dev.off()
sink()