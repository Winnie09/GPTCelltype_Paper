af <- list.files('/celltype/tabulasapiens/data/count')
ef <- list.files('/celltype/tabulasapiens/data/norm')
af <- setdiff(af,ef)
for (f in af) {
	d <- readRDS(paste0('/celltype/tabulasapiens/data/count/',f))
	d <- t(log2(t(d)/colSums(d)*10000+1))	
	saveRDS(d,file=paste0('/celltype/tabulasapiens/data/norm/',f))
}

