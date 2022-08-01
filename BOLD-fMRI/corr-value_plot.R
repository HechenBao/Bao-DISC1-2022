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
##cross-correlation
##A
{
  A.cor.left_fisher=fisher_transfer(A.cor.left)
  A.cor.right_fisher=fisher_transfer(A.cor.right)
  #left
  left_A=lapply(1:8, function(x) m(A.cor.left_fisher[[x]]$rho))
  
  v=left_A[[1]]
  for(i in 2:8){
    v=rbind(v,left_A[[i]])
  }
  v$v5="left"
  
  #right
  right_A=lapply(1:8, function(x) m(A.cor.right_fisher[[x]]$rho))
  
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

ggplot(data=v)+geom_point(aes(x=jitter(as.numeric(as.factor(v5))),y=(v3),col=as.factor(v5)),size=0.5)+
  geom_hline(aes(yintercept=0.05),col="grey")+
  facet_wrap(~v4,nrow=8,scales="fixed")+theme_classic()+
  theme(strip.background = element_blank(), strip.placement = "outside",strip.text = element_text(size=8),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA))+scale_color_manual(values=c("darkviolet","limegreen"))

ggplot(data=v)+  geom_boxplot(aes(x=as.factor(v5),y=(v3),col=as.factor(v5)),size=0.5)+
  geom_point(aes(x=as.factor(v5),y=(v3),col=as.factor(v5)),size=0.5)+
  geom_hline(aes(yintercept=-log10(0.05)),col="grey")+
  facet_wrap(~v4,nrow=8,scales="fixed")+theme_classic()+
  theme(strip.background = element_blank(), strip.placement = "outside",strip.text = element_text(size=8),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA))+scale_color_manual(values=c("darkviolet","limegreen"))

##B
{
  B.cor.left_fisher=fisher_transfer(B.cor.left)
  B.cor.right_fisher=fisher_transfer(B.cor.right)
  #left
  left_B=lapply(1:8, function(x) m(B.cor.left_fisher[[x]]$rho))
  
  v=left_B[[1]]
  for(i in 2:8){
    v=rbind(v,left_B[[i]])
  }
  v$v5="left"
  
  #right
  right_B=lapply(1:8, function(x) m(B.cor.right_fisher[[x]]$rho))
  
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

ggplot(data=v)+geom_point(aes(x=jitter(as.numeric(as.factor(v5))),y=(v3),col=as.factor(v5)),size=0.5)+
  geom_hline(aes(yintercept=0.05),col="grey")+
  facet_wrap(~v4,nrow=8,scales="fixed")+theme_classic()+
  theme(strip.background = element_blank(), strip.placement = "outside",strip.text = element_text(size=8),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA))+scale_color_manual(values=c("darkviolet","limegreen"))

ggplot(data=v)+  geom_boxplot(aes(x=as.factor(v5),y=(v3),col=as.factor(v5)),size=0.5)+
  geom_point(aes(x=as.factor(v5),y=(v3),col=as.factor(v5)),size=0.5)+
  geom_hline(aes(yintercept=-log10(0.05)),col="grey")+
  facet_wrap(~v4,nrow=8,scales="fixed")+theme_classic()+
  theme(strip.background = element_blank(), strip.placement = "outside",strip.text = element_text(size=8),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA))+scale_color_manual(values=c("darkviolet","limegreen"))


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
  A.pcor_fisher=fisher_transfer(A.pcor)
 
  left_A=lapply(1:8, function(x) n(A.pcor_fisher[[x]]$rho))
  
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

ggplot(data=v)+geom_point(aes(x=jitter(as.numeric(as.factor(v5))),y=(v3),col=as.factor(v5)),size=1)+
  geom_hline(aes(yintercept=0.05),col="grey")+
  facet_wrap(~v4,nrow=8,scales="fixed")+theme_classic()+
  theme(strip.background = element_blank(), strip.placement = "outside",strip.text = element_text(size=8),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA))+scale_color_manual(values=c("darkviolet","limegreen"))

ggplot(data=v)+geom_point(aes(x=(as.numeric(as.factor(v5))),y=(v3),col=as.factor(v5)),size=1)+
  geom_hline(aes(yintercept=0.05),col="grey")+
  facet_wrap(~v4,nrow=8,scales="fixed")+theme_classic()+
  theme(strip.background = element_blank(), strip.placement = "outside",strip.text = element_text(size=8),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA))+scale_color_manual(values=c("darkviolet","limegreen"))


ggplot(data=v)+  geom_boxplot(aes(x=as.factor(v5),y=(v3),col=as.factor(v5)),size=0.5)+
  geom_point(aes(x=as.factor(v5),y=(v3),col=as.factor(v5)),size=0.5)+
  geom_hline(aes(yintercept=0.05),col="grey")+
  facet_wrap(~v4,nrow=8,scales="fixed")+theme_classic()+
  theme(strip.background = element_blank(), strip.placement = "outside",strip.text = element_text(size=8),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA))+scale_color_manual(values=c("darkviolet","limegreen"))


##B partial
{
  B.pcor_fisher=fisher_transfer(B.pcor)
  
  left_B=lapply(1:8, function(x) n(B.pcor_fisher[[x]]$rho))
  
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

ggplot(data=v)+geom_point(aes(x=jitter(as.numeric(as.factor(v5))),y=(v3),col=as.factor(v5)),size=1)+
  geom_hline(aes(yintercept=0.05),col="grey")+
  facet_wrap(~v4,nrow=8,scales="fixed")+theme_classic()+
  theme(strip.background = element_blank(), strip.placement = "outside",strip.text = element_text(size=8),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA))+scale_color_manual(values=c("darkviolet","limegreen"))

ggplot(data=v)+geom_point(aes(x=(as.numeric(as.factor(v5))),y=(v3),col=as.factor(v5)),size=1)+
  geom_hline(aes(yintercept=0.05),col="grey")+
  facet_wrap(~v4,nrow=8,scales="fixed")+theme_classic()+
  theme(strip.background = element_blank(), strip.placement = "outside",strip.text = element_text(size=8),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA))+scale_color_manual(values=c("darkviolet","limegreen"))


ggplot(data=v)+  geom_boxplot(aes(x=as.factor(v5),y=(v3),col=as.factor(v5)),size=0.5)+
  geom_point(aes(x=as.factor(v5),y=(v3),col=as.factor(v5)),size=0.5)+
  geom_hline(aes(yintercept=0.05),col="grey")+
  facet_wrap(~v4,nrow=8,scales="fixed")+theme_classic()+
  theme(strip.background = element_blank(), strip.placement = "outside",strip.text = element_text(size=8),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA))+scale_color_manual(values=c("darkviolet","limegreen"))

#new left and right partial correlation
#A left and rigth partial
{
  A.pcor.left_fisher=fisher_transfer(A.pcor.left)
  A.pcor.right_fisher=fisher_transfer(A.pcor.right)
  #left
  left_A=lapply(1:8, function(x) m(A.pcor.left_fisher[[x]]$rho))
  
  v=left_A[[1]]
  for(i in 2:8){
    v=rbind(v,left_A[[i]])
  }
  v$v5="left"
  
  #right
  right_A=lapply(1:8, function(x) m(A.pcor.right_fisher[[x]]$rho))
  
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

ggplot(data=v)+geom_point(aes(x=jitter(as.numeric(as.factor(v5))),y=(v3),col=as.factor(v5)),size=0.5)+
  geom_hline(aes(yintercept=0.05),col="grey")+
  facet_wrap(~v4,nrow=8,scales="fixed")+theme_classic()+
  theme(strip.background = element_blank(), strip.placement = "outside",strip.text = element_text(size=8),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA))+scale_color_manual(values=c("darkviolet","limegreen"))

ggplot(data=v)+  geom_boxplot(aes(x=as.factor(v5),y=(v3),col=as.factor(v5)),size=0.5)+
  geom_point(aes(x=as.factor(v5),y=(v3),col=as.factor(v5)),size=0.5)+
  geom_hline(aes(yintercept=-log10(0.05)),col="grey")+
  facet_wrap(~v4,nrow=8,scales="fixed")+theme_classic()+
  theme(strip.background = element_blank(), strip.placement = "outside",strip.text = element_text(size=8),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA))+scale_color_manual(values=c("darkviolet","limegreen"))

#B left right partial
{
  B.pcor.left_fisher=fisher_transfer(B.pcor.left)
  B.pcor.right_fisher=fisher_transfer(B.pcor.right)
  #left
  left_B=lapply(1:8, function(x) m(B.pcor.left_fisher[[x]]$rho))
  
  v=left_B[[1]]
  for(i in 2:8){
    v=rbind(v,left_B[[i]])
  }
  v$v5="left"
  
  #right
  right_B=lapply(1:8, function(x) m(B.pcor.right_fisher[[x]]$rho))
  
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

ggplot(data=v)+geom_point(aes(x=jitter(as.numeric(as.factor(v5))),y=(v3),col=as.factor(v5)),size=0.5)+
  geom_hline(aes(yintercept=0.05),col="grey")+
  facet_wrap(~v4,nrow=8,scales="fixed")+theme_classic()+
  theme(strip.background = element_blank(), strip.placement = "outside",strip.text = element_text(size=8),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA))+scale_color_manual(values=c("darkviolet","limegreen"))

ggplot(data=v)+  geom_boxplot(aes(x=as.factor(v5),y=(v3),col=as.factor(v5)),size=0.5)+
  geom_point(aes(x=as.factor(v5),y=(v3),col=as.factor(v5)),size=0.5)+
  geom_hline(aes(yintercept=-log10(0.05)),col="grey")+
  facet_wrap(~v4,nrow=8,scales="fixed")+theme_classic()+
  theme(strip.background = element_blank(), strip.placement = "outside",strip.text = element_text(size=8),
        panel.background = element_rect(fill = "transparent",colour = NA),
        plot.background = element_rect(fill = "transparent",colour = NA))+scale_color_manual(values=c("darkviolet","limegreen"))


