library(data.table)
a <- fread('/celltype/coloncancer/data/raw/GSE132465_GEO_processed_CRC_10X_cell_annotation.txt.gz',data.table=F)
d <- fread('/celltype/coloncancer/data/raw/GSE132465_GEO_processed_CRC_10X_natural_log_TPM_matrix.txt.gz',data.table=F)
m <- fread('/celltype/coloncancer/data/raw/GSE132465_GEO_processed_CRC_10X_raw_UMI_count_matrix.txt.gz',data.table=F)
rownames(d) <- d[,1]
d <- as.matrix(d[,-1])
rownames(m) <- m[,1]
m <- as.matrix(m[,-1])
ct <- a$Cell_type
ct[a$Cell_subtype%in%c('CMS1','CMS2','CMS3','CMS4')] <- 'colon cancer cell'
names(ct) <- a[,1]
saveRDS(ct,file='/celltype/coloncancer/data/proc/ct.rds')
saveRDS(d,file='/celltype/coloncancer/data/proc/norm.rds')
saveRDS(m,file='/celltype/coloncancer/data/proc/count.rds')
