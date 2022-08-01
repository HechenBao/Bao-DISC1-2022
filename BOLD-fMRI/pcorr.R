#remove MD PCN from original
{
A1p=A1[,-c(13,18,22,25)]
A2p=A2[,-c(13,18,22,25)]
A3p=A3[,-c(13,18,22,25)]
A4p=A4[,-c(13,18,22,25)]
A5p=A5[,-c(13,18,22,25)]
A6p=A6[,-c(13,18,22,25)]
A7p=A7[,-c(13,18,22,25)]
A8p=A8[,-c(13,18,22,25)]
B1p=B1[,-c(13,18,22,25)]
B2p=B2[,-c(13,18,22,25)]
B3p=B3[,-c(13,18,22,25)]
B4p=B4[,-c(13,18,22,25)]
B5p=B5[,-c(13,18,22,25)]
B6p=B6[,-c(13,18,22,25)]
B7p=B7[,-c(13,18,22,25)]
B8p=B8[,-c(13,18,22,25)]
}


# basic partial correlation
{
  A1.pcor.mean=pcor_region(A1p)
  A2.pcor.mean=pcor_region(A2p)
  A3.pcor.mean=pcor_region(A3p)
  A4.pcor.mean=pcor_region(A4p)
  A5.pcor.mean=pcor_region(A5p)
  A6.pcor.mean=pcor_region(A6p)
  A7.pcor.mean=pcor_region(A7p)
  A8.pcor.mean=pcor_region(A8p)
  B1.pcor.mean=pcor_region(B1p)
  B2.pcor.mean=pcor_region(B2p)
  B3.pcor.mean=pcor_region(B3p)
  B4.pcor.mean=pcor_region(B4p)
  B5.pcor.mean=pcor_region(B5p)
  B6.pcor.mean=pcor_region(B6p)
  B7.pcor.mean=pcor_region(B7p)
  B8.pcor.mean=pcor_region(B8p)
  
  A1.pcor.mean.left=pcor_region(A1,subset=T,subset.name=left)
  A2.pcor.mean.left=pcor_region(A2,subset=T,subset.name=left)
  A3.pcor.mean.left=pcor_region(A3,subset=T,subset.name=left)
  A4.pcor.mean.left=pcor_region(A4,subset=T,subset.name=left)
  A5.pcor.mean.left=pcor_region(A5,subset=T,subset.name=left)
  A6.pcor.mean.left=pcor_region(A6,subset=T,subset.name=left)
  A7.pcor.mean.left=pcor_region(A7,subset=T,subset.name=left)
  A8.pcor.mean.left=pcor_region(A8,subset=T,subset.name=left)
  A1.pcor.mean.right=pcor_region(A1,subset=T,subset.name=right)
  A2.pcor.mean.right=pcor_region(A2,subset=T,subset.name=right)
  A3.pcor.mean.right=pcor_region(A3,subset=T,subset.name=right)
  A4.pcor.mean.right=pcor_region(A4,subset=T,subset.name=right)
  A5.pcor.mean.right=pcor_region(A5,subset=T,subset.name=right)
  A6.pcor.mean.right=pcor_region(A6,subset=T,subset.name=right)
  A7.pcor.mean.right=pcor_region(A7,subset=T,subset.name=right)
  A8.pcor.mean.right=pcor_region(A8,subset=T,subset.name=right)
  
  B1.pcor.mean.left=pcor_region(B1,subset=T,subset.name=left)
  B2.pcor.mean.left=pcor_region(B2,subset=T,subset.name=left)
  B3.pcor.mean.left=pcor_region(B3,subset=T,subset.name=left)
  B4.pcor.mean.left=pcor_region(B4,subset=T,subset.name=left)
  B5.pcor.mean.left=pcor_region(B5,subset=T,subset.name=left)
  B6.pcor.mean.left=pcor_region(B6,subset=T,subset.name=left)
  B7.pcor.mean.left=pcor_region(B7,subset=T,subset.name=left)
  B8.pcor.mean.left=pcor_region(B8,subset=T,subset.name=left)
  B1.pcor.mean.right=pcor_region(B1,subset=T,subset.name=right)
  B2.pcor.mean.right=pcor_region(B2,subset=T,subset.name=right)
  B3.pcor.mean.right=pcor_region(B3,subset=T,subset.name=right)
  B4.pcor.mean.right=pcor_region(B4,subset=T,subset.name=right)
  B5.pcor.mean.right=pcor_region(B5,subset=T,subset.name=right)
  B6.pcor.mean.right=pcor_region(B6,subset=T,subset.name=right)
  B7.pcor.mean.right=pcor_region(B7,subset=T,subset.name=right)
  B8.pcor.mean.right=pcor_region(B8,subset=T,subset.name=right)
  
  A.pcor.left=list(A1.pcor.mean.left,A2.pcor.mean.left,A3.pcor.mean.left,A4.pcor.mean.left,
                   A5.pcor.mean.left,A6.pcor.mean.left,A7.pcor.mean.left,A8.pcor.mean.left)
  B.pcor.left=list(B1.pcor.mean.left,B2.pcor.mean.left,B3.pcor.mean.left,B4.pcor.mean.left,
                   B5.pcor.mean.left,B6.pcor.mean.left,B7.pcor.mean.left,B8.pcor.mean.left)
  A.pcor.right=list(A1.pcor.mean.right,A2.pcor.mean.right,A3.pcor.mean.right,A4.pcor.mean.right,
                    A5.pcor.mean.right,A6.pcor.mean.right,A7.pcor.mean.right,A8.pcor.mean.right)
  B.pcor.right=list(B1.pcor.mean.right,B2.pcor.mean.right,B3.pcor.mean.right,B4.pcor.mean.right,
                    B5.pcor.mean.right,B6.pcor.mean.right,B7.pcor.mean.right,B8.pcor.mean.right)
  
  A.pcor=list(A1.pcor.mean,A2.pcor.mean,A3.pcor.mean,A4.pcor.mean,
              A5.pcor.mean,A6.pcor.mean,A7.pcor.mean,A8.pcor.mean)
  B.pcor=list(B1.pcor.mean,B2.pcor.mean,B3.pcor.mean,B4.pcor.mean,
              B5.pcor.mean,B6.pcor.mean,B7.pcor.mean,B8.pcor.mean)
  
}

# a single p-value from multiple p-values (Fisher's method)
sum_p_cor(A.pcor)
sum_p_cor(B.pcor)

# compare A and B --- calculate ANOVA p-values using left and right as covariates (partial correlation)
{
  A1.pcor.mean=combine_pcor_region(subset(A1,select=left),subset(A1,select=right))
  A2.pcor.mean=combine_pcor_region(subset(A2,select=left),subset(A2,select=right))
  A3.pcor.mean=combine_pcor_region(subset(A3,select=left),subset(A3,select=right))
  A4.pcor.mean=combine_pcor_region(subset(A4,select=left),subset(A4,select=right))
  A5.pcor.mean=combine_pcor_region(subset(A5,select=left),subset(A5,select=right))
  A6.pcor.mean=combine_pcor_region(subset(A6,select=left),subset(A6,select=right))
  A7.pcor.mean=combine_pcor_region(subset(A7,select=left),subset(A7,select=right))
  A8.pcor.mean=combine_pcor_region(subset(A8,select=left),subset(A8,select=right))
  
  B1.pcor.mean=combine_pcor_region(subset(B1,select=left),subset(B1,select=right))
  B2.pcor.mean=combine_pcor_region(subset(B2,select=left),subset(B2,select=right))
  B3.pcor.mean=combine_pcor_region(subset(B3,select=left),subset(B3,select=right))
  B4.pcor.mean=combine_pcor_region(subset(B4,select=left),subset(B4,select=right))
  B5.pcor.mean=combine_pcor_region(subset(B5,select=left),subset(B5,select=right))
  B6.pcor.mean=combine_pcor_region(subset(B6,select=left),subset(B6,select=right))
  B7.pcor.mean=combine_pcor_region(subset(B7,select=left),subset(B7,select=right))
  B8.pcor.mean=combine_pcor_region(subset(B8,select=left),subset(B8,select=right))
  
  A.pcor=list(A1.pcor.mean,A2.pcor.mean,A3.pcor.mean,A4.pcor.mean,
              A5.pcor.mean,A6.pcor.mean,A7.pcor.mean,A8.pcor.mean)
  B.pcor=list(B1.pcor.mean,B2.pcor.mean,B3.pcor.mean,B4.pcor.mean,
              B5.pcor.mean,B6.pcor.mean,B7.pcor.mean,B8.pcor.mean)
  
}
cor_diff(fisher_transfer(A.pcor),fisher_transfer(B.pcor),method="t.test")

# compare A and B --- calculate p-values for A vs. B (partial correlation) 
cor_diff(fisher_transfer(A.pcor),fisher_transfer(B.pcor),method="t.test")
cor_diff(fisher_transfer(A.pcor.left),fisher_transfer(B.pcor.left),method="t.test")
cor_diff(fisher_transfer(A.pcor.right),fisher_transfer(B.pcor.right),method="t.test")

# convert matrix format to 3-column network format
matrix2network<-function(x,t=1){
  name=colnames(x)
  v1=c()
  v2=c()
  v3=c()
  n=nrow(x)
  for(i in 1:(n-1)){
    for(j in (i+1):n){
      if(x[i,j]<t){
        v1=c(v1,name[i])
        v2=c(v2,name[j])
        v3=c(v3,-log10(x[i,j]+1e-255))
      }
    }
  }
  v=data.frame(v1,v2,v3)
  return(v)
}

# convert matrix format to 3-column network format
matrix2network<-function(x,t=0.05){
  name=colnames(x)
  v1=c()
  v2=c()
  v3=c()
  n=nrow(x)
  for(i in 1:(n-1)){
    for(j in (i+1):n){
      v1=c(v1,name[i])
      v2=c(v2,name[j])
      v3=c(v3,x[i,j])
    }
  }
  v=data.frame(v1,v2,v3)
  return(v)
}


write.csv(cor_diff(fisher_transfer(A.pcor),fisher_transfer(B.pcor),method="t.test"),"20190712_result\\double_check\\combine_pcor_A_vs.B_diff_final.csv")


#write.table(matrix2network(sum_p_cor(A.pcor)[-9,-9]),"20190712_result\\double_check\\A_combine_network_final.csv",quote=F,row.names = F,sep=",")
#write.table(matrix2network(sum_p_cor(B.pcor)[-9,-9]),"20190712_result\\double_check\\B_combine_network_final.csv",quote=F,row.names = F,sep=",")

#rho threshold 0.1 or 0.05
pA=matrix2network(sum_p_cor(A.pcor)[-9,-9])
rA=matrix2network(cal_mean(A.pcor)[-9,-9])
pA$rho=rA$v3
colnames(pA)[3]="p_val"
pA$FDR=p.adjust(pA$p_val,method="bonferroni")
write.table(pA,"20190712_result\\double_check\\A_combine_network_final.csv",quote=F,row.names = F,sep=",")


pB=matrix2network(sum_p_cor(B.pcor)[-9,-9])
rB=matrix2network(cal_mean(B.pcor)[-9,-9])
pB$rho=rB$v3
colnames(pB)[3]="p_val"
pB$FDR=p.adjust(pB$p_val,method="bonferroni")
write.table(pB,"20190712_result\\double_check\\B_combine_network_final.csv",quote=F,row.names = F,sep=",")



#heatmap examples
heatmap.2(-log10(dia_transfer(sum_p_cor(A.cor),0.99)+1e-100),trace="none",col=bluered(100))
heatmap.2(col_adjust(sum_p_cor(A.pcor)),trace="none",
          col=c("black",rgb(0.25,0,0),rgb(0.5,0,0),rgb(0.75,0,0),rgb(1,0,0)))
heatmap.2(col_adjust(sum_p_cor(B.pcor)),trace="none",
          col=c("black",rgb(0.25,0,0),rgb(0.5,0,0),rgb(0.75,0,0),rgb(1,0,0)))
heatmap.2(col_adjust(sum_p_cor(A.pcor.left)),trace="none",
          col=c("black",rgb(0.25,0,0),rgb(0.5,0,0),rgb(0.75,0,0),rgb(1,0,0)))
heatmap.2(col_adjust(sum_p_cor(A.pcor.right)),trace="none",
          col=c("black",rgb(0.25,0,0),rgb(0.5,0,0),rgb(0.75,0,0),rgb(1,0,0)))
heatmap.2(col_adjust(sum_p_cor(B.pcor.left)),trace="none",
          col=c("black",rgb(0.25,0,0),rgb(0.5,0,0),rgb(0.75,0,0),rgb(1,0,0)))
heatmap.2(col_adjust(sum_p_cor(B.pcor.right)),trace="none",
          col=c("black",rgb(0.25,0,0),rgb(0.5,0,0),rgb(0.75,0,0),rgb(1,0,0)))

#anova two groups pcorr combine
t=combine_cor_diff(d1=fisher_transfer(A.pcor.left),d2=fisher_transfer(B.pcor.left),
                   d3=fisher_transfer(A.pcor.right),d4=fisher_transfer(B.pcor.right),method="t.test")
t=dia_transfer(t,NA)
colnames(t)=ROI_names
rownames(t)=ROI_names
#write.csv(t,"20190712_result\\double_check\\combine_pcorr_2wANOVA_test_pval_final.csv")

#FDR
t1=matrix2network(t)
t1$FDR=p.adjust(t1$v3,method="BH")


#output example command
#write.csv(sum_p_cor(A.pcor),"partial_correlation_A_group_summary_p_whole.csv")
#write.table(matrix2network(sum_p_cor(A.pcor)),"A_whole_brain_network.csv"
#            ,quote=F,row.names = F,sep=",")


#ROI+1 for cov exclusion
a=sum_p_cor(A.pcor)[-9,-9]
colnames(a)=ROI_names
rownames(a)=ROI_names
a=melt(a)
a$id=paste(a$Var1,a$Var2,sep="-")
colnames(a)[3]="A_pVal"
b=sum_p_cor(B.pcor)[-9,-9]
colnames(b)=ROI_names
rownames(b)=ROI_names
b=melt(b)
b$id=paste(b$Var1,b$Var2,sep="-")
colnames(b)[3]="B_pVal"
d=read.csv("20190712_result\\double_check\\combine_pcorr_2wANOVA_test_pval_final.csv")
d=d[,-1]
d=d[-9,-9]
row.names(d)=colnames(d)
d=melt(as.matrix(d))
d$id=paste(d$Var1,d$Var2,sep="-")
colnames(d)[3]="diff_A_B_pVal"

f=merge(merge(a,b,by="id"),d,by="id")
f$log.A_pVal=-log10(f$A_pVal+1e-300)
f$log.B_pVal=-log10(f$B_pVal+1e-300)
f$log.AminusB=f$log.A_pVal-f$log.B_pVal
f=f[f$Var1.x!=f$Var2.x,]
write.csv(f,"20190712_result\\double_check\\network.csv")
