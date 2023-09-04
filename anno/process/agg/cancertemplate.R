
d <- readRDS('/celltype/cancer/bcl/diff/diff.rds')
r1 <- do.call(rbind,sapply(c(10,20,30),function(n) {
	k <- tapply(d$gene,list(d$cluster),function(i) paste0(i[1:n],collapse=','))
	data.frame(dataset=paste0('BCL_top',n),tissue='sorted immune cells',celltype=names(k),Category=NA,marker=k)
},simplify = F))

d <- readRDS('/celltype/cancer/coloncancer/diff/diff.rds')
r2 <- do.call(rbind,sapply(c(10,20,30),function(n) {
	k <- tapply(d$gene,list(d$cluster),function(i) paste0(i[1:n],collapse=','))
	data.frame(dataset=paste0('coloncancer_top',n),tissue='colon',celltype=names(k),Category=NA,marker=k)
},simplify = F))

d <- readRDS('/celltype/cancer/lungcancer/diff/diff.rds')
r3 <- do.call(rbind,sapply(c(10,20,30),function(n) {
	k <- tapply(d$gene,list(d$cluster),function(i) paste0(i[1:n],collapse=','))
	data.frame(dataset=paste0('lungcancer_top',n),tissue='lung and brain',celltype=names(k),Category=NA,marker=k)
},simplify = F))

r <- rbind(r1,r2,r3)
write.csv(r,file='/celltype/agg/cancer.csv')
