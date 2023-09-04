af <- list.files('/celltype/tabulasapiens/diff/res')
res <- NULL
for (f in af) {
	d <- readRDS(paste0('/celltype/tabulasapiens/diff/res/',f))	
	for (n in c(10,20,30)) {
		tmp <- tapply(d$gene,list(d$cluster),function(i) paste0(i[1:n],collapse=','))
		res <- rbind(res,data.frame(dataset=paste0('tabulasapiens_top',n),tissue=sub('.rds','',f),celltype=names(tmp),marker=unname(tmp),stringsAsFactors = F))
	}
}

write.csv(res,file='/celltype/tabulasapiens/template/template.csv',row.names=F)
