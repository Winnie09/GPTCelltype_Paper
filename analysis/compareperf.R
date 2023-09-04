rm(list=ls())
source('/Users/wenpinhou/Dropbox/resource/ggplot_theme.R')
library(data.table)
r <- fread('/Users/wenpinhou/Dropbox/gptcelltype/anno/compiled/all.csv',data.table = F)
r <- r[,setdiff(c('dataset',grep('agreement',colnames(r),value=T)),'gpt4mar23_agreement')]

d <- sapply(grep('agreement',colnames(r),value=T),function(i) {
	tapply(r[,i],list(r$dataset),mean)
})
## ===============
## change name
rownames(d)[rownames(d)=='HCA'] = 'GTEx'
rownames(d)[rownames(d)=='tabulasapiens'] = 'TS'
## ===============
str(d)



library(ggplot2)
d <- reshape2::melt(d)
str(d)
d[,3] <- round(d[,3],2)
d[,2] <- sub('gpt3.5aug3','GPT-3.5(Aug 3, 2023)',sub('gpt4aug3','GPT-4(Aug 3, 2023)',sub('_.*','',d[,2])))


## ========
d[grep('GPT-4', d[,2]),2] = 'GPT-4(Aug 3, 2023)'
d[grep('GPT-3.5', d[,2]),2] = 'GPT-3.5(Aug 3, 2023)'
## =========

d[,1] <- factor(as.character(d[,1]),levels=names(sort(tapply(d[,3],list(d[,1]),mean,na.rm=T))))
d[,2] <- factor(d[,2],levels=c('GPT-4(Aug 3, 2023)','GPT-3.5(Aug 3, 2023)','SingleR','ScType','CellMarker2.0'))

pdf('/Users/wenpinhou/Dropbox/gptcelltype/plot/compareperf.pdf',width=3.5,height=2)
ggplot(d,aes(x=Var2,y=Var1,fill=value,label=value)) + geom_tile() + geom_text(size = 1.8) + scale_fill_gradient2(low='white',high='pink1',name='Average\nscore', na.value = 'grey90') + xlab('')+ylab('') + theme(legend.position = 'right') +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust = 1))
dev.off()
