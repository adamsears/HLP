# �����ڴ�ռ��ʵʱͳ�ƣ�����ѻ�ͼ
# ����������
library(ggplot2)
library(RODBC)
library(RColorBrewer)
# ���õ�ǰ·������R�ն���source()�������ؽű�ʱ����
#setwd("E:/CODE/r/mem_time_1min")
# �ض����ı����
sink("./mem_time_1min.txt", append=TRUE, split=TRUE)
# �ض���ͼƬ���
ppi=400
png("../img/mem_time_1min.png", width=12*ppi, height=6*ppi, units="px", pointsize=12, res=ppi)
# �������ݿ����ӣ���Ҫ��װmysql connector���ڿ������-��������-����Դ������mysql odbcԶ�̷�����Ϣ������R��RODBC��
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

# ����ѻ�ͼ
p <- ggplot(dataConvert, aes(x=time,y=memory,fill=queue)) + geom_area()
# �޸ķ���ѻ�ͼ����ɫ
queueColor <- brewer.pal(8,"Set2")
queueColor <- c(queueColor,"#56B4E9","#999999","darkseagreen3")
p <- p + scale_fill_manual(values=queueColor)
# �ӷ�����⣬���޸�����
p <- p + labs(fill="����") + theme(legend.title=element_text(size=18))
# ��ͼƬ����,���޸�����
p <- p + ggtitle("������ʵʱ�ڴ�ʹ�����") + theme(plot.title=element_text(size=rel(1.5),face="bold"))
# �Ƴ����������ǩ
p <- p + theme(axis.title.x=element_blank())
# �����������ǩ����,�޸�������������
p <- p + ylab("��\n��\nʹ\n��\n��\n��\n(GB)") + theme(axis.title.y=element_text(angle=0,face="bold",size=15))
# �����������
p <- p + theme(axis.text = element_text(hjust=1,vjust=1,face="bold",color="grey20"), axis.text.x = element_text(angle=30))
p
# ��ӡ���ܱ����ص�warning��Ϣ����û��warning������ӡ��null
warnings()
# �ر�ͼƬ���ı��ض�����R�ն���source���ؽű�ʱ����
dev.off()
sink()