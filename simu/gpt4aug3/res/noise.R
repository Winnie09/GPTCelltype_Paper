library(org.Hs.eg.db)
gn <- unique(unlist(as.list(org.Hs.egSYMBOL)))
d <- read.csv('Dropbox/research/gptcelltype/anno/source/tabulasapiens_nuc_lit/proc.csv',as.is=T)
d <- d[d[,1]=='Breast',]
d <- d[,c('celltype','gene')]
set.seed(1)
am <- do.call(rbind,sapply(1:5,function(simuround) {
	do.call(rbind,sapply(c(0.25,0.5,0.75,1),function(per) {
		tmpd <- d
		tmpd$gene <- sapply(d$gene,function(i) {
			gl <- strsplit(i,', ')[[1]]
			snum <- floor(length(gl)*per)
			rnum <- length(gl)-snum
			paste0(c(gl,sample(gn,snum)),collapse = ',')
		})
		data.frame(simuround=simuround,noise=per,celltype=tmpd$celltype,gene=tmpd$gene)
	},simplify = F))
},simplify = F))
write.csv(am,'Dropbox/research/gptcelltype/simu/gpt4aug3/noise.csv',row.names = F)
