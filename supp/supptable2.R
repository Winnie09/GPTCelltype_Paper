library(data.table)
d <- fread('Dropbox/research/gptcelltype/anno/compiled/all.csv',data.table=F)
d[d[,1]=='HCA',1] <- 'GTEx'
d[d[,1]=='tabulasapiens',1] <- 'TS'

colnames(d) <- sub('gpt4aug3_','GPT-4 (Aug 3, 2023) ',colnames(d))
colnames(d) <- sub('gpt4mar23_','GPT-4 (March 23, 2023) ',colnames(d))
colnames(d) <- sub('gpt3.5aug3_','GPT-3.5 (Aug 3, 2023) ',colnames(d))
colnames(d) <- sub('_',' ',colnames(d))
write.csv(d,file='Dropbox/research/gptcelltype/supp/SupplementaryTable2.csv',row.names=F)
