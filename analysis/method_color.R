library(ggsci)
v = pal_npg(palette = c("nrc"), alpha = 0.9)(9)
v[1] = 'orange'
coldf = data.frame(method = c('GTEx','Azimuth', 'BCL','coloncancer', 'TS', 'lungcancer','MCA','HCL', 'literature','cancer'),
                   color = c(v, v[6]),
                   stringsAsFactors = F)
saveRDS(coldf, '/Users/wenpinhou/Dropbox/gptcelltype/analysis/method_color.rds')

show_col(v)
 
