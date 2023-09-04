options(warn=2)
d <- read.csv('Dropbox/research/gptcelltype/anno/code/gpttabulasapienstemplate.csv',as.is=T)
d$annotation <- NA
k <- paste0(d[,1],'_',d[,2])
done <- unique(k[which(!is.na(d$annotation))])
for (i in setdiff(unique(k),done)) {
	print(i)
	id <- which(k==i)
	gl <- strsplit(d$marker[id],', ')
	ct <- gptcelltype(input=gl,tissuename=unique(d$tissue[id]),openai_key='',model='gpt-4')
	d$annotation[id] <- ct
}
d$annotation <- sub('[0-9]*\\. ','',d$annotation)
#grep('[0-9]*\\. ',d$annotation,value=T)
write.csv(d,file='Dropbox/research/gptcelltype/anno/gpt4aug3tabulasapiens.csv')


options(warn=2)
d <- read.csv('Dropbox/research/gptcelltype/anno/code/gpttabulasapienstemplate.csv',as.is=T)
d$annotation <- NA
k <- paste0(d[,1],'_',d[,2])
done <- unique(k[which(!is.na(d$annotation))])
for (i in setdiff(unique(k),done)) {
	print(i)
	id <- which(k==i)
	gl <- strsplit(d$marker[id],', ')
	ct <- gptcelltype(input=gl,tissuename=unique(d$tissue[id]),openai_key='',model='gpt-3.5-turbo')
	d$annotation[id] <- ct
}
d$annotation <- sub('[0-9]*\\. ','',d$annotation)
#grep('[0-9]*\\. ',d$annotation,value=T)
write.csv(d,file='Dropbox/research/gptcelltype/anno/gpt3.5aug3tabulasapiens.csv')

