library(Seurat)
ct <- readRDS('/celltype/coloncancer/data/proc/ct.rds')
d <- readRDS('/celltype/coloncancer/data/proc/norm.rds')
k <- CreateSeuratObject(d)
k@meta.data$orig.ident <- ct
Idents(k) <- ct
g <- FindAllMarkers(k)
saveRDS(g,file='/celltype/coloncancer/data/diff.rds')
