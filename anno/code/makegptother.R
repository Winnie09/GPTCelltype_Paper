options(warn=2)
d <- read.csv('Dropbox/research/gptcelltype/anno/gpttemplate.csv',as.is=T)
k <- paste0(d[,1],'_',d[,2])
k[which(k=='HCL_top30_NA')[1:50]] <- 'HCL_top30_NA_1'
done <- unique(k[which(!is.na(d$annotation))])
for (i in setdiff(unique(k),done)) {
	print(i)
	id <- which(k==i)
	gl <- strsplit(d$marker[id],', ')
	ct <- gptcelltype(input=gl,tissuename=unique(d$tissue[id]),openai_key='',model='gpt-4')
	d$annotation[id] <- ct
}
write.csv(d,file='Dropbox/research/gptcelltype/anno/gpt4aug3.csv')


options(warn=2)
d <- read.csv('Dropbox/research/gptcelltype/anno/code/gpttemplate.csv',as.is=T)
k <- paste0(d[,1],'_',d[,2])
k[which(k=='HCL_top30_NA')[1:50]] <- 'HCL_top30_NA_1'
done <- unique(k[which(!is.na(d$annotation))])
for (i in setdiff(unique(k),done)) {
	print(i)
	id <- which(k==i)
	gl <- strsplit(d$marker[id],', ')
	ct <- gptcelltype(input=gl,tissuename=unique(d$tissue[id]),openai_key='',model='gpt-3.5-turbo')
	d$annotation[id] <- ct
}
write.csv(d,file='Dropbox/research/gptcelltype/anno/res/gpt3.5aug3.csv')
