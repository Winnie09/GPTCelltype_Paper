library(data.table)
a <- fread('/celltype/hcl/data/raw/anno.csv',data.table=F)

library(anndata)
d <- read_h5ad('/celltype/hcl/data/raw/HCL_Fig1_adata.h5ad')
d <- t(d$X)
colnames(d) <- sub('-[0-9]$','',colnames(d))
saveRDS(d,file='/celltype/hcl/data/proc/count.rds')
d <- t(log2(t(d)/colSums(d)*10000+1))
rownames(a) <- a[,1]
a <- a[colnames(d),]
saveRDS(a,file='/celltype/hcl/data/proc/anno.rds')
saveRDS(d,file='/celltype/hcl/data/proc/norm.rds')

