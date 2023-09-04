rm(list=ls())
source('/Users/wenpinhou/Dropbox/resource/ggplot_theme.R')
coldf = readRDS('/Users/wenpinhou/Dropbox/gptcelltype/analysis/method_color.rds')
colv = coldf[,2]
names(colv) = coldf[,1]

library(ggplot2)
d1 <- readRDS('/Users/wenpinhou/Dropbox/gptcelltype/runtime/SingleR.rds')
d1$method <- 'SingleR'
d1$tissue <- sub('Esophagus mucosa','Esophagus',sub('_',' ',d1$tissue))
d2 <- readRDS('/Users/wenpinhou/Dropbox/gptcelltype/runtime/sctype.rds')
d2$method <- 'ScType'
d2$tissue <- sub('Esophagus mucosa','Esophagus',sub('_',' ',d2$tissue))
d3 <- readRDS('/Users/wenpinhou/Dropbox/gptcelltype/runtime/gpt4aug3.rds')
d3 <- data.frame(dataset=sub('_.*','',names(d3)),tissue=sub('.*_','',names(d3)),time=unname(d3),method='GPT-4(Aug3)')
d4 <- readRDS('/Users/wenpinhou/Dropbox/gptcelltype/runtime/gpt3.5aug3.rds')
d4 <- data.frame(dataset=sub('_.*','',names(d4)),tissue=sub('.*_','',names(d4)),time=unname(d4),method='GPT-3.5(Aug3)')

d <- rbind(d1,d2,d3,d4)
k <- paste0(d[,1],d[,2])
tab <- table(k)
d <- d[k%in%names(tab)[tab==4],]
## ===============
## change name
d[d[,1]=='HCA',1] = 'GTEx'
d[d[,1]=='tabulasapiens',1] = 'TS'
d[grep('GPT-4', d[,4]),4] = 'GPT-4(Aug 3, 2023)'
d[grep('GPT-3.5', d[,4]),4] = 'GPT-3.5(Aug 3, 2023)'
## ===============

pdf('/Users/wenpinhou/Dropbox/gptcelltype/plot/runtime.pdf',width=3.5,height=2)
ggplot(d,aes(x=method,y=log2(time))) + 
  # geom_boxplot(outlier.size = 0) +
  geom_boxplot(aes(fill = method), alpha = 0.3, outlier.size = 0)+
  geom_jitter(stroke = 0, size = 0.8, alpha= 1, aes(color = dataset), width = 0.1)+
  scale_color_manual(values = colv) +
  theme(axis.text.x = element_text(angle= 30, vjust = 1, hjust = 1)) +
  guides(color = guide_legend(override.aes = list(size = 2))) +
  ylab(expression(paste("Running time: ", log[2], '(seconds)'))) + 
  xlab('')  + 
  scale_fill_brewer(palette = 'Pastel2')+
  guides(fill = FALSE)
dev.off()
