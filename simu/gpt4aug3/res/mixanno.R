d <- read.csv('Dropbox/research/gptcelltype/anno/GPT4_mar23/tabulasapiens_nuc_lit/proc.csv',as.is=T)
d <- d[d[,1]=='Breast',]
set.seed(1)
am <- do.call(rbind,sapply(1:10,function(simuround) {
  m <- t(sapply(1:10,function(id) {
    i <- sample(1:nrow(d),2)
    c(paste0(d[i,2],collapse = ','),paste0(sample(as.vector(d[i,3])),collapse = ', '))
  }))
  colnames(m) <- c('celltype','gene')
  m <- rbind(m,d[sample(1:nrow(d),10),2:3])
  m <- cbind(simuround,m)  
},simplify = F))

write.csv(am,'Dropbox/research/gptcelltype/simu/mixanno.csv',row.names = F)
