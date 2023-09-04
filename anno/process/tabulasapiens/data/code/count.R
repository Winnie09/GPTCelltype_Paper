library(data.table)
d <- fread('/celltype/tabulasapiens/data/raw/meta.tsv',data.table=F)
m <- fread('/celltype/tabulasapiens/data/raw/exprMatrix.tsv.gz',data.table=F)
rownames(m) <- m[,1]
m <- as.matrix(m[,-1])
for (k in unique(d$organ_tissue)) {
	id <- which(d$organ_tissue==k)
	sd <- d[id,]
	sm <- m[,id]
	saveRDS(sd,file=paste0('/celltype/tabulasapiens/data/meta/',k,'.rds'))
	saveRDS(sm,file=paste0('/celltype/tabulasapiens/data/count/',k,'.rds'))
}

