# 集群资源使用总体情况雷达图
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
oriData <- sqlFetch(dbConn, "cluster_usage_report", rows_at_time=10, rownames=FALSE)
close(dbConn)
# 将最后一行复制一遍
dataGgplotMatrix <- rbind(oriData,oriData[6,])
# 再将不同的统计项改为序号，最后复制的一个是0，这样画图时可以首尾衔接
dataGgplotMatrix[,1] <- c(1,2,3,4,5,6,0)
# 将百分比转化成double型并取小数点后一位
dataGgplotMatrix$ave_usage <- round(as.double(dataGgplotMatrix$ave_usage),1)
dataGgplotMatrix$max_usage <- round(as.double(dataGgplotMatrix$max_usage),1)
# 将矩阵转化成数据框
dataGgplotFrame <- data.frame(Index=dataGgplotMatrix[,1],Percent=dataGgplotMatrix$ave_usage,Type="平均值")
dataGgplotFrame <- rbind(dataGgplotFrame,data.frame(Index=dataGgplotMatrix[,1],Percent=dataGgplotMatrix$max_usage,Type="峰值"))
# 使用默认行号
rownames(dataGgplotFrame) <- NULL
# 画折线图,声明颜色通过Queue来区分，将线条适当加粗
p <- ggplot(dataGgplotFrame,aes(x=Index,y=Percent,group=Type,colour=Type)) + geom_line(linetype="solid", size=1.2) + geom_point(size=3)
# 再将柱状图按x轴卷曲成极坐标图
p <- p + coord_polar("x")
# 在图片上加上具体比例数值，设置为只显示50%以上的标签
dataLabel <- dataGgplotFrame$Percent
dataLabel[ dataLabel < 50 ] <- NA
p <- p + geom_text(aes(label=dataLabel),size=3,vjust=-1,colour="black")
# 加图片标题,并修改字体
p <- p + ggtitle("集群资源使用总体情况雷达图") + theme(plot.title=element_text(size=rel(1.5),face="bold"))
# 修改横纵坐标轴标签及格式
p <- p + xlab(NULL) + ylab(NULL)
# 修改横坐标轴刻度,由于多了一个0分类，所以最好指定下坐标轴分割范围，就如后一种方法，前一种方法会多出一栏
target <- c("CPU","负载","内存","磁盘","网络传入","网络传出")
#p <- p + scale_x_discrete(labels=target)
p <- p + scale_x_continuous(breaks=dataGgplotMatrix[,1][1:6],labels=target)
# 修改y轴刻度分割标准
p <- p + scale_y_continuous(breaks=as.double(seq(0,100,10)))
# 坐标字体调整
p <- p + theme(axis.text = element_text(face="bold",color="grey20"))
# 重定向图片输出
png("../img/cluster_usage_report_ggplot.png", width=6*ppi, height=6*ppi, units="px", pointsize=12, res=ppi)
# 输出图片
p

# 改用R语言自带的stars函数来绘制
# 重定向图片输出
png("../img/cluster_usage_report_stars.png", width=7*ppi, height=6*ppi, units="px", pointsize=12, res=ppi)
# 将原数据转置
dataNormalMatrix <- t(oriData[,2:3])
# 去除行名，否则最终图中会出现重叠的行名，还不如到时候自定义右边栏标签
colnames(dataNormalMatrix) <- c("1","2","3","4","5","6")
rownames(dataNormalMatrix) <- NULL
# 设定几个六边形的中心位置
location <- matrix(rep(0,8),nrow=4,ncol=2)
# 绘制框架线，从外层往里层绘制，因为要一开始定好图形大小基调，否从小到大画会超出绘图区
# 在部分数据超出100%的情况下，添加最外层线
# 计算最外层的线的半径,以50%为间隔,默认为100
maxLayerRadius <- 100
currentLayRadius <- max(dataNormalMatrix[,1])
if(maxLayerRadius < currentLayRadius){
	maxLayerRadius <- currentLayRadius
}
currentLayRadius <- max(dataNormalMatrix[,2])
if(maxLayerRadius < currentLayRadius){
	maxLayerRadius <- currentLayRadius
}
maxLayerRadius <- round(maxLayerRadius/50,0) * 50
# 画出最外层线
stars(matrix(rep(maxLayerRadius,6),nrow=1,ncol=6),scale=FALSE,location=matrix(c(0,0)),main="集群资源使用总体情况雷达图")
# 添加100%的实线,lwd控制线条粗细,main定义主标题,
stars(matrix(rep(100,6),nrow=1,ncol=6),scale=FALSE,location=matrix(c(0,0)),col.lines=c("Red"),lwd=1,add=TRUE)
# 专门添加一层来放6个度量标签，key.loc貌似是这些标签围绕的中心点的位置，不定义就无法显示标签；key.labels是标签名向量
# cex是字大小，不定义也显示不了标签，len貌似是标签环绕的半径，但是绝对不止是这些，因为一旦加到上面那条里，其他六边形就不见了,而且边线颜色设置无效了
# 感觉len是一个计量单位，填写的半径乘以len才是六边形真正的半径
stars(matrix(rep(0,6),nrow=1,ncol=6),scale=FALSE,location=matrix(c(0,0)),add=TRUE,key.labels=target,key.loc=c(0,0),cex=1,len=100)
# 添加60%~90%的虚线,add表示添加到已有的plot上,lty控制线型，lty="dashed"指虚线
outlayer <- c()
for( i in 6:9 ){
	outlayer <- c(outlayer,rep(i*10,6))
}
outlayer <- matrix(outlayer,nrow=4,ncol=6,byrow=TRUE)
stars(outlayer,scale=FALSE,radius=FALSE,location=location,add=TRUE)
# 添加50%的实线
stars(matrix(rep(50,6),nrow=1,ncol=6),scale=FALSE,radius=FALSE,location=matrix(c(0,0)),lwd=0.6,add=TRUE)
# 添加10%~40%的虚线
outlayer <- c()
for( i in 1:4 ){
	outlayer <- c(outlayer,rep(i*10,6))
}
outlayer <- matrix(outlayer,nrow=4,ncol=6,byrow=TRUE)
stars(outlayer,scale=FALSE,radius=FALSE,location=location,add=TRUE)
# 添加统计线
stars(dataNormalMatrix,scale=FALSE,radius=FALSE,location=matrix(rep(0,4),nrow=2,ncol=2),col.lines=brewer.pal(3,"Set2"),lwd=2,add=TRUE)
legend( x=-(maxLayerRadius+10), y=80, c("平均值","峰值"), cex=1, fill=brewer.pal(3,"Set2"), bty="n")
# 打印可能被隐藏的warning信息，如没有warning，将打印出null
warnings()
# 关闭图片和文本重定向，在R终端用source加载脚本时有用
dev.off()
sink()