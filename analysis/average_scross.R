source('/Users/wenpinhou/Dropbox/resource/ggplot_theme.R')
pd.rob = readRDS('/Users/wenpinhou/Dropbox/gptcelltype/plot/robustness.rds')
pd.subset = readRDS('/Users/wenpinhou/Dropbox/gptcelltype/plot/simu_subset.rds')
pd.noise = readRDS('/Users/wenpinhou/Dropbox/gptcelltype/plot/simu_noise.rds')
pd.subset$type = 'subset'
pd.noise$type = 'noise'
colnames(pd.subset)[1] <- colnames(pd.noise)[1] <- 'SignalStrength'
library(ggplot2)
library(egg)
p1 <- ggplot(data = pd.rob, aes(x=value,y=type)) + 
  geom_violin(scale = 'width') + 
  geom_point(size = 0.8, alpha = 0.6, stroke = 0) +  
  xlab('proportion') + 
  ylab('') + 
  coord_cartesian(xlim=c(0,1)) + 
  facet_wrap(type~.,ncol=1,scale='free') + 
  xlab('') + 
  theme(legend.background = element_blank(),strip.background = element_blank()) +
  theme(strip.text = element_blank())
  
p2 <- ggplot(data = pd.subset, aes(x=value,y=SignalStrength, fill = SignalStrength))+
  geom_violin(scale = 'width') + 
  geom_point(size = 0.8, alpha = 0.6, stroke = 0) +  
  xlab('proportion') + 
  ylab('') + 
  coord_cartesian(xlim=c(0,1)) + 
  facet_wrap(type~.,ncol=1,scale='free') + 
  xlab('') + 
  theme(legend.background = element_blank(),strip.background = element_blank()) +
  theme(strip.text = element_blank())+
  scale_fill_brewer(palette = 'Blues', direction = -1) +
  theme(legend.position = 'none')

p3 <- ggplot(data = pd.noise, aes(x=value,y=SignalStrength, fill = SignalStrength)) + 
  geom_violin(scale = 'width') + 
  geom_point(size = 0.8, alpha = 0.6, stroke = 0) +  
  xlab('proportion') + 
  ylab('') + 
  coord_cartesian(xlim=c(0,1)) + 
  facet_wrap(type~.,ncol=1,scale='free') + 
  xlab('') + 
  theme(legend.background = element_blank(),strip.background = element_blank()) +
  theme(strip.text = element_blank())+
  scale_fill_brewer(palette = 'Blues', direction = -1) +
  theme(legend.position = 'none')

pdf('/Users/wenpinhou/Dropbox/gptcelltype/plot/averaged_score.pdf',width=2.5,height=3, onefile=FALSE)
ggarrange(p1,p2,p3,ncol = 1, heights = c(4,2,2))
dev.off()
