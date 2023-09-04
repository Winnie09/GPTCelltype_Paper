d1 <- readRDS('/celltype/cancer/bcl/SingleR/res.rds')
d1 <- data.frame(dataset='BCL',tissue='B cell lymphoma',celltype=d1[,1],annotation=d1[,2])

d2 <- readRDS('/celltype/cancer/coloncancer/SingleR/res.rds')
d2 <- data.frame(dataset='coloncancer',tissue='colon cancer',celltype=d2[,1],annotation=d2[,2])

d3 <- readRDS('/celltype/cancer/lungcancer/SingleR/res.rds')
d3 <- data.frame(dataset='lungcancer',tissue='lung cancer and brain metastasis',celltype=d3[,1],annotation=d3[,2])

af <- list.files('/celltype/hca/SingleR/res/')
d4 <- do.call(rbind,sapply(af,function(f) {
	k <- readRDS(paste0('/celltype/hca/SingleR/res/',f,'/res.rds'))
	data.frame(dataset='HCA',tissue=sub('Skeletal_muscle','Skeletal muscle',sub('Esophagus_mucosa','Esophagus',f)),celltype=k[,1],annotation=k[,2])
},simplify = F))

d5 <- readRDS('/celltype/hcl/SingleR/res.rds')
d5 <- data.frame(dataset='HCL',tissue='NA',celltype=d5[,1],annotation=d5[,2])

d6 <- readRDS('/celltype/mca/SingleR/res.rds')
d6 <- data.frame(dataset='MCA',tissue='NA',celltype=d6[,1],annotation=d6[,2])

af <- list.files('/celltype/tabulasapiens/SingleR/res/')
d7 <- do.call(rbind,sapply(af,function(f) {
	k <- readRDS(paste0('/celltype/tabulasapiens/SingleR/res/',f,'/res.rds'))
	data.frame(dataset='tabulasapiens',tissue=sub('_',' ',f),celltype=k[,1],annotation=k[,2])
},simplify = F))

d <- rbind(d1,d2,d3,d4,d5,d6,d7)
write.csv(d,file='/celltype/agg/SingleR.csv',row.names=F)


