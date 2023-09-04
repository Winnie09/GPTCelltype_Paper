options(warn=2)
source('Dropbox/research/gptcelltype/github/software/R/gptcelltype.R')
d <- read.csv('Dropbox/research/gptcelltype/simu/gpt4aug3/subset.csv',as.is=T)
gl <- strsplit(d$gene,',')
uid <- paste0(d[,1],'_',d[,2])
for (i in unique(uid)) {
	print(i)
	id <- which(uid==i)
	d$annotation[id] <- gptcelltype(input=gl[id],openai_key='',model='gpt-4')
} 

write.csv(d,file='Dropbox/research/gptcelltype/simu/gpt4aug3/subset.csv',row.names = F)
