suppressMessages(library(celldex))
hpca.se <- HumanPrimaryCellAtlasData()
suppressMessages(library(SingleR))
af <- list.files('/celltype/hca/data/proc')
for (f in af) {
	dir.create(paste0('/celltype/hca/SingleR/res/',f))
	clu <- readRDS(paste0('/celltype/hca/data/proc/',f,'/ct.rds'))
	d <- readRDS(paste0('/celltype/hca/data/proc/',f,'/norm.rds'))
	rt <- system.time({pred <- SingleR(test = d, ref = hpca.se, assay.type.test=1,labels = hpca.se$label.main)})
	saveRDS(pred,file=paste0('/celltype/hca/SingleR/res/',f,'/fullpred.rds'))
	saveRDS(rt,file=paste0('/celltype/hca/SingleR/res/',f,'/time.rds'))
	mat <- pred$scores
	rownames(mat) <- pred@rownames
	k <- rowsum(mat[names(clu),],clu)
	predct <- colnames(k)[apply(k,1,which.max)]
	orict <- rownames(k)
	ct <- data.frame(orict=orict,predct=predct)
	saveRDS(ct,file=paste0('/celltype/hca/SingleR/res/',f,'/res.rds'))
}

