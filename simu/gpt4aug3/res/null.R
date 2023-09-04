library(org.Hs.eg.db)
gn <- unique(unlist(as.list(org.Hs.egSYMBOL)))
d <- read.csv('Dropbox/research/gptcelltype/anno/tabulasapiens_nuc_lit/proc.csv',as.is=T)
d <- d[d[,1]=='Breast',]
set.seed(1)
am <- do.call(rbind,sapply(1:10,function(simuround) {
  m <- t(sapply(1:10,function(id) {
    c('random',paste0(sample(gn,10),collapse = ','))
  }))
  colnames(m) <- c('celltype','gene')
  m <- rbind(m,d[sample(1:nrow(d),10),2:3])
  m <- cbind(simuround,m)  
},simplify = F))

write.csv(am,'Dropbox/research/gptcelltype/simu/null.csv',row.names = F)
