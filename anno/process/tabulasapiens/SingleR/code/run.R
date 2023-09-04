suppressMessages(library(celldex))
hpca.se <- HumanPrimaryCellAtlasData()
suppressMessages(library(SingleR))

af <- list.files('/celltype/tabulasapiens/data/norm')
for (f in af) {
	cv <- readRDS(paste0('/celltype/tabulasapiens/data/meta/',f))
	clu <- cv$cell_ontology_class
	names(clu) <- cv[,1]
	d <- readRDS(paste0('/celltype/tabulasapiens/data/norm/',f))
	
	rt <- system.time({pred <- SingleR(test = d, ref = hpca.se, assay.type.test=1,labels = hpca.se$label.main)})
	
	f <- sub('.rds','',f)
	dir.create(paste0('/celltype/tabulasapiens/SingleR/res/',f))
	
	saveRDS(pred,file=paste0('/celltype/tabulasapiens/SingleR/res/',f,'/fullpred.rds'))
	saveRDS(rt,file=paste0('/celltype/tabulasapiens/SingleR/res/',f,'/time.rds'))
	
	mat <- pred$scores
	rownames(mat) <- pred@rownames
	k <- rowsum(mat[names(clu),],clu)
	predct <- colnames(k)[apply(k,1,which.max)]
	orict <- rownames(k)
	ct <- data.frame(orict=orict,predct=predct)
	saveRDS(ct,file=paste0('/celltype/tabulasapiens/SingleR/res/',f,'/res.rds'))
}


