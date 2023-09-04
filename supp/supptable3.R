library(data.table)
d <- fread('Dropbox/research/gptcelltype/anno/compiled/gpt4topgenenumber.csv',data.table=F)
d[,1] <- sub('tabulasapiens_','TS_',sub('HCA_','GTEx_',d[,1]))

colnames(d) <- sub('gpt4aug3_','GPT-4 (Aug 3, 2023) ',colnames(d))
colnames(d) <- sub('_',' ',colnames(d))
write.csv(d,file='Dropbox/research/gptcelltype/supp/SupplementaryTable3.csv',row.names=F)
