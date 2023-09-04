bcl <- readRDS('celltype/cancer/bcl/SingleR/time.rds')[3]
bcl <- data.frame(dataset='BCL',tissue='B cell lymphoma',time=as.vector(bcl),stringsAsFactors = F)
coloncancer <- readRDS('celltype/cancer/coloncancer/SingleR/time.rds')[3]
coloncancer <- data.frame(dataset='coloncancer',tissue='colon cancer',time=as.vector(coloncancer),stringsAsFactors = F)
lungcancer <- readRDS('celltype/cancer/lungcancer/SingleR/time.rds')[3]
lungcancer <- data.frame(dataset='lungcancer',tissue='lung cancer and brain metastasis',time=as.vector(lungcancer),stringsAsFactors = F)

af <- list.files('celltype/hca/SingleR/res')
hca <- sapply(af,function(f){
	unname(readRDS(paste0('celltype/hca/SingleR/res/',f,'/time.rds'))[3])
})
hca <- data.frame(dataset='HCA',tissue=names(hca),time=hca)

hcl <- readRDS('celltype/hcl/SingleR/time.rds')[3]
hcl <- data.frame(dataset='HCL',tissue=NA,time=as.vector(hcl),stringsAsFactors = F)

mca <- readRDS('celltype/mca/SingleR/time.rds')[3]
mca <- data.frame(dataset='MCA',tissue=NA,time=as.vector(mca),stringsAsFactors = F)


af <- list.files('celltype/tabulasapiens/SingleR/res')
ts <- sapply(af,function(f){
	unname(readRDS(paste0('celltype/tabulasapiens/SingleR/res/',f,'/time.rds'))[3])
})
ts <- data.frame(dataset='tabulasapiens',tissue=names(ts),time=ts)

d <- rbind(bcl,coloncancer,lungcancer,hca,hcl,mca,ts)
saveRDS(d,file='celltype/runtime/SingleR.rds')
