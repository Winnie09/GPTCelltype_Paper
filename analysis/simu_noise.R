library(data.table)
a <- fread('/Users/wenpinhou/Dropbox/gptcelltype/simu/gpt4aug3/compiled/noise.csv',data.table=F)
d <- fread('/Users/wenpinhou/Dropbox/gptcelltype/anno/compiled/all.csv',data.table=F)
d <- d[d[,1]=='literature'&d[,2]=='Breast',]

library(reshape2)
pd <- tapply(a$gpt4aug3_agreement,list(a$simuround,a$noise),mean)
pd <- melt(pd)
pd <- rbind(pd[,2:3],data.frame(Var2=0,value=mean(d$gpt4aug3_agreement)),data.frame(Var2=0,value=mean(d$gpt4aug3_agreement)))
pd[,1] <- as.character(pd[,1])
saveRDS(pd, '/Users/wenpinhou/Dropbox/gptcelltype/plot/simu_noise.rds')

library(ggplot2)
pdf('/Users/wenpinhou/Dropbox/gptcelltype/plot/simu_noise.pdf',width=3,height=3)
ggplot(pd,aes(x=Var2,y=value)) + geom_violin() + geom_point() + theme_classic() + xlab('Noise level') + ylab('Average score') + ylim(c(0,1))
dev.off()