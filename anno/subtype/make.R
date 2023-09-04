d <- read.csv('/Users/zhichengji/Dropbox/research/gptcelltype/anno/compiled/all.csv',as.is=T)
ct <- sort(unique(sub('cells','cell',tolower(d$manual_annotation))))
write.csv(data.frame(celltype=ct),file='/Users/zhichengji/Dropbox/research/gptcelltype/anno/subtype/list.csv',row.names=F)
					