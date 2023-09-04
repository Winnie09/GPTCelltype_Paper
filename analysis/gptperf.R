source('/Users/wenpinhou/Dropbox/resource/ggplot_theme.R')
library(data.table)
options(scipen=999,warn=1)
r <- fread('/Users/wenpinhou/Dropbox/gptcelltype/anno/compiled/all.csv',data.table=F)
r$tissue[r$tissue=='NA'] <- 'Mixed tissue'
cb <- paste0(r[,1],':',r[,2])
cb[cb=='BCL:B cell lymphoma'] <- 'BCL'
cb[cb=='coloncancer:colon cancer'] <- 'colon cancer'
cb[cb=='lungcancer:lung cancer and brain metastasis'] <- 'lung cancer'
r$cb <- cb
d <- do.call(rbind,sapply(unique(cb),function(i) {
  v <- table(r$gpt4aug3_agreement[cb==i])
  v <- v/sum(v)
  data.frame(dataset=sub(':.*','',i),tissue=sub('.*:','',i),score=as.character(names(v)),count=as.vector(v))
},simplify = F))
rownames(d) <- NULL

score <- sapply(unique(cb),function(i) {
  mean(r$gpt4aug3_agreement[cb==i])
})

d$cb <- paste0(d[,1],':',d[,2])
d$cb[d$cb=='BCL:BCL'] <- 'BCL'
d$cb[d$cb=='colon cancer:colon cancer'] <- 'colon cancer'
d$cb[d$cb=='lung cancer:lung cancer'] <- 'lung cancer'
d$agreement <- factor(ifelse(d$score=='0','Mismatch',ifelse(d$score=='1','Fully match','Partially match')),levels=rev(c('Fully match','Partially match','Mismatch')))

pd <- data.frame(cb=names(score),score=score)

pd[pd[,1]=='Azimuth:Bone Marrow',1] <- 'Azimuth:Bone marrow'
pd[pd[,1]=='Azimuth:Fetal Development',1] <- 'Azimuth:Fetal development'
pd[pd[,1]=='Azimuth:Motor Cortex',1] <- 'Azimuth:Motor cortex'

d[d[,5]=='Azimuth:Bone Marrow',5] <- 'Azimuth:Bone marrow'
d[d[,5]=='Azimuth:Fetal Development',5] <- 'Azimuth:Fetal development'
d[d[,5]=='Azimuth:Motor Cortex',5] <- 'Azimuth:Motor cortex'

pd <- pd[order(pd[,2]),]
d$cb <- factor(d$cb,levels=pd[,1])
d$dataset[d$dataset%in%c('BCL','colon cancer','lung cancer')] <- 'cancer'
d$type <- 'study and tissue'
d1 <- d[,c('count','cb','dataset','agreement','type')]
pd$type <- 'study and tissue'
pd1 <- pd


library(data.table)
r <- fread('/Users/wenpinhou/Dropbox/gptcelltype/anno/compiled/all.csv',data.table=F)
r <- r[,colnames(r)!='gpt4mar23_annotation']
r <- r[complete.cases(r[,grep('annotation',colnames(r))]),]
r <- r[r$manual_broadtype %in% c(names(head(sort(table(r$manual_broadtype),decreasing = T),n=5)),'malignant cell'),]

d <- do.call(rbind,sapply(unique(r$manual_broadtype),function(i) {
  v <- table(r$gpt4aug3_agreement[r$manual_broadtype==i])
  v <- v/sum(v)
  data.frame(celltype=i,score=as.character(names(v)),count=as.vector(v))
},simplify = F))
rownames(d) <- NULL

score <- sapply(unique(r$manual_broadtype),function(i) {
  mean(r$gpt4aug3_agreement[r$manual_broadtype==i])
})

d$agreement <- factor(ifelse(d$score=='0','Mismatch',ifelse(d$score=='1','Fully match','Partially match')),levels=rev(c('Fully match','Partially match','Mismatch')))

pd <- data.frame(cb=names(score),score=score)
pd <- pd[order(pd[,2]),]
d$cb <- factor(d$celltype,levels=pd[,1])
d$dataset <- 'ct'
d$type <- 'cell type'
d2 <- d[,c('count','cb','dataset','agreement','type')]
pd$type <- 'cell type'
pd2 <- pd



d <- readRDS('/Users/wenpinhou/Dropbox/gptcelltype/numcell/numcell.rds')
d[d[,1]=='HCA'&d[,2]=='Esophagus_mucosa',2] <- 'Esophagus'
d[,2] <- sub('_',' ',d[,2])
a <- fread('/Users/wenpinhou/Dropbox/gptcelltype/anno/compiled/all.csv',data.table=F)
a <- a[!a[,1]%in%c('Azimuth','literature'),]
dp <- paste0(d$dataset,'_',d$tissue,'_',d$celltype)
ap <- paste0(a$dataset,'_',a$tissue,'_',a$manual_annotation)

setdiff(ap,dp)

a$num <- d[match(ap,dp),'number']
g <- as.character(cut(a$num,c(0,10,100,80000)))
g[g=='(100,8e+04]'] <- '>100'
g <- paste0(g,' cells')
g <- factor(g,levels=c('(0,10] cells',"(10,100] cells",">100 cells"))
pd <- tapply(a$gpt4aug3_agreement,list(g),mean)
k <- table(g,a$gpt4aug3_agreement)
d <- k/rowSums(k)
library(reshape2)
d <- melt(d)
colnames(d) <- c('cb','score','count')
d$agreement <- factor(ifelse(d$score=='0','Mismatch',ifelse(d$score=='1','Fully match','Partially match')),levels=rev(c('Fully match','Partially match','Mismatch')))
d3 <- data.frame(d,dataset='num',type='cell number')[,colnames(d1)]
pd3 <- data.frame(cb=names(pd),score=as.vector(pd),type='cell number')




d <- fread('/Users/wenpinhou/Dropbox/gptcelltype/anno/subtype/list.csv',data.table=F)
a <- fread('/Users/wenpinhou/Dropbox/gptcelltype/anno/compiled/all.csv',data.table=F)
a$subset <- d[match(sub('cells','cell',tolower(a$manual_annotation)),d[,1]),2]
a$subset <- sub('no','major cell type',sub('yes','cell subtype',a$subset))

pd <- tapply(a$gpt4aug3_agreement,list(a$subset),mean)
k <- table(a$subset,a$gpt4aug3_agreement)
d <- k/rowSums(k)
library(reshape2)
d <- melt(d)
colnames(d) <- c('cb','score','count')
d$cb <- factor(as.character(d$cb),levels=rev(c('major cell type','cell subtype')))
d$agreement <- factor(ifelse(d$score=='0','Mismatch',ifelse(d$score=='1','Fully match','Partially match')),levels=rev(c('Fully match','Partially match','Mismatch')))
d4 <- data.frame(d,dataset='subtype',type='subtype')[,colnames(d1)]
pd4 <- data.frame(cb=names(pd),score=as.vector(pd),type='subtype')
pd4$cb <- factor(as.character(pd4$cb),levels=rev(c('major cell type','cell subtype')))





d <- rbind(d1,d2,d3,d4)
pd <- rbind(pd1,pd2,pd3,pd4)
d$type <- factor(d$type,levels=c('study and tissue','cell type','cell number','subtype'))
pd$type <- factor(pd$type,levels=c('study and tissue','cell type','cell number','subtype'))



library(RColorBrewer)
pal <- c(rgb(230,159,0,maxColorValue = 255),rgb(86,180,233,maxColorValue = 255),rgb(0,158,115,maxColorValue = 255),rgb(240,228,66,maxColorValue = 255),rgb(0,114,178,maxColorValue = 255),rgb(204,121,167,maxColorValue = 255),rgb(213,94,0,maxColorValue = 255),'pink','skyblue','yellowgreen')
names(pal) <- c('Azimuth','cancer','GTEx','HCL','literature','TS','MCA','ct','num','subtype')
coldf = readRDS('/Users/wenpinhou/Dropbox/gptcelltype/analysis/method_color.rds')
colv = coldf[,2]
names(colv) = coldf[,1]
colv2 = c(colv[names(pal[1:7])], pal[8:10])
names(colv2) = names(pal)




## ============
## change names
## ============
d[d[,3] == 'HCA', 3] = 'GTEx'
d[d[,3] == 'tabulasapiens', 3] = 'TS'
## ============

library(ggplot2)
library(egg)
pdf('/Users/wenpinhou/Dropbox/gptcelltype/plot/gptperf.pdf',width=2.5,height=7)
ggplot() + geom_bar(data = d,aes(x = count,y = cb,fill = dataset,alpha = agreement),
                    stat = 'identity') + facet_grid(type ~ ., scale = 'free', space = 'free') + 
  geom_point(data = pd, aes(x = score, y = cb)) + 
  xlab('Proportion') + ylab('') + theme(legend.position = 'top', legend.box = 'verticle', plot.margin = unit(c(0, 0, 0, 0), 'cm'),
                             legend.title = element_blank(),
                             strip.background = element_blank(),
                             strip.text = element_blank()
                             ) + 
  scale_y_discrete(breaks = pd[, 1], labels = sub('.*:', '', pd[, 1])) + 
  scale_fill_manual(breaks = names(colv2)[1:7], values = colv2)
dev.off()
