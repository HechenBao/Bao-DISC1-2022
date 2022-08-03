##cross correlation
matrix2networkII<-function(x,t=0.05){
  colnames(x)=ROI_names
  rownames(x)=ROI_names
  name=colnames(x)
  v1=c()
  v2=c()
  v3=c()
  n=nrow(x)
  for(i in 1:n){
    for(j in 1:n){
      v1=c(v1,name[i])
      v2=c(v2,name[j])
      v3=c(v3,x[i,j])
    }
  }
  v=data.frame(v1,v2,v3)
  return(v)
}

m<-function(x){
  a=matrix2networkII(x)
  a=a[a$v1 %in% ROI_names,]
  a=a[a$v2 %in% ROI_names,]
  return(a)
}

{
#left
left_A=lapply(1:8, function(x) m(A.cor.left[[x]]$p))

v=left_A[[1]]
for(i in 2:8){
  v=rbind(v,left_A[[i]])
}
v$v5="left"

#right
right_A=lapply(1:8, function(x) m(A.cor.right[[x]]$p))

w=right_A[[1]]
for(i in 2:8){
  w=rbind(w,right_A[[i]])
}
w$v5="right"

v=rbind(v,w)

k=c()
#myorder=c("DG","CA3","Sub","CA1","IC","TH","EC","HYTH")
myorder=c("HYTH","EC","TH","IC","CA1","Sub","CA3","DG")
for(i in length(myorder):1){
  for(j in 1:length(myorder)){
        k=c(k,paste(myorder[i],myorder[j],sep="-"))
  }}

v$v4=paste(v$v1,v$v2,sep="-")
v$v4=factor(v$v4, levels=rev(k))
}

ggplot(data=v)+geom_point(aes(x=jitter(as.numeric(as.factor(v5))),y=-log10(v3),col=as.factor(v5)),size=0.5)+
  geom_hline(aes(yintercept=-log10(0.05)),col="grey")+
  facet_wrap(~v4,nrow=8,scales="fixed")+theme_classic()+
  theme(strip.background = element_blank(), strip.placement = "outside",strip.text = element_text(size=8),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA))+scale_color_manual(values=c("darkviolet","limegreen"))

ggplot(data=v)+  geom_boxplot(aes(x=as.factor(v5),y=-log10(v3),col=as.factor(v5)),size=0.5)+
  geom_point(aes(x=as.factor(v5),y=-log10(v3),col=as.factor(v5)),size=0.5)+
  geom_hline(aes(yintercept=-log10(0.05)),col="grey")+
  facet_wrap(~v4,nrow=8,scales="free_y")+theme_classic()+
  theme(strip.background = element_blank(), strip.placement = "outside",strip.text = element_text(size=8),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA))+scale_color_manual(values=c("darkviolet","limegreen"))


##B
{
#left
left_B=lapply(1:8, function(x) m(B.cor.left[[x]]$p))

v=left_B[[1]]
for(i in 2:8){
  v=rbind(v,left_B[[i]])
}
v$v5="left"

#right
right_B=lapply(1:8, function(x) m(B.cor.right[[x]]$p))

w=right_B[[1]]
for(i in 2:8){
  w=rbind(w,right_B[[i]])
}
w$v5="right"

v=rbind(v,w)

k=c()
#myorder=c("DG","CA3","Sub","CA1","IC","TH","EC","HYTH")
myorder=c("HYTH","EC","TH","IC","CA1","Sub","CA3","DG")
for(i in length(myorder):1){
  for(j in 1:length(myorder)){
    k=c(k,paste(myorder[i],myorder[j],sep="-"))
  }}

v$v4=paste(v$v1,v$v2,sep="-")
v$v4=factor(v$v4, levels=rev(k))
}

ggplot(data=v)+geom_point(aes(x=jitter(as.numeric(as.factor(v5))),y=-log10(v3),col=as.factor(v5)),size=0.5)+geom_hline(aes(yintercept=-log10(0.05)),col="grey")+
  facet_wrap(~v4,nrow=8,scales="fixed")+theme_classic()+
  theme(strip.background = element_blank(), strip.placement = "outside",strip.text = element_text(size=8),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA))+scale_color_manual(values=c("darkviolet","limegreen"))

ggplot(data=v)+  geom_boxplot(aes(x=as.factor(v5),y=-log10(v3),col=as.factor(v5)),size=0.5)+
  geom_point(aes(x=as.factor(v5),y=-log10(v3),col=as.factor(v5)),size=1)+
  geom_hline(aes(yintercept=-log10(0.05)),col="grey")+
  facet_wrap(~v4,nrow=8,scales="free_y")+theme_classic()+
  theme(strip.background = element_blank(), strip.placement = "outside",strip.text = element_text(size=8),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA))+scale_color_manual(values=c("darkviolet","limegreen"))



# compare A and B --- calculate ANOVA p-values using left and right as covariates (correlation)
{
  corr_p_diff=combine_cor_diff(d1=fisher_transfer(A.cor.left),d2=fisher_transfer(B.cor.left),
                               d3=fisher_transfer(A.cor.right),d4=fisher_transfer(B.cor.right),method="t.test")
  corr_p_diff=dia_transfer(corr_p_diff,NA)
  colnames(corr_p_diff)=ROI_names
  rownames(corr_p_diff)=ROI_names
  #corr_p_diff[1,1]=0.01
  #corr_p_diff[2,2]=0.05
  #corr_p_diff[3,3]=0.5
  corr_p_diff=as.data.frame(corr_p_diff)
  corr_p_diff$id=row.names(corr_p_diff)
  h=melt(corr_p_diff,id.vars = "id")
  h$variable=factor(h$variable,levels=c("DG","CA3","Sub","CA1","IC","TH","EC","HYTH"))
  h$id=factor(h$id,levels=c("DG","CA3","Sub","CA1","IC","TH","EC","HYTH"))
  ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=-log10(h$value)))+scale_fill_gradient2(low="white",high="firebrick1")
  ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=-log10(h$value)))+scale_fill_gradient2(low=("deepskyblue4"),mid="white",high=("firebrick1"),midpoint=1)
        }

#FDR
{
  colnames(h)[3]="p_val"
  h$FDR=p.adjust(h$p_val,method="BH")
  ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=-log10(h$FDR)))+scale_fill_gradient2(low=("deepskyblue4"),mid="white",high=("firebrick1"),midpoint=0.8)
}
write.csv(h,"20190712_result\\left-rigth_corr_2wANOVA_test_pval-FDR_final.csv")





##partial correlation
matrix2networkII<-function(x,t=0.05){
  colnames(x)=ROI_names
  rownames(x)=ROI_names
  name=colnames(x)
  v1=c()
  v2=c()
  v3=c()
  n=nrow(x)
  for(i in 1:n){
    for(j in 1:n){
      v1=c(v1,name[i])
      v2=c(v2,name[j])
      v3=c(v3,x[i,j])
    }
  }
  v=data.frame(v1,v2,v3)
  return(v)
}

n<-function(x){
  a=x[-9,-9]
  a=matrix2networkII(a)
  return(a)
}
##A partial
{
  left_A=lapply(1:8, function(x) n(A.pcor[[x]]$p))
  
  v=left_A[[1]]
  for(i in 2:8){
    v=rbind(v,left_A[[i]])
  }
  v$v5="left"
  
  k=c()
  #myorder=c("DG","CA3","Sub","CA1","IC","TH","EC","HYTH")
  myorder=c("HYTH","EC","TH","IC","CA1","Sub","CA3","DG")
  for(i in length(myorder):1){
    for(j in 1:length(myorder)){
      k=c(k,paste(myorder[i],myorder[j],sep="-"))
    }}
  
  v$v4=paste(v$v1,v$v2,sep="-")
  v$v4=factor(v$v4, levels=rev(k))
}

ggplot(data=v)+geom_point(aes(x=jitter(as.numeric(as.factor(v5))),y=-log10(v3),col=as.factor(v5)),size=1)+
  geom_hline(aes(yintercept=-log10(0.01)),col="grey")+
  facet_wrap(~v4,nrow=8,scales="fixed")+theme_classic()+
  theme(strip.background = element_blank(), strip.placement = "outside",strip.text = element_text(size=8),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA))+scale_color_manual(values=c("limegreen"))


##B partial
{
  left_B=lapply(1:8, function(x) n(B.pcor[[x]]$p))
  
  v=left_B[[1]]
  for(i in 2:8){
    v=rbind(v,left_B[[i]])
  }
  v$v5="left"
  
  k=c()
  #myorder=c("DG","CA3","Sub","CA1","IC","TH","EC","HYTH")
  myorder=c("HYTH","EC","TH","IC","CA1","Sub","CA3","DG")
  for(i in length(myorder):1){
    for(j in 1:length(myorder)){
      k=c(k,paste(myorder[i],myorder[j],sep="-"))
    }}
  
  v$v4=paste(v$v1,v$v2,sep="-")
  v$v4=factor(v$v4, levels=rev(k))
        }

ggplot(data=v)+geom_point(aes(x=jitter(as.numeric(as.factor(v5))),y=-log10(v3),col=as.factor(v5)),size=1)+
  geom_hline(aes(yintercept=-log10(0.01)),col="grey")+
  facet_wrap(~v4,nrow=8,scales="fixed")+theme_classic()+
  theme(strip.background = element_blank(), strip.placement = "outside",strip.text = element_text(size=8),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA))+scale_color_manual(values=c("limegreen"))

# compare A and B --- calculate p-values for A vs. B (partial correlation) 
{
  t=combine_cor_diff(d1=fisher_transfer(A.pcor.left),d2=fisher_transfer(B.pcor.left),
                     d3=fisher_transfer(A.pcor.right),d4=fisher_transfer(B.pcor.right),method="t.test")
  t=dia_transfer(t,NA)
  colnames(t)=ROI_names
  rownames(t)=ROI_names

  #t[1,1]=0.01
  #t[2,2]=0.05
  #t[3,3]=0.5
  t=as.data.frame(t)
  t$id=row.names(t)
  
h=melt(t,id.vars = "id")
h$variable=factor(h$variable,levels=c("DG","CA3","Sub","CA1","IC","TH","EC","HYTH"))
h$id=factor(h$id,levels=c("DG","CA3","Sub","CA1","IC","TH","EC","HYTH"))
ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=-log10(h$value)))+scale_fill_gradient2(low="white",high="firebrick1")
ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=-log10(h$value)))+scale_fill_gradient2(low=("deepskyblue4"),mid="white",high=("firebrick1"),midpoint=1)
}
#pcor FDR
{
  colnames(h)[3]="p_val"
  h$FDR=p.adjust(h$p_val,method="BH")
  ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=-log10(h$FDR)))+scale_fill_gradient2(low=("deepskyblue4"),mid="white",high=("firebrick1"),midpoint=0.8)
}
write.csv(h,"20190712_result\\left-rigth_partial_2wANOVA_test_pval-FDR_final.csv")


##new left and right partial p-value
##A left and right p
{
  #left
  left_A=lapply(1:8, function(x) m(A.pcor.left[[x]]$p))
  
  v=left_A[[1]]
  for(i in 2:8){
    v=rbind(v,left_A[[i]])
  }
  v$v5="left"
  
  #right
  right_A=lapply(1:8, function(x) m(A.pcor.right[[x]]$p))
  
  w=right_A[[1]]
  for(i in 2:8){
    w=rbind(w,right_A[[i]])
  }
  w$v5="right"
  
  v=rbind(v,w)
  
  k=c()
  #myorder=c("DG","CA3","Sub","CA1","IC","TH","EC","HYTH")
  myorder=c("HYTH","EC","TH","IC","CA1","Sub","CA3","DG")
  for(i in length(myorder):1){
    for(j in 1:length(myorder)){
      k=c(k,paste(myorder[i],myorder[j],sep="-"))
    }}
  
  v$v4=paste(v$v1,v$v2,sep="-")
  v$v4=factor(v$v4, levels=rev(k))
}

ggplot(data=v)+geom_point(aes(x=jitter(as.numeric(as.factor(v5))),y=-log10(v3),col=as.factor(v5)),size=0.5)+
  geom_hline(aes(yintercept=-log10(0.05)),col="grey")+
  facet_wrap(~v4,nrow=8,scales="fixed")+theme_classic()+
  theme(strip.background = element_blank(), strip.placement = "outside",strip.text = element_text(size=8),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA))+scale_color_manual(values=c("darkviolet","limegreen"))

ggplot(data=v)+  geom_boxplot(aes(x=as.factor(v5),y=-log10(v3),col=as.factor(v5)),size=0.5)+
  geom_point(aes(x=as.factor(v5),y=-log10(v3),col=as.factor(v5)),size=0.5)+
  geom_hline(aes(yintercept=-log10(0.05)),col="grey")+
  facet_wrap(~v4,nrow=8,scales="free_y")+theme_classic()+
  theme(strip.background = element_blank(), strip.placement = "outside",strip.text = element_text(size=8),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA))+scale_color_manual(values=c("darkviolet","limegreen"))


##B left and right p
{
  #left
  left_B=lapply(1:8, function(x) m(B.pcor.left[[x]]$p))
  
  v=left_B[[1]]
  for(i in 2:8){
    v=rbind(v,left_B[[i]])
  }
  v$v5="left"
  
  #right
  right_B=lapply(1:8, function(x) m(B.pcor.right[[x]]$p))
  
  w=right_B[[1]]
  for(i in 2:8){
    w=rbind(w,right_B[[i]])
  }
  w$v5="right"
  
  v=rbind(v,w)
  
  k=c()
  #myorder=c("DG","CA3","Sub","CA1","IC","TH","EC","HYTH")
  myorder=c("HYTH","EC","TH","IC","CA1","Sub","CA3","DG")
  for(i in length(myorder):1){
    for(j in 1:length(myorder)){
      k=c(k,paste(myorder[i],myorder[j],sep="-"))
    }}
  
  v$v4=paste(v$v1,v$v2,sep="-")
  v$v4=factor(v$v4, levels=rev(k))
        }

ggplot(data=v)+geom_point(aes(x=jitter(as.numeric(as.factor(v5))),y=-log10(v3),col=as.factor(v5)),size=0.5)+geom_hline(aes(yintercept=-log10(0.05)),col="grey")+
  facet_wrap(~v4,nrow=8,scales="fixed")+theme_classic()+
  theme(strip.background = element_blank(), strip.placement = "outside",strip.text = element_text(size=8),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA))+scale_color_manual(values=c("darkviolet","limegreen"))

ggplot(data=v)+  geom_boxplot(aes(x=as.factor(v5),y=-log10(v3),col=as.factor(v5)),size=0.5)+
  geom_point(aes(x=as.factor(v5),y=-log10(v3),col=as.factor(v5)),size=1)+
  geom_hline(aes(yintercept=-log10(0.05)),col="grey")+
  facet_wrap(~v4,nrow=8,scales="free_y")+theme_classic()+
  theme(strip.background = element_blank(), strip.placement = "outside",strip.text = element_text(size=8),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA))+scale_color_manual(values=c("darkviolet","limegreen"))


