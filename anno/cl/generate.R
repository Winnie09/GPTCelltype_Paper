library(rols)

d <- read.csv('Dropbox/research/gptcelltype/anno/compiled/gpt4topgenenumber.csv',as.is=T,na.strings = NULL)
d2 <- read.csv('Dropbox/research/gptcelltype/anno/compiled/all.csv',as.is=T,na.strings = NULL)

d3 <- read.csv('Dropbox/research/gptcelltype/simu/gpt4aug3/noise.csv',as.is=T,na.strings = NULL)
d4 <- read.csv('Dropbox/research/gptcelltype/simu/gpt4aug3/subset.csv',as.is=T,na.strings = NULL)

ctlist <- c(unlist(d[,grep('annotation',colnames(d))]),unlist(d2[,grep('annotation',colnames(d2))]),d3$celltype,d3$annotation,d4$celltype,d4$annotation)
ct <- sort(unique(sub('cells','cell',tolower(ctlist))))

ex <- read.csv('Dropbox/research/gptcelltype/anno/cl/compiled.csv',as.is=T,header=T)

ct <- ct[!ct%in%ex[,1]]
cv <- sapply(ct,function(i) {
	print(i)
	d <- as(olsSearch(OlsSearch(q = i, ontology = "cl")), "data.frame")
	d <- d[grep('CL:',d$obo_id),]
	c(i,d[1,'label'],d[1,'obo_id'])
})
cv <- t(cv)
cv <- as.data.frame(cv)
cv <- data.frame(cv,type=NA)

colnames(cv) <- colnames(ex)
cv <- rbind(cv,ex)

write.csv(cv,file='Dropbox/research/gptcelltype/anno/cl/compiled.csv',row.names = F)
