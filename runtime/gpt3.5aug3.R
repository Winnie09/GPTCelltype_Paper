options(warn=2)
d <- read.csv('/Users/zhichengji/Dropbox/research/gptcelltype/anno/compiled/all.csv',as.is=T)
k <- paste0(d[,1],'_',d[,2])
time <- rep(NA,length(unique(k)))
names(time) <- unique(k)
for (i in names(time)[is.na(time)]) {
	print(i)
	id <- which(k==i)
	gl <- strsplit(d$marker[id],', ')
	time[i] <- system.time(gptcelltype(input=gl,tissuename=unique(d$tissue[id]),openai_key='',model='gpt-3.5-turbo'))[3]
}
	
saveRDS(time,file='/Users/zhichengji/Dropbox/research/gptcelltype/runtime/gpt3.5aug3.rds')
