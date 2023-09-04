scalematrix <- function(data) {
	cm <- rowMeans(data)
	csd <- sqrt((rowMeans(data*data) - cm^2) / (ncol(data) - 1) * ncol(data))
	(data - cm) / csd
}

lapply(c("dplyr","Seurat","HGNChelper","openxlsx"), library, character.only = T)
source("https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/R/gene_sets_prepare.R"); source("https://raw.githubusercontent.com/IanevskiAleksandr/sc-type/master/R/sctype_score_.R")
source('/celltype/software/sctype/sctype_score.R')
id <- as.numeric(commandArgs(trailingOnly = T))
af <- list.files('/celltype/hca/data/proc')
f <- af[id]
	dir.create(paste0('/celltype/hca/sctype/res/',f))
	a <- readRDS(paste0('/celltype/hca/data/proc/',f,'/ct.rds'))
	d <- readRDS(paste0('/celltype/hca/data/proc/',f,'/norm.rds'))
	d <- scalematrix(d)
	# get cell-type-specific gene sets from our in-built database (DB)
	gs_list = gene_sets_prepare("/celltype/software/sctype/ScTypeDB_full.xlsx", "All") # e.g. Immune system, Liver, Pancreas, Kidney, Eye, Brain
	rt <- system.time({
		es.max = sctype_score(scRNAseqData = d, scaled = TRUE, gs = gs_list$gs_positive, gs2 = gs_list$gs_negative)
		clu <- a[colnames(d)]
		ss <- rowsum(t(es.max),clu)
		ct <- colnames(ss)[apply(ss,1,which.max)]
		ct <- data.frame(orict=rownames(ss),predct=ct)
	})
	saveRDS(rt,file=paste0('/celltype/hca/sctype/res/',f,'/time.rds'))
	saveRDS(ct,file=paste0('/celltype/hca/sctype/res/',f,'/res.rds'))

