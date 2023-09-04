library(data.table)
d <- fread('/Users/zhichengji/Dropbox/research/gptcelltype/simu/gpt4aug3/res/noise.csv',data.table=F)
d <- d[d$noise!=1,]

d$annotation <- sub('[0-9]*\\. ','',d$annotation)
cl <- read.csv('Dropbox/research/gptcelltype/anno/cl/compiled.csv',as.is=T,header=T)
mean(sub('cells','cell',tolower(d$celltype))%in%cl[,1])
mean(sub('cells','cell',tolower(d$annotation))%in%cl[,1])
d$celltype_CLname <- cl[match(sub('cells','cell',tolower(d$celltype)),cl[,1]),2]
d$celltype_CLID <- cl[match(sub('cells','cell',tolower(d$celltype)),cl[,1]),3]
d$celltype_broadtype <- cl[match(sub('cells','cell',tolower(d$celltype)),cl[,1]),4]
d$annotation_CLname <- cl[match(sub('cells','cell',tolower(d$annotation)),cl[,1]),2]
d$annotation_CLID <- cl[match(sub('cells','cell',tolower(d$annotation)),cl[,1]),3]
d$annotation_broadtype <- cl[match(sub('cells','cell',tolower(d$annotation)),cl[,1]),4]

hier <- as.matrix(read.csv('Dropbox/research/gptcelltype/anno/cl/relation.csv',as.is=T,header=F))
hier <- rbind(hier,hier[,2:1])
hv <- hier[,1]
names(hv) <- hier[,2]

agg <- rep(0,nrow(d))
partscore <- sapply(1:nrow(d),function(j) {
	t1 <- strsplit(d[j,'celltype_broadtype'],',|, ')[[1]]
	t2 <- strsplit(d[j,'annotation_broadtype'],',|, ')[[1]]
	t1 <- c(t1,hv[t1])
	t2 <- c(t2,hv[t2])
	t1 <- setdiff(t1,NA)
	t2 <- setdiff(t2,NA)
	length(intersect(t1,t2)) > 0
})
fullscore <- sapply(1:nrow(d),function(j) {
	t1 <- strsplit(d[j,'celltype_CLname'],',|, ')[[1]]
	t2 <- strsplit(d[j,'annotation_CLname'],',|, ')[[1]]
	t1 <- setdiff(t1,NA)
	t2 <- setdiff(t2,NA)
	s1 <- length(intersect(t1,t2))/length(union(t1,t2))==1
	if (is.na(s1)) s1 <- F
	s2 <- sub('s$','',tolower(d[j,'celltype']))==sub('s$','',tolower(d[j,'annotation']))
	s3 <- d[j,'celltype_broadtype']=='malignant cell'&d[j,'annotation_broadtype']=='malignant cell'
	s1|s2|s3
})
agg[which(partscore)] <- 0.5
agg[which(fullscore)] <- 1

d$gpt4aug3_agreement <- agg

colnames(d)[colnames(d)=='annotation'] <- 'annotation_annotation'
colnames(d) <- sub('annotation_','gpt4aug3_',colnames(d))
colnames(d)[colnames(d)=='celltype'] <- 'celltype_annotation'
colnames(d) <- sub('celltype_','manual_',colnames(d))

cn <- apply(expand.grid(c('annotation','CLname','CLID','broadtype','agreement'),c('manual','gpt4aug3'))[,2:1],1,paste,collapse='_')
cn <- setdiff(cn,'manual_agreement')
d <- d[,c('simuround','noise','gene',cn)]

write.csv(d,file='/Users/zhichengji/Dropbox/research/gptcelltype/simu/gpt4aug3/compiled/noise.csv',row.names=F)
