bcl <- table(readRDS('/celltype/cancer/bcl/data/proc/ct.rds'))
bcl <- data.frame(dataset='BCL',tissue='B cell lymphoma',celltype=names(bcl),number=as.vector(bcl),stringsAsFactors = F)
coloncancer <- table(readRDS('/celltype/cancer/coloncancer/data/proc/ct.rds'))
coloncancer <- data.frame(dataset='coloncancer',tissue='colon cancer',celltype=names(coloncancer),number=as.vector(coloncancer),stringsAsFactors = F)
lungcancer <- table(readRDS('/celltype/cancer/lungcancer/data/proc/ct.rds'))
lungcancer <- data.frame(dataset='lungcancer',tissue='lung cancer and brain metastasis',celltype=names(lungcancer),number=as.vector(lungcancer),stringsAsFactors = F)

hcaf <- list.files('/celltype/hca/data/proc/')
hca <- sapply(hcaf,function(sf) {
	table(readRDS(paste0('/celltype/hca/data/proc/',sf,'/ct.rds')))
},simplify = F)
hca <- do.call(rbind,sapply(names(hca),function(i) {
	data.frame(dataset='HCA',tissue=i,celltype=names(hca[[i]]),number=as.vector(hca[[i]]),stringsAsFactors = F)
},simplify = F))

hcl <- table(readRDS('/celltype/hcl/data/proc/anno.rds')$celltype)
hcl <- data.frame(dataset='HCL',tissue=NA,celltype=names(hcl),number=as.vector(hcl),stringsAsFactors = F)

mca <- table(readRDS('/celltype/mca/data/proc/anno.rds')$celltype)
mca <- data.frame(dataset='MCA',tissue=NA,celltype=names(mca),number=as.vector(mca),stringsAsFactors = F)

tsf <- list.files('/celltype/tabulasapiens/data/meta/')
ts <- sapply(tsf,function(sf) {
	table(readRDS(paste0('/celltype/tabulasapiens/data/meta/',sf))$cell_ontology_class)
},simplify = F)
ts <- do.call(rbind,sapply(names(ts),function(i) {
	data.frame(dataset='tabulasapiens',tissue=sub('.rds','',i),celltype=names(ts[[i]]),number=as.vector(ts[[i]]),stringsAsFactors = F)
},simplify = F))

d <- rbind(bcl,coloncancer,lungcancer,hca,hcl,mca,ts)
saveRDS(d,file='/celltype/numcell/numcell.rds')
