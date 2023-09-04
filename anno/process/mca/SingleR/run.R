suppressMessages(library(celldex))
hpca.se <- MouseRNAseqData()
suppressMessages(library(SingleR))
clu <- readRDS('/celltype/mca/data/proc/anno.rds')
cn <- clu[,1]
clu <- clu$celltype
names(clu) <- cn

d <- readRDS('/celltype/mca/data/proc/norm.rds')
rt <- system.time({pred <- SingleR(test = d, ref = hpca.se, assay.type.test=1,labels = hpca.se$label.main)})
saveRDS(pred,file='/celltype/mca/SingleR/fullpred.rds')
saveRDS(rt,file='/celltype/mca/SingleR/time.rds')
mat <- pred$scores
rownames(mat) <- pred@rownames
k <- rowsum(mat[names(clu),],clu)
predct <- colnames(k)[apply(k,1,which.max)]
orict <- rownames(k)
ct <- data.frame(orict=orict,predct=predct)
saveRDS(ct,file='/celltype/mca/SingleR/res.rds')


