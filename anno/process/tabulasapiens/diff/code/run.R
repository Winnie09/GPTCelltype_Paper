library(Seurat)
af <- list.files('/celltype/tabulasapiens/data/norm')
f <- af[as.numeric(commandArgs(trailingOnly = T))]

if (!file.exists(paste0('/celltype/tabulasapiens/diff/res/',f))) {
ct <- readRDS(paste0('/celltype/tabulasapiens/data/meta/',f))
d <- readRDS(paste0('/celltype/tabulasapiens/data/norm/',f))
k <- CreateSeuratObject(d)
Idents(k) <- k@meta.data$orig.ident <- ct$cell_ontology_class
g <- FindAllMarkers(k)
saveRDS(g,file=paste0('/celltype/tabulasapiens/diff/res/',f))
}
