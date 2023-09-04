library(data.table)
d11 <- fread('/Users/zhichengji/Dropbox/research/gptcelltype/anno/res/gpt4aug3.csv',data.table=F,na.strings = NULL)
d11 <- d11[!grepl('top20|top30',d11[,1]),]
d11$annotation <- sub('[0-9]*\\. ','',d11$annotation)
d11[,1] <- sub('_top10','',d11[,1])
colnames(d11)[5] <- 'gpt4aug3_annotation'

d12 <- fread('/Users/zhichengji/Dropbox/research/gptcelltype/anno/res/gpt4mar23.csv',data.table=F,na.strings = NULL)
d12 <- d12[!grepl('top20|top30',d12[,1]),]
d12[,1] <- sub('_top10','',d12[,1])
d11$gpt4mar23_annotation <- NA
d11$gpt4mar23_annotation[1:nrow(d12)] <- d12$annotation
#check
sapply(1:4,function(i) mean(d11[1:nrow(d12),i]==d12[,i]))
cbind(d11[which(d11[1:nrow(d12),3]!=d12[,3]),3],d12[which(d11[1:nrow(d12),3]!=d12[,3]),3])

d13 <- fread('/Users/zhichengji/Dropbox/research/gptcelltype/anno/res/gpt3.5aug3.csv',data.table=F,na.strings = NULL)
d11$gpt3.5aug3_annotation <- d13$annotation
#check
sapply(1:4,function(i) mean(d11[,i]==d13[,i]))
cbind(d11[which(d11[,3]!=d13[,3]),3],d13[which(d11[,3]!=d13[,3]),3])

d14 <- fread('/Users/zhichengji/Dropbox/research/gptcelltype/anno/res/cellmarker.csv',data.table=F,na.strings = NULL)
d11$cellmarker_annotation <- d14$annotation
#check
sapply(1:4,function(i) mean(d11[,i]==d14[,i]))
cbind(d11[which(d11[,3]!=d14[,3]),3],d14[which(d11[,3]!=d14[,3]),3])
d <- d11
d$tissue <- sub('_',' ',d$tissue)

d2 <- fread('/Users/zhichengji/Dropbox/research/gptcelltype/anno/res/sctype.csv',data.table=F)
d22 <- fread('/Users/zhichengji/Dropbox/research/gptcelltype/anno/res/SingleR.csv',data.table=F)
sapply(1:3,function(i) mean(d2[,i]==d22[,i],na.rm=T))
colnames(d2)[4] <- 'sctype_annotation'
d2$SingleR_annotation <- d22$annotation

td <- paste0(d$dataset,'_',d$tissue,'_',d$celltype)
td2 <- paste0(d2$dataset,'_',d2$tissue,'_',d2$celltype)
d <- d[!duplicated(td),]
td <- paste0(d$dataset,'_',d$tissue,'_',d$celltype)
int <- intersect(td,td2)
#check
table(d[(d$dataset %in% sub('_.*','',int) & !td %in% int),1])
d2[!td2%in%int,]

d <- d[!(d$dataset %in% sub('_.*','',int) & !td %in% int),]
d2 <- d2[td2%in%int,]

td <- paste0(d$dataset,'_',d$tissue,'_',d$celltype)
td2 <- paste0(d2$dataset,'_',d2$tissue,'_',d2$celltype)

d$sctype_annotation <- d$SingleR_annotation <- NA
d$sctype_annotation[match(td2,td)] <- d2$sctype_annotation
d$SingleR_annotation[match(td2,td)] <- d2$SingleR_annotation

cl <- read.csv('Dropbox/research/gptcelltype/anno/cl/compiled.csv',as.is=T,header=T)
mean(sub('cells','cell',tolower(d$celltype))%in%cl[,1])
sapply(grep('annotation',colnames(d),value=T),function(i) {
	mean(sub('cells','cell',tolower(setdiff(d[,i],NA)))%in%cl[,1])
})
# cl[is.na(cl$type),1]
# sort(unique(unlist(strsplit(cl$type,','))))
# ucl <- unique(cl[,c(2,4)])
# ucl <- unique(ucl)
# tab <- table(ucl[,1])

#mean(sub('cells','cell',tolower(d$celltype))%in%cl[,1])
#mean(sub('cells','cell',tolower(d$annotation))%in%cl[,1])



d$celltype_CLname <- cl[match(sub('cells','cell',tolower(d$celltype)),cl[,1]),2]
d$celltype_CLID <- cl[match(sub('cells','cell',tolower(d$celltype)),cl[,1]),3]
d$celltype_broadtype <- cl[match(sub('cells','cell',tolower(d$celltype)),cl[,1]),4]

d <- d[!is.na(d$celltype_broadtype),]

for (i in grep('annotation',colnames(d),value=T)) {
	d[,sub('_annotation','_CLname',i)] <- cl[match(sub('cells','cell',tolower(d[,i])),cl[,1]),2]
	d[,sub('_annotation','_CLID',i)] <- cl[match(sub('cells','cell',tolower(d[,i])),cl[,1]),3]
	d[,sub('_annotation','_broadtype',i)] <- cl[match(sub('cells','cell',tolower(d[,i])),cl[,1]),4]
}

hier <- as.matrix(read.csv('Dropbox/research/gptcelltype/anno/cl/relation.csv',as.is=T,header=F))
hier <- rbind(hier,hier[,2:1])
hv <- hier[,1]
names(hv) <- hier[,2]

for (i in grep('annotation',colnames(d),value=T)) {
	agg <- rep(0,nrow(d))
	partscore <- sapply(1:nrow(d),function(j) {
		t1 <- strsplit(d[j,'celltype_broadtype'],',|, ')[[1]]
		t2 <- strsplit(d[j,sub('_annotation','_broadtype',i)],',|, ')[[1]]
		t1 <- c(t1,hv[t1])
		t2 <- c(t2,hv[t2])
		t1 <- setdiff(t1,NA)
		t2 <- setdiff(t2,NA)
		length(intersect(t1,t2)) > 0
	})
	fullscore <- sapply(1:nrow(d),function(j) {
		t1 <- strsplit(d[j,'celltype_CLname'],',|, ')[[1]]
		t2 <- strsplit(d[j,sub('_annotation','_CLname',i)],',|, ')[[1]]
		t1 <- setdiff(t1,NA)
		t2 <- setdiff(t2,NA)
		s1 <- length(intersect(t1,t2))/length(union(t1,t2))==1
		if (is.na(s1)) s1 <- F
		s2 <- sub('s$','',tolower(d[j,'celltype']))==sub('s$','',tolower(d[j,i]))
		s3 <- d[j,'celltype_broadtype']=='malignant cell'&d[j,sub('_annotation','_broadtype',i)]=='malignant cell'
		s1|s2|s3
	})
	agg[which(partscore)] <- 0.5
	agg[which(fullscore)] <- 1
	agg[is.na(d[,i])] <- NA
	d[,sub('_annotation','_agreement',i)] <- agg
}

colMeans(d[,grep('agreement',colnames(d))]==0,na.rm=T)
colMeans(d[,grep('agreement',colnames(d))]==0.5,na.rm=T)
colMeans(d[,grep('agreement',colnames(d))]==1,na.rm=T)

colnames(d)[colnames(d)=='Category'] <- 'category'
colnames(d)[colnames(d)=='celltype'] <- 'celltype_annotation'
colnames(d) <- sub('celltype_','manual_',colnames(d))
colnames(d) <- sub('cellmarker_','CellMarker2.0_',colnames(d))
colnames(d) <- sub('sctype_','ScType_',colnames(d))
cn <- apply(expand.grid(c('annotation','CLname','CLID','broadtype','agreement'),c('manual','gpt4aug3','gpt4mar23','gpt3.5aug3','CellMarker2.0','SingleR','ScType'))[,2:1],1,paste,collapse='_')
cn <- setdiff(cn,'manual_agreement')
d <- d[,c('dataset','tissue','marker',cn)]

# agree <- read.csv('Dropbox/research/gptcelltype/anno/agreement/compiled.csv')
# for (i in grep('annotation',colnames(d),value=T)) {
# 	t1 <- paste0(sub('cells','cell',tolower(d$celltype)),':-:',d$celltype_CLname)
# 	t2 <- paste0(sub('cells','cell',tolower(d[,i])),':-:',d[,sub('_annotation','_CLname',i)])
# 	res <- t(sapply(1:length(t1),function(i) {
# 		sort(c(t1[i],t2[i]))
# 	}))
# 	k <- paste0(res[,1],';',res[,2])
# 	agk <- paste0(agree[,1],':-:',agree[,2],';',agree[,3],':-:',agree[,4])
# 	d[,sub('_annotation','_agreement',i)] <- agree[match(k,agk),'agreement']
# }
write.csv(d,file='Dropbox/research/gptcelltype/anno/compiled/all.csv',row.names=F)

