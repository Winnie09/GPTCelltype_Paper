library(data.table)
a <- fread('/celltype/mca/data/raw/celltype.csv',data.table=F)
cl <- fread('/celltype/mca/data/raw/cluster.csv',data.table=F)

cl$celltype <- a[match(cl[,2],a[,1]),2]

d <- fread('/celltype/mca/data/raw/Figure2-batch-removed.txt',data.table=F)
rownames(d) <- d[,1]
d <- as.matrix(d[,-1])
saveRDS(d,file='/celltype/mca/data/proc/count.rds')
d <- log2(t(t(d)/colSums(d)*10000)+1)
saveRDS(cl,file='/celltype/mca/data/proc/anno.rds')
saveRDS(d,file='/celltype/mca/data/proc/norm.rds')

