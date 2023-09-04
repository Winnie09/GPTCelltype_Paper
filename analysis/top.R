rm(list=ls())
source('/Users/wenpinhou/Dropbox/resource/ggplot_theme.R')
coldf = readRDS('/Users/wenpinhou/Dropbox/gptcelltype/analysis/method_color.rds')
colv = coldf[,2]
names(colv) = coldf[,1]

library(data.table)
r <- fread('/Users/wenpinhou/Dropbox/gptcelltype/anno/compiled/gpt4topgenenumber.csv',data.table = F)
#cb <- paste0(r[,1],':',r[,2])
cb <- paste0(r[,1])
d <- sapply(unique(cb),function(i) {
  mean(r$gpt4aug3_agreement[cb==i])
})


#summary(tapply(pd[,1],list(sub(':.*','',pd[,3]),pd[,2]),mean))

# pal <- c(rgb(230,159,0,maxColorValue = 255),rgb(86,180,233,maxColorValue = 255),rgb(0,158,115,maxColorValue = 255),rgb(240,228,66,maxColorValue = 255),rgb(0,114,178,maxColorValue = 255),rgb(213,94,0,maxColorValue = 255),rgb(204,121,167,maxColorValue = 255))

n <- sub('.*top','',sub(':.*','',names(d)))
pd <- data.frame(score=d,number=n,study=sub('_top[0-9]*(:NA)?','',names(d)))
pd$study[pd$study=='BCL:B cell lymphoma']='BCL'
pd$study[pd$study=='coloncancer:colon cancer']='colon cancer'
pd$study[pd$study=='lungcancer:lung cancer and brain metastasis']='lung cancer'

## ============
## change names
## ============
pd[pd[,3] == 'HCA', 3] = 'GTEx'
pd[pd[,3] == 'tabulasapiens', 3] = 'TS'
colnames(pd)[3] = 'dataset'
## ============
library(ggplot2)
pdf('/Users/wenpinhou/Dropbox/gptcelltype/plot/top.pdf',width=2.5,height=1.5)
ggplot(data=pd,aes(x=number,y=score)) + geom_violin() + geom_point(aes(color=dataset)) + geom_line(aes(group=dataset,color=dataset),alpha=0.4) + xlab('Number of top differential genes') + ylab('Averaged score') + 
  # theme(legend.title = element_blank()) + 
  # theme(legend.position = 'bottom')+
  scale_color_manual(values=colv) 
dev.off()
