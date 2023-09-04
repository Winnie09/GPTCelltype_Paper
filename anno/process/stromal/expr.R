d <- readRDS('/celltype/cancer/lungcancer/data/proc/norm.rds')
ct <- readRDS('/celltype/cancer/lungcancer/data/proc/ct.rds')
d <- d[c('COL1A1','COL1A2','COL2A1'),names(ct)]
d <- aggregate(t(d),list(ct),mean)
saveRDS(d,file='/celltype/stromal/expr/lungcancer.rds')

d <- readRDS('/celltype/mca/data/proc/norm.rds')
ct <- readRDS('/celltype/mca/data/proc/anno.rds')
d <- d[c('Col1a1','Col1a2','Col2a1'),ct[,1]]
d <- aggregate(t(d),list(ct$celltype),mean)
saveRDS(d,file='/celltype/stromal/expr/mca.rds')


d <- readRDS('/celltype/hcl/data/proc/norm.rds')
ct <- readRDS('/celltype/hcl/data/proc/anno.rds')
d <- d[c('COL1A1','COL1A2','COL2A1'),ct[,1]]
d <- aggregate(t(d),list(ct$celltype),mean)
saveRDS(d,file='/celltype/stromal/expr/hcl.rds')


library(Matrix)
af <- list.files('/celltype/hca/data/proc')
d <- sapply(af,function(f) {
	d <- readRDS(paste0('/celltype/hca/data/proc/',f,'/norm.rds'))
	ct <- readRDS(paste0('/celltype/hca/data/proc/',f,'/ct.rds'))
	d <- d[c('COL1A1','COL1A2','COL2A1'),names(ct)]
	d <- aggregate(t(as.matrix(d)),list(ct),mean)
},simplify = F)
saveRDS(d,file='/celltype/stromal/expr/hca.rds')


library(Matrix)
af <- list.files('/celltype/tabulasapiens/data/norm')
d <- sapply(af,function(f) {
	d <- readRDS(paste0('/celltype/tabulasapiens/data/norm/',f))
	ct <- readRDS(paste0('/celltype/tabulasapiens/data/meta/',f))
	d <- d[c('COL1A1','COL1A2','COL2A1'),ct[,1]]
	d <- aggregate(t(as.matrix(d)),list(ct$cell_ontology_class),mean)
},simplify = F)
saveRDS(d,file='/celltype/stromal/expr/tabulasapiens.rds')

