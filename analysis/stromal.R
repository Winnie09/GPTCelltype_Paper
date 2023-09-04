rm(list=ls())
source('/Users/wenpinhou/Dropbox/resource/ggplot_theme.R')
library(data.table)
r <- fread('/Users/wenpinhou/Dropbox/gptcelltype/anno/compiled/all.csv',data.table=F)
r <- r[!r[,1]%in%c('Azimuth','literature'),]
d <- readRDS('/Users/wenpinhou/Dropbox/gptcelltype/analysis/stromalexpr.rds')
d$tissue[d$tissue=='Esophagus_mucosa'] <- 'Esophagus'
rp <- paste0(r$dataset,'_',r$tissue,'_',r$manual_annotation)
dp <- paste0(d$dataset,'_',sub('_',' ',d$tissue),'_',d$celltype)

id1 <- grep('fibroblast|osteoblast',r$manual_annotation,ignore.case = T)
id2 <- grep('chondrocyte',r$manual_annotation,ignore.case = T)
id3 <- which(grepl('stromal cell',r$manual_annotation,ignore.case = T) & grepl('fibroblast|osteoblast',r$gpt4aug3_annotation,ignore.case = T))
id4 <- which(grepl('stromal cell',r$manual_annotation,ignore.case = T) & grepl('chondrocyte',r$gpt4aug3_annotation,ignore.case = T))

d$score <- log2(((d$COL1A1+d$COL1A2)/2+0.01)/(d$COL2A1+0.01))
pd1 <- data.frame(type='Manual: fibroblast/osteoblast',score=d[which(dp%in%rp[id1]),'score'])
pd2 <- data.frame(type='Manual: chondrocyte',score=d[which(dp%in%rp[id2]),'score'])
pd3 <- data.frame(type='Manual: stromal cell\n GPT-4: fibroblast/osteoblast',score=d[which(dp%in%rp[id3]),'score'])
pd <- rbind(pd1,pd2,pd3)
pd[,1] <- factor(pd[,1],levels=rev(c('Manual: fibroblast/osteoblast','Manual: chondrocyte','Manual: stromal cell\n GPT-4: fibroblast/osteoblast')))
pd$col <- 'high type I collagen'
pd$col[pd$type=='Manual: chondrocyte'] <- 'high type II collagen'
colnames(pd)[3] = 'collagen'
pdf('/Users/wenpinhou/Dropbox/gptcelltype/plot/stromal.pdf',width=4,height=1)
ggplot(pd,aes(x=score,y=type,fill=collagen)) + 
  geom_violin(scale='width',alpha=0.2) + 
  geom_jitter(size = 0.8, stroke = 0, alpha = 0.8, width = 0.2) + 
  xlab(expression(paste(log[2],'(type I collagen/type II collagen)'))) + 
  ylab('') + 
  geom_vline(xintercept = 0,linetype=2) 
dev.off()
