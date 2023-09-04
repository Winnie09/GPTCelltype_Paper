d1 <- read.csv('Dropbox/research/gptcelltype/simu/gpt4aug3/res/mixanno.csv',as.is=T)
d2 <- read.csv('Dropbox/research/gptcelltype/simu/gpt4aug3/res/null.csv',as.is=T)
mix <- tapply(d1$score,list(d1[,1]),mean)
null <- tapply(d2$score,list(d2[,1]),mean)
d <- rbind(d1[,c('celltype','annotation')],d2[,c('celltype','annotation')])
tab <- table(d[,1])
d <- d[d[,1]%in%setdiff(names(tab)[tab > 5],'random'),]
d[,2] <- sub('^ ','',tolower(d[,2]))
repro <- tapply(d[,2],list(d[,1]),function(i) {
  # cid <- combn(1:length(i),2)
  # mean(i[cid[1,]]==i[cid[2,]])
  max(table(i))/length(i)
})

pd <- data.frame(value=c(mix,null,repro),type=factor(rep(c('annotation of mixed cell type','annotation of unknown cell type','reproducibility'),c(length(mix),length(null),length(repro))),levels=(c('annotation of mixed cell type','annotation of unknown cell type','reproducibility'))))
saveRDS(pd, '/Users/wenpinhou/Dropbox/gptcelltype/plot/robustness.rds')

library(ggplot2)
pdf('Dropbox/research/gptcelltype/plot/robustness.pdf',width=3,height=2.5)
ggplot(pd,aes(x=value,y=type)) + geom_violin() + geom_point() + theme_classic() + xlab('proportion') + ylab('') + coord_cartesian(xlim=c(0,1)) + facet_wrap(type~.,ncol=1,scale='free') + xlab('') + theme(legend.background = element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank(),strip.background = element_blank(),axis.line.y = element_blank(),strip.text = element_text(size=12))
dev.off()
