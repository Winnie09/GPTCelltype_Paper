rm(list=ls())
source('/Users/wenpinhou/Dropbox/resource/ggplot_theme.R')

library(data.table)
library(psych)
library(reshape2)
d <- fread('/Users/wenpinhou/Dropbox/gptcelltype/anno/compiled/all.csv',data.table=F)
d <- table(d$gpt4aug3_agreement,d$gpt4mar23_agreement)
k <- round(psych::cohen.kappa(d)$kappa,2)

d <- reshape2::melt(d)
colnames(d) <- c('gpt4aug3','gpt4mar23','number')
pdf('/Users/wenpinhou/Dropbox/gptcelltype/plot/gpt4version.pdf',width=1.8,height=1.8)
ggplot(d,aes(x=gpt4aug3,y=gpt4mar23,fill=number,label=number)) + geom_tile() + geom_text(size = 2) + scale_fill_gradient2(low='white',high='pink1') +  xlab('GPT-4 (Aug 3, 2023) score') + ylab('GPT-4 (Mar 23, 2023) score') + theme(legend.position = 'none',plot.title = element_text(hjust = 0.5, size = 6)) + ggtitle(paste0('Kappa:',k))
dev.off()
