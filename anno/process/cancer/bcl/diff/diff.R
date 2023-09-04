library(Seurat)
ct <- readRDS('/celltype/cancer/bcl/data/proc/ct.rds')
d <- readRDS('/celltype/cancer/bcl/data/proc/norm.rds')
k <- CreateSeuratObject(d)
k@meta.data$orig.ident <- ct
Idents(k) <- ct
g <- FindAllMarkers(k)
saveRDS(g,file='/celltype/cancer/bcl/diff/diff.rds')


