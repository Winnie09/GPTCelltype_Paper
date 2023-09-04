library(anndata)
library(Matrix)
d <- anndata::read_h5ad('/celltype/bcl/data/raw/scRNA_BCR_TCR.h5ad')
ct <- oct <- as.character(d$obs$refined_clusters)
ct[grep('B[0-9]*',oct)] <- 'Malignant B cells'
ct[oct=='B0'] <- 'Non-malignant B cells'
ct[grep('CD4 T',oct)] <- 'CD4 T cells'
ct[grep('CD8 T',oct)] <- 'CD8 T cells'
names(ct) <- rownames(d$obs)
m <- t(d$X)
n <- t(log2(d$X/rowSums(d$X)*10000+1))
saveRDS(ct,file='/celltype/bcl/data/proc/ct.rds')
saveRDS(m,file='/celltype/bcl/data/proc/count.rds')
saveRDS(n,file='/celltype/bcl/data/proc/norm.rds')
