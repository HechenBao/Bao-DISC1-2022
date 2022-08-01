cal_cor_mean<-function(d1,d2=NULL){
  d=d1[[1]]$rho
  for(i in 2:length(d1)){
    d=d+d1[[i]]$rho
  }
  if(length(d2)>0){
    for(i in 1:length(d2)){
      d=d+d2[[i]]$rho
    }
  }
  d=d/(length(d1)+length(d2))
  return(d)
}

#corr node importance
{
s1=cal_cor_mean(A.cor.left,A.cor.right)
s1=cal_cor_mean(fisher_transfer(A.cor.left),fisher_transfer(A.cor.right))
colnames(s1)=ROI_names
rownames(s1)=ROI_names
s1=dia_transfer(s1,NA)
#write.csv(s1,"20190712_result\\corr\\A_raw_correlation_matrix5.csv")

s2=cal_cor_mean(B.cor.left,B.cor.right)
s2=cal_cor_mean(fisher_transfer(B.cor.left),fisher_transfer(B.cor.right))
colnames(s2)=ROI_names
rownames(s2)=ROI_names
s2=dia_transfer(s2,NA)
#heatmap.2(dia_transfer(s2,max(s2)),trace="none",col= colorRampPalette(colors = c("blue", "yellow", "red"))(100))


#heatmap.2(dia_transfer(s2,max(s2)),trace="none",col= brewer.pal(9,"Blues"))
#heatmap.2(dia_transfer(s1,max(s1)),trace="none",col= brewer.pal(9,"Blues"))
ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=h$value))+scale_fill_gradient2(low="royalblue4",mid="white",high="firebrick1",midpoint=0)

#write.csv(s2,"20190712_result\\corr\\B_raw_correlation_matrix5.csv")

s3=s1-s2
colnames(s3)=ROI_names
rownames(s3)=ROI_names
#write.csv(s3,"20190712_result\\double_check\\diff_raw_correlation_matrix_final.csv")
}

#pcor node importance
{
q1=cal_cor_mean(A.pcor)
q1=cal_cor_mean(fisher_transfer(A.pcor))
q1=q1[-9,-9]
q1=dia_transfer(q1,NA)
colnames(q1)=ROI_names
rownames(q1)=ROI_names
#write.csv(q1,"20190712_result\\pcorr\\A_pcorr_matrix5.csv")

q2=cal_cor_mean(B.pcor)
q2=cal_cor_mean(fisher_transfer(B.pcor))
q2=q2[-9,-9]
q2=dia_transfer(q2,NA)
colnames(q2)=ROI_names
rownames(q2)=ROI_names
#heatmap.2(dia_transfer(q2,max(q2)),trace="none",col= brewer.pal(9,"Blues"))
#write.csv(q2,"20190712_result\\pcorr\\B_pcorrp_matrix5.csv")

q3=q1-q2
write.csv(q3,"20190712_result\\double_check\\diff_pcorr_matrix_final.csv")
}

## corr plot
{
s1=cal_cor_mean(fisher_transfer(A.cor.left),fisher_transfer(A.cor.right))
colnames(s1)=ROI_names
rownames(s1)=ROI_names
#s1_p=dia_transfer(s1,0)
s1_p[1,1]=0
s1_p[2,2]=1
s1_p[3,3]=0
s1_p=as.data.frame(s1_p)
s1_p$id=row.names(s1_p)
h=melt(s1_p,id.vars = "id")
h$variable=factor(h$variable,levels=c("DG","CA3","Sub","CA1","IC","TH","EC","HYTH"))
h$id=factor(h$id,levels=c("DG","CA3","Sub","CA1","IC","TH","EC","HYTH"))

#ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=h$value))+scale_fill_gradient2(mid="azure",high="red")
#ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=h$value))+scale_fill_gradient(brewer.pal(9,"Blues"),trans="reverse")
#ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=h$value))+scale_fill_gradient2(low="royalblue4",mid="white",high="deepskyblue4",midpoint=0,space="rgb")
ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=h$value))+scale_fill_gradient2(low="white",high="firebrick1")
}

{
s2=cal_cor_mean(fisher_transfer(B.cor.left),fisher_transfer(B.cor.right))
colnames(s2)=ROI_names
rownames(s2)=ROI_names
s2_p=dia_transfer(s2,0)
s2_p[1,1]=0
s2_p[2,2]=1
s2_p[3,3]=0
#s2_p[3,3]=-1
s2_p=as.data.frame(s2_p)
s2_p$id=row.names(s2_p)
h=melt(s2_p,id.vars = "id")
h$variable=factor(h$variable,levels=c("DG","CA3","Sub","CA1","IC","TH","EC","HYTH"))
h$id=factor(h$id,levels=c("DG","CA3","Sub","CA1","IC","TH","EC","HYTH"))
#ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=h$value))+scale_fill_gradient(low="grey99",high="deepskyblue4")
#ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=h$value))+scale_fill_gradient2(low="royalblue4",mid="white",high="deepskyblue2",midpoint=0)
#ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=h$value))+scale_fill_gradient2(low=muted("white"),high=muted("deepskyblue4"))
ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=h$value))+scale_fill_gradient2(low="white",high="firebrick1")

}

{
s3=s1-s2
colnames(s3)=ROI_names
rownames(s3)=ROI_names
s3_p=dia_transfer(s3,0)
max(s3_p)
min(s3_p)
s3_p[1,1]=max(s3_p)
s3_p[2,2]= -max(s3_p)

#s3_p[1,1]=0.06
#s3_p[2,2]=-0.06
s3_p=as.data.frame(s3_p)
s3_p$id=row.names(s3)
h=melt(s3_p,id.vars = "id")
h$variable=factor(h$variable,levels=c("DG","CA3","Sub","CA1","IC","TH","EC","HYTH"))
h$id=factor(h$id,levels=c("DG","CA3","Sub","CA1","IC","TH","EC","HYTH"))

#h$variable=factor(h$variable,levels=c("IC","CA3","EC","Sub","CA1","TH","DG","HYTH"))
#h$id=factor(h$id,levels=c("IC","CA3","EC","Sub","CA1","TH","DG","HYTH"))


#ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=h$value))+scale_fill_gradient2(low="dodgerblue4",mid="white",high="darkorange",midpoint=0)
#ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=h$value))+scale_fill_gradient2(low="royalblue4",mid="white",high="firebrick1",midpoint=0)
ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=h$value))+scale_fill_gradient2(low=("deepskyblue4"),mid="white",high=("firebrick1"),midpoint=0)
}

## partial corr plot
{
q1=cal_cor_mean(A.pcor)
q1=cal_cor_mean(fisher_transfer(A.pcor))
q1=q1[-9,-9]
q1=dia_transfer(q1,NA)
colnames(q1)=ROI_names
rownames(q1)=ROI_names
#write.csv(q1,"20190712_result\\pcorr\\A_pcorr_matrix5.csv")

q2=cal_cor_mean(B.pcor)
q2=cal_cor_mean(fisher_transfer(B.pcor))
q2=q2[-9,-9]
q2=dia_transfer(q2,NA)
colnames(q2)=ROI_names
rownames(q2)=ROI_names
}



{
  q1_p=dia_transfer(q1,0)
  q1_p[1,1]=0
  q1_p[2,2]=0.5
  q1_p[3,3]=0
  q1_p=as.data.frame(q1_p)
  q1_p$id=row.names(q1_p)
  h=melt(q1_p,id.vars = "id")
  h$variable=factor(h$variable,levels=c("DG","CA3","Sub","CA1","IC","TH","EC","HYTH"))
  h$id=factor(h$id,levels=c("DG","CA3","Sub","CA1","IC","TH","EC","HYTH"))
  ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=h$value))+scale_fill_gradient2(low="white",high="firebrick1")
}

{
  q2_p=dia_transfer(q2,0)
  q2_p[1,1]=0
  q2_p[2,2]=0.5
  q2_p[3,3]=0
  q2_p=as.data.frame(q2_p)
  q2_p$id=row.names(q2_p)
  h=melt(q2_p,id.vars = "id")
  h$variable=factor(h$variable,levels=c("DG","CA3","Sub","CA1","IC","TH","EC","HYTH"))
  h$id=factor(h$id,levels=c("DG","CA3","Sub","CA1","IC","TH","EC","HYTH"))
  ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=h$value))+scale_fill_gradient2(low="white",high="firebrick1")
}

{
  q3=q1-q2
  q3_p=dia_transfer(q3,0)
  max(q3_p)
  min(q3_p)
  q3_p[1,1]=max(q3_p)
  q3_p[2,2]= -max(q3_p)
  q3_p=as.data.frame(q3_p)
  q3_p$id=row.names(q3)
  h=melt(q3_p,id.vars = "id")
  h$variable=factor(h$variable,levels=c("DG","CA3","Sub","CA1","IC","TH","EC","HYTH"))
  h$id=factor(h$id,levels=c("DG","CA3","Sub","CA1","IC","TH","EC","HYTH"))
  
  #h$variable=factor(h$variable,levels=c("TH","CA3","CA1","IC","HYTH","DG","EC","Sub"))
  #h$id=factor(h$id,levels=c("TH","CA3","CA1","IC","HYTH","DG","EC","Sub"))
  #ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=h$value))+scale_fill_gradient2(low="dodgerblue4",mid="white",high="darkorange",midpoint=0)
  #ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=h$value))+scale_fill_gradient2(low="royalblue4",mid="white",high="firebrick1",midpoint=0)
  ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=h$value))+scale_fill_gradient2(low=("deepskyblue4"),mid="white",high=("firebrick1"),midpoint=0)
}
