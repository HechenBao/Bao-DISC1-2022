rm(list=ls())
#install.packages("oro.nifti")
#install.packages("neurobase")
library(oro.nifti)
library(neurobase)
library(RColorBrewer)
library(scales)
library(ggplot2)
library(gplots)
library(reshape2)
library(ppcor)


# define sub functions 
{
  #Fisher Transform
  fisher_transfer<-function(d){
    helper<-function(x){
      x[x==1]=0
      x=log((1+x)/(1-x))/2
      return(x)
    }
    for(i in 1:length(d)){
      d[[i]]$rho=helper(d[[i]]$rho)
    }
    return(d)
  }
  
  #calculate ROI signals
  cal_region_mean <- function(file,rg,rg_ann){
    d <- readnii(file)
    mrg=c(rg)
    mt=dim(d)[4]
    region_mean<-function(region_value,w){
      tmp = c(d[,,,w])
      return(mean(tmp[mrg==region_value]))
    }
    region_median<-function(region_value,w){
      tmp = c(d[,,,w])
      return(median(tmp[mrg==region_value]))
    }
    v1=sapply(rg_ann$Val, function(x) sapply(1:mt,function(y) region_mean(x,y)))
    v2=sapply(rg_ann$Val, function(x) sapply(1:mt,function(y) region_median(x,y)))
    rownames(v1)=1:mt
    rownames(v2)=1:mt
    colnames(v1)=as.character(rg_ann$Sym)
    colnames(v2)=as.character(rg_ann$Sym)
    v=list(v1,v2)
    names(v)=c("mean","median")
    return(v)
  }
  
  #corelation of regions for each mouse
  cor_region <- function(mat,method="pearson",subset=F,subset.name=""){
    if(!subset){
      subset.name=colnames(mat)
    }
    rho=sapply(subset.name,function(x) sapply(subset.name,function(y) cor.test(mat[,x],mat[,y],method=method)$estimate))
    p=sapply(subset.name,function(x) sapply(subset.name,function(y) cor.test(mat[,x],mat[,y],method=method)$p.value))
    colnames(rho)=subset.name
    colnames(p)=subset.name
    rownames(rho)=subset.name
    rownames(p)=subset.name
    v=list(rho,p)
    names(v)=c("rho","p")
    return(v)
  }
  
  #partial correlation between regions for each mouse 
  pcor_region <- function(mat,method="pearson",subset=F,subset.name=""){
    if(!subset){
      subset.name=colnames(mat)
    }
    d=subset.data.frame(mat,select=subset.name)
    rho=suppressWarnings(pcor(d)$estimate)
    p=suppressWarnings(pcor(d)$p.value)
    colnames(rho)=subset.name
    colnames(p)=subset.name
    rownames(rho)=subset.name
    rownames(p)=subset.name
    v=list(rho,p)
    names(v)=c("rho","p")
    return(v)
  }
  
  #change diagonal values of a square matrix
  dia_transfer <-function(mat, to=0){
    n=nrow(mat)
    for (i in 1:n){mat[i,i]=to}
    return(mat)
  }
  
  #combine multiple p values (Fisher's method)
  sum_p_cor<-function(d,d2=NULL){
    helper<-function(a,b){
      p=sapply(1:length(d),function(x) d[[x]]$p[a,b])
      if(length(d2)>0){
        p1=sapply(1:length(d2),function(x) d2[[x]]$p[a,b])
        p=c(p,p1)
      }
      return(pchisq((sum(log(p))*-2), df=length(p)*2, lower.tail=F))
    }
    
    n=colnames(d[[1]]$p)
    v=sapply(1:nrow(d[[1]]$p),function(x) sapply(1:nrow(d[[1]]$p), function(y) helper(x,y)))
    colnames(v)=n
    rownames(v)=n
    return(v)
  }
  
  # used for heatmap plotting, converting continuous color to discrete colors
  col_adjust<-function(x){
    tttt<-function(x){
      if(x>0.05){return(0)}
      else if(x>0.01 & x<=0.05){return(1)}
      else if(x>0.001 & x<=0.01){return(2)}
      else if(x>1e-5 & x<=0.001){return(3)}
      else if(x<1e-5){return(4)}
    }
    v=sapply(x,function(i) tttt(i))
    v=matrix(v,ncol=ncol(x))
    colnames(v)=colnames(x)
    rownames(v)=row.names(x)
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
  
  #calculate times of significance
  cor_times <- function(d,p=0.05){
    n=nrow(d[[1]]$p)
    name=colnames(d[[1]]$p)
    v=matrix(rep(0,n*n),nrow=n)
    rownames(v)=name
    colnames(v)=name
    for(i in 1:length(d)){
      v = v+ as.numeric(d[[i]]$p<p)
    }
    return(v)
  }
  
  #calculate p-value for correlation coeffiecient difference between d1 and d2
  cor_diff <- function(d1,d2,d3=NULL,d4=NULL,method="wilcox"){
    helper<-function(a,b){
      if(a==b){return(1)}
      v1=sapply(1:length(d1), function(x) return(round(d1[[x]]$rho[a,b],digits=6)))
      v2=sapply(1:length(d2), function(x) return(round(d2[[x]]$rho[a,b],digits=6)))
      if(length(d3)>0 & length(d4)>0){
        v3=sapply(1:length(d3), function(x) return(round(d3[[x]]$rho[a,b],digits=6)))
        v4=sapply(1:length(d4), function(x) return(round(d4[[x]]$rho[a,b],digits=6)))
        v1=c(v1,v3)
        v2=c(v2,v4)
      }
      if(method=="wilcox"){
        return(suppressWarnings(wilcox.test(v1,v2)$p.value))
      }
      else if(method=="t.test"){
        return(suppressWarnings(t.test(v1,v2)$p.value))
      }
    }
    k=colnames(d1[[1]]$rho)
    v=sapply(1:nrow(d1[[1]]$rho),function(x) sapply(1:nrow(d1[[1]]$rho),function(y) helper(x,y)))
    colnames(v)=k
    rownames(v)=k
    return(v)
  }
  
  #ANOVA test with left and right as a covariant
  combine_cor_diff <- function(d1,d2,d3=NULL,d4=NULL,method="t.test"){
    helper<-function(a,b){
      v1=sapply(1:length(d1), function(x) return(round(d1[[x]]$rho[a,b],digits=6)))
      v2=sapply(1:length(d2), function(x) return(round(d2[[x]]$rho[a,b],digits=6)))
      if(length(d3)>0 & length(d4)>0 & !(a>=15 & b>=15)){
        v3=sapply(1:length(d3), function(x) return(round(d3[[x]]$rho[a,b],digits=6)))
        v4=sapply(1:length(d4), function(x) return(round(d4[[x]]$rho[a,b],digits=6)))
        v1=c(v1,v3)
        v2=c(v2,v4)
      }
      if(method=="wilcox"){
        return(suppressWarnings(wilcox.test(v1,v2)$p.value))
      }
      else if(method=="t.test"){
        if(length(d3)>0 & length(d4)>0 & !(a>=15 & b>=15)){
          va=c(v1,v2)
          g=c(rep("A",length(v1)),rep("B",length(v2)))
          cov=rep(c(rep(0,length(v1)/2),rep(1,length(v1)/2)),2)
          r=summary(aov(va~g*cov))
          return(r[[1]]$`Pr(>F)`[1])
        }
        else{
          return(suppressWarnings(t.test(v1,v2)$p.value))
        }
      }
    }
    
    k=colnames(d1[[1]]$rho)
    v=sapply(1:nrow(d1[[1]]$rho),function(x) sapply(1:nrow(d1[[1]]$rho),function(y) helper(x,y)))
    colnames(v)=k
    rownames(v)=k
    return(v)
  }
  
  #generate data for plots for the above ANOVA test 
  data_for_plot_combine_cor_diff <- function(d1,d2,d3=NULL,d4=NULL,method="t.test",key=3,dir="region_mean_newData_20181221/20181221_result/",
                                             name=c("IC","MO","DG","S1","VT","EC","CA1","CA3","Sub","DB","CP","MD","BLA","CEA","ACA","RSP","MS")){
    helper<-function(a,b){
      v1=sapply(1:length(d1), function(x) return(round(d1[[x]]$rho[a,b],digits=6)))
      v2=sapply(1:length(d2), function(x) return(round(d2[[x]]$rho[a,b],digits=6)))
      if(length(d3)>0 & length(d4)>0 & !(a>=15 & b>=15)){
        v3=sapply(1:length(d3), function(x) return(round(d3[[x]]$rho[a,b],digits=6)))
        v4=sapply(1:length(d4), function(x) return(round(d4[[x]]$rho[a,b],digits=6)))
        v1=c(v1,v3)
        v2=c(v2,v4)
      }
      if(method=="wilcox"){
        return(suppressWarnings(wilcox.test(v1,v2)$p.value))
      }
      else if(method=="t.test"){
        if(length(d3)>0 & length(d4)>0 & !(a>=15 & b>=15)){
          value=c(v1,v2)
          group=c(rep("A",length(v1)),rep("B",length(v2)))
          position=rep(c(rep(0,length(v1)/2),rep(1,length(v1)/2)),2)
          p=data.frame(value,group,position)
          file.name=paste(dir,paste(paste(name[a],name[b],sep="-"),"csv",sep="."),sep="")
          write.csv(p,file.name,row.names = F)
          return(1)
        }
        else{
          return(suppressWarnings(t.test(v1,v2)$p.value))
        }
      }
    }
    
    v=sapply(1:nrow(d1[[1]]$rho),function(x) helper(key,x))
    return(1)
  }
  
  #measure change direction
  combine_cor_diff_direction <- function(d1,d2,d3=NULL,d4=NULL,method="wilcox"){
    helper<-function(a,b){
      v1=sapply(1:length(d1), function(x) return(round(d1[[x]]$rho[a,b],digits=6)))
      v2=sapply(1:length(d2), function(x) return(round(d2[[x]]$rho[a,b],digits=6)))
      if(length(d3)>0 & length(d4)>0 & !(a>=15 & b>=15)){
        v3=sapply(1:length(d3), function(x) return(round(d3[[x]]$rho[a,b],digits=6)))
        v4=sapply(1:length(d4), function(x) return(round(d4[[x]]$rho[a,b],digits=6)))
        v1=c(v1,v3)
        v2=c(v2,v4)
      }
      return(mean(v1)-mean(v2))
    }
    k=colnames(d1[[1]]$rho)
    v=sapply(1:nrow(d1[[1]]$rho),function(x) sapply(1:nrow(d1[[1]]$rho),function(y) helper(x,y)))
    colnames(v)=k
    rownames(v)=k
    return(v)
  }
  
  #partial correlation with left and right as covariant
  combine_pcor_region <- function(mat1,mat2,method="pearson"){
    colnames(mat2)=colnames(mat1)
    d=rbind(mat1,mat2)
    d$cov=c(rep(0,nrow(mat1)),rep(1,nrow(mat2)))
    rho=suppressWarnings(pcor(d)$estimate)
    p=suppressWarnings(pcor(d)$p.value)
    colnames(rho)=colnames(d)
    colnames(p)=colnames(d)
    rownames(rho)=colnames(d)
    rownames(p)=colnames(d)
    v=list(rho,p)
    names(v)=c("rho","p")
    return(v)
  }
  
  #combine p-values of left and right with Fisher's Method
  sum_p_cor_diff<-function(d1,d2){
    helper<-function(a,b){
      p=c(d1[a,b],d2[a,b])
      return(pchisq((sum(log(p))*-2), df=length(p)*2, lower.tail=F))
    }
    
    n=colnames(d1)
    v=sapply(1:dim(d1)[1],function(x) sapply(1:dim(d2)[1], function(y) helper(x,y)))
    colnames(v)=n
    rownames(v)=n
    return(v)
  }
  
  cal_mean<-function(x){
    a=x[[1]]$rho
    for(i in 2: length(x)){
      a=a+x[[i]]$rho
    }
    a=a/length(x)
    return(a)
  }
}


# set working directory
setwd("D:\\DISC1_fMRI\\121718_RawData")

#read atlas example
atlas=readnii("150um_Mouse_temp.nii.gz")
atlas

#read regions
rg=readnii("seedROI_071119.nii.gz")
rg

#read region annotation
rg_ann = read.table("seedROI_071119.txt")
rg_ann = rg_ann[-1,]
colnames(rg_ann) = c("Val","R","G","B","X1","X2","X3","Sym")
rg_ann

#calculate mean and median of each region for each mice. (!!!!Time-consuming. Run only once !!!!)
{
  A1=cal_region_mean("groupA\\sub-Song_Mouse1_20170417_ses-20170417_06.nii.gz",rg,rg_ann)
  write.csv(A1$mean,"A1_mean.csv",quote=F)
  write.csv(A1$median,"A1_median.csv",quote=F)
  A2=cal_region_mean("groupA\\sub-Song_Mouse2_20170417_ses-20170417_07.nii.gz",rg,rg_ann)
  write.csv(A2$mean,"A2_mean.csv",quote=F)
  write.csv(A2$median,"A2_median.csv",quote=F)
  A3=cal_region_mean("groupA\\sub-Song_Mouse3_20170417_ses-20170417_06.nii.gz",rg,rg_ann)
  write.csv(A3$mean,"A3_mean.csv",quote=F)
  write.csv(A3$median,"A3_median.csv",quote=F)
  A4=cal_region_mean("groupA\\sub-Song_Mouse7_20170420_ses-20170420_07.nii.gz",rg,rg_ann)
  write.csv(A4$mean,"A4_mean.csv",quote=F)
  write.csv(A4$median,"A4_median.csv",quote=F)
  A5=cal_region_mean("groupA\\sub-Song_Mouse8_20170420_ses-20170420_06.nii.gz",rg,rg_ann)
  write.csv(A5$mean,"A5_mean.csv",quote=F)
  write.csv(A5$median,"A5_median.csv",quote=F)
  A6=cal_region_mean("groupA\\sub-Song_Mouse9_20170420_ses-20170420_06.nii.gz",rg,rg_ann)
  write.csv(A6$mean,"A6_mean.csv",quote=F)
  write.csv(A6$median,"A6_median.csv",quote=F)
  A7=cal_region_mean("groupA\\sub-Song_965_20161209_ses-20161209_11.nii.gz",rg,rg_ann)
  write.csv(A7$mean,"A7_mean.csv",quote=F)
  write.csv(A7$median,"A7_median.csv",quote=F)
  A8=cal_region_mean("groupA\\sub-Song_967_20161209_ses-20161209_06.nii.gz",rg,rg_ann)
  write.csv(A8$mean,"A8_mean.csv",quote=F)
  write.csv(A8$median,"A8_median.csv",quote=F)
  B1=cal_region_mean("groupB\\sub-Song_Mouse4_20170417_ses-20170417_09.nii.gz",rg,rg_ann)
  write.csv(B1$mean,"B1_mean.csv",quote=F)
  write.csv(B1$median,"B1_median.csv",quote=F)
  B2=cal_region_mean("groupB\\sub-Song_Mouse5_20170417_ses-20170417_08.nii.gz",rg,rg_ann)
  write.csv(B2$mean,"B2_mean.csv",quote=F)
  write.csv(B2$median,"B2_median.csv",quote=F)
  B3=cal_region_mean("groupB\\sub-Song_Mouse6_20170417_ses-20170417_06.nii.gz",rg,rg_ann)
  write.csv(B3$mean,"B3_mean.csv",quote=F)
  write.csv(B3$median,"B3_median.csv",quote=F)
  B4=cal_region_mean("groupB\\sub-Song_Mouse10_20170420_ses-20170420_06.nii.gz",rg,rg_ann)
  write.csv(B4$mean,"B4_mean.csv",quote=F)
  write.csv(B4$median,"B4_median.csv",quote=F)
  B5=cal_region_mean("groupB\\sub-Song_Mouse11_20170420_ses-20170420_06.nii.gz",rg,rg_ann)
  write.csv(B5$mean,"B5_mean.csv",quote=F)
  write.csv(B5$median,"B5_median.csv",quote=F)
  B6=cal_region_mean("groupB\\sub-Song_Mouse12_20170420_ses-20170420_06.nii.gz",rg,rg_ann)
  write.csv(B6$mean,"B6_mean.csv",quote=F)
  write.csv(B6$median,"B6_median.csv",quote=F)
  B7=cal_region_mean("groupB\\sub-Song_964_20161209_ses-20161209_07.nii.gz",rg,rg_ann)
  write.csv(B7$mean,"B7_mean.csv",quote=F)
  write.csv(B7$median,"B7_median.csv",quote=F)
  B8=cal_region_mean("groupB\\sub-Song_966_20161209_ses-20161209_12.nii.gz",rg,rg_ann)
  write.csv(B8$mean,"B8_mean.csv",quote=F)
  write.csv(B8$median,"B8_median.csv",quote=F)
}

#read region mean, which is calculated above.
{
  A1=read.csv("A1_mean.csv")[,-1]
  A2=read.csv("A2_mean.csv")[,-1]
  A3=read.csv("A3_mean.csv")[,-1]
  A4=read.csv("A4_mean.csv")[,-1]
  A5=read.csv("A5_mean.csv")[,-1]
  A6=read.csv("A6_mean.csv")[,-1]
  A7=read.csv("A7_mean.csv")[,-1]
  A8=read.csv("A8_mean.csv")[,-1]
  B1=read.csv("B1_mean.csv")[,-1]
  B2=read.csv("B2_mean.csv")[,-1]
  B3=read.csv("B3_mean.csv")[,-1]
  B4=read.csv("B4_mean.csv")[,-1]
  B5=read.csv("B5_mean.csv")[,-1]
  B6=read.csv("B6_mean.csv")[,-1]
  B7=read.csv("B7_mean.csv")[,-1]
  B8=read.csv("B8_mean.csv")[,-1]
}

#define left and right regions
#left=c("L_IC","L_MO","L_DG","L_S1","L_VT","L_EC","L_CA1","L_CA3","L_Sub","L_DB","L_CP","L_MD","L_BLA","L_CEA","ACA","RSP","MS")
#right=c("R_IC","R_MO","R_DG","R_S1","R_VT","R_EC","R_CA1","L_CA3","R_Sub","R_DB","R_CP","R_MD","R_BLA","R_CEA","ACA","RSP","MS")

left=c("L_IC","L_MO","L_S1","L_CP","L_NAC","L_DB","L_MD","L_PCN","L_HYTH","L_BLA","L_CEA","L_DG","L_CA3","L_CA1","L_Sub","L_EC","ACA","RSP","MS")
right=c("R_IC","R_MO","R_S1","R_CP","R_NAC","R_DB","R_MD","R_PCN","R_HYTH","R_BLA","R_CEA","R_DG","R_CA3","R_CA1","R_Sub","R_EC","ACA","RSP","MS")

#left=c("L_IC","L_MO","L_S1","L_CP","L_NAC","L_MD","L_PCN","L_HYTH","L_DG","L_CA3","L_CA1","L_Sub","L_EC")
#right=c("R_IC","R_MO","R_S1","R_CP","R_NAC","R_MD","R_PCN","R_HYTH","R_DG","R_CA3","R_CA1","R_Sub","R_EC")

# basic correlation 
{
  # basic corelation
  A1.cor.mean=cor_region(A1)
  A2.cor.mean=cor_region(A2)
  A3.cor.mean=cor_region(A3)
  A4.cor.mean=cor_region(A4)
  A5.cor.mean=cor_region(A5)
  A6.cor.mean=cor_region(A6)
  A7.cor.mean=cor_region(A7)
  A8.cor.mean=cor_region(A8)
  B1.cor.mean=cor_region(B1)
  B2.cor.mean=cor_region(B2)
  B3.cor.mean=cor_region(B3)
  B4.cor.mean=cor_region(B4)
  B5.cor.mean=cor_region(B5)
  B6.cor.mean=cor_region(B6)
  B7.cor.mean=cor_region(B7)
  B8.cor.mean=cor_region(B8)
  #left 
  A1.cor.mean.left=cor_region(A1,subset=T,subset.name=left)
  A2.cor.mean.left=cor_region(A2,subset=T,subset.name=left)
  A3.cor.mean.left=cor_region(A3,subset=T,subset.name=left)
  A4.cor.mean.left=cor_region(A4,subset=T,subset.name=left)
  A5.cor.mean.left=cor_region(A5,subset=T,subset.name=left)
  A6.cor.mean.left=cor_region(A6,subset=T,subset.name=left)
  A7.cor.mean.left=cor_region(A7,subset=T,subset.name=left)
  A8.cor.mean.left=cor_region(A8,subset=T,subset.name=left)
  B1.cor.mean.left=cor_region(B1,subset=T,subset.name=left)
  B2.cor.mean.left=cor_region(B2,subset=T,subset.name=left)
  B3.cor.mean.left=cor_region(B3,subset=T,subset.name=left)
  B4.cor.mean.left=cor_region(B4,subset=T,subset.name=left)
  B5.cor.mean.left=cor_region(B5,subset=T,subset.name=left)
  B6.cor.mean.left=cor_region(B6,subset=T,subset.name=left)
  B7.cor.mean.left=cor_region(B7,subset=T,subset.name=left)
  B8.cor.mean.left=cor_region(B8,subset=T,subset.name=left)
  #right
  A1.cor.mean.right=cor_region(A1,subset=T,subset.name=right)
  A2.cor.mean.right=cor_region(A2,subset=T,subset.name=right)
  A3.cor.mean.right=cor_region(A3,subset=T,subset.name=right)
  A4.cor.mean.right=cor_region(A4,subset=T,subset.name=right)
  A5.cor.mean.right=cor_region(A5,subset=T,subset.name=right)
  A6.cor.mean.right=cor_region(A6,subset=T,subset.name=right)
  A7.cor.mean.right=cor_region(A7,subset=T,subset.name=right)
  A8.cor.mean.right=cor_region(A8,subset=T,subset.name=right)
  B1.cor.mean.right=cor_region(B1,subset=T,subset.name=right)
  B2.cor.mean.right=cor_region(B2,subset=T,subset.name=right)
  B3.cor.mean.right=cor_region(B3,subset=T,subset.name=right)
  B4.cor.mean.right=cor_region(B4,subset=T,subset.name=right)
  B5.cor.mean.right=cor_region(B5,subset=T,subset.name=right)
  B6.cor.mean.right=cor_region(B6,subset=T,subset.name=right)
  B7.cor.mean.right=cor_region(B7,subset=T,subset.name=right)
  B8.cor.mean.right=cor_region(B8,subset=T,subset.name=right)
  
  A.cor.left=list(A1.cor.mean.left,A2.cor.mean.left,A3.cor.mean.left,A4.cor.mean.left,
                  A5.cor.mean.left,A6.cor.mean.left,A7.cor.mean.left,A8.cor.mean.left)
  B.cor.left=list(B1.cor.mean.left,B2.cor.mean.left,B3.cor.mean.left,B4.cor.mean.left,
                  B5.cor.mean.left,B6.cor.mean.left,B7.cor.mean.left,B8.cor.mean.left)
  A.cor.right=list(A1.cor.mean.right,A2.cor.mean.right,A3.cor.mean.right,A4.cor.mean.right,
                   A5.cor.mean.right,A6.cor.mean.right,A7.cor.mean.right,A8.cor.mean.right)
  B.cor.right=list(B1.cor.mean.right,B2.cor.mean.right,B3.cor.mean.right,B4.cor.mean.right,
                   B5.cor.mean.right,B6.cor.mean.right,B7.cor.mean.right,B8.cor.mean.right)
  
  
  A.cor=list(A1.cor.mean,A2.cor.mean,A3.cor.mean,A4.cor.mean,
             A5.cor.mean,A6.cor.mean,A7.cor.mean,A8.cor.mean)
  B.cor=list(B1.cor.mean,B2.cor.mean,B3.cor.mean,B4.cor.mean,
             B5.cor.mean,B6.cor.mean,B7.cor.mean,B8.cor.mean)
  
  for(i in 1:8){
    A.cor[[i]]$rho=round(A.cor[[i]]$rho,digits=5)
    B.cor[[i]]$rho=round(B.cor[[i]]$rho,digits=5)
    A.cor.left[[i]]$rho=round(A.cor.left[[i]]$rho,digits=5)
    B.cor.left[[i]]$rho=round(B.cor.left[[i]]$rho,digits=5)
    A.cor.right[[i]]$rho=round(A.cor.right[[i]]$rho,digits=5)
    B.cor.right[[i]]$rho=round(B.cor.right[[i]]$rho,digits=5)
  }
}

# basic partial correlation
{
  A1.pcor.mean=pcor_region(A1)
  A2.pcor.mean=pcor_region(A2)
  A3.pcor.mean=pcor_region(A3)
  A4.pcor.mean=pcor_region(A4)
  A5.pcor.mean=pcor_region(A5)
  A6.pcor.mean=pcor_region(A6)
  A7.pcor.mean=pcor_region(A7)
  A8.pcor.mean=pcor_region(A8)
  B1.pcor.mean=pcor_region(B1)
  B2.pcor.mean=pcor_region(B2)
  B3.pcor.mean=pcor_region(B3)
  B4.pcor.mean=pcor_region(B4)
  B5.pcor.mean=pcor_region(B5)
  B6.pcor.mean=pcor_region(B6)
  B7.pcor.mean=pcor_region(B7)
  B8.pcor.mean=pcor_region(B8)
  
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
sum_p_cor(A.cor)
sum_p_cor(B.cor)
sum_p_cor(A.pcor)
sum_p_cor(B.pcor)

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

#output example command
#write.csv(sum_p_cor(A.pcor),"partial_correlation_A_group_summary_p_whole.csv")
#write.table(matrix2network(sum_p_cor(A.pcor)),"A_whole_brain_network.csv"
#            ,quote=F,row.names = F,sep=",")

# compare A and B --- calculate p-values for A vs. B (correlation) 
cor_diff(A.cor,B.cor,method="wilcox")  #non-parametric
cor_diff(fisher_transfer(A.cor),fisher_transfer(B.cor),method="t.test") # Fisher transformation followed by t-test

# compare A and B --- calculate p-values for A vs. B (partial correlation) 
cor_diff(A.pcor,B.pcor)
cor_diff(fisher_transfer(A.pcor),fisher_transfer(B.pcor),method="t.test")
cor_diff(fisher_transfer(A.pcor.left),fisher_transfer(B.pcor.left),method="t.test")
cor_diff(fisher_transfer(A.pcor.right),fisher_transfer(B.pcor.right),method="t.test")

# compare A and B --- calculate ANOVA p-values using left and right as covariates (correlation)
k=combine_cor_diff(d1=fisher_transfer(A.cor.left),d2=fisher_transfer(B.cor.left),
                   d3=fisher_transfer(A.cor.right),d4=fisher_transfer(B.cor.right),method="t.test")
k=dia_transfer(k,NA)
ROI_names=c("IC","MO","S1","CP","NAC","DB","MD","PCN","HYTH","BLA","CEA","DG","CA3","CA1","Sub","EC","ACA","RSP","MS") 
#ROI_names=c("IC","MO","S1","CP","NAC","MD","PCN","HYTH","DG","CA3","CA1","Sub","EC") 
colnames(k)=ROI_names
rownames(k)=ROI_names
#write.csv(k,"20190712_result\\corr\\combine_left_right_2wANOVA_test_pval.csv")
#data_for_plot_combine_cor_diff(d1=fisher_transfer(A.cor.left),d2=fisher_transfer(B.cor.left),
#                               d3=fisher_transfer(A.cor.right),d4=fisher_transfer(B.cor.right),method="t.test")

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

#write.csv(cor_diff(fisher_transfer(A.pcor),fisher_transfer(B.pcor),method="t.test"),"20190712_result\\pcorr\\combine_pcor_A_vs.B_diff.csv")

#write.table(matrix2network(sum_p_cor(A.pcor)),"20190712_result\\pcorr\\A_combine_network.csv",quote=F,row.names = F,sep=",")
#write.table(sum_p_cor(B.pcor)[-18,-18],"20190712_result\\B_combine_network_matrix.csv",quote=F,row.names = T,sep=",")

#write.table(matrix2network(sum_p_cor(A.pcor)),"A_combine_network.csv",quote=F,row.names = F,sep=",")
#write.table(sum_p_cor(B.pcor)[-18,-18],"B_combine_network_matrix.csv" ,quote=F,row.names = T,sep=",")

a=sum_p_cor(A.pcor)[-20,-20]
colnames(a)=ROI_names
rownames(a)=ROI_names
a=melt(a)
a$id=paste(a$Var1,a$Var2,sep="-")
colnames(a)[3]="A_pVal"
b=sum_p_cor(B.pcor)[-20,-20]
colnames(b)=ROI_names
rownames(b)=ROI_names
b=melt(b)
b$id=paste(b$Var1,b$Var2,sep="-")
colnames(b)[3]="B_pVal"
d=read.csv("20190712_result\\pcorr\\combine_pcor_A_vs.B_diff.csv")
d=d[,-1]
d=d[-20,-20]
row.names(d)=colnames(d)
d=melt(as.matrix(d))
d$id=paste(d$Var1,d$Var2,sep="-")
colnames(d)[3]="diff_A_B_pVal"

f=merge(merge(a,b,by="id"),d,by="id")
f$log.A_pVal=-log10(f$A_pVal+1e-300)
f$log.B_pVal=-log10(f$B_pVal+1e-300)
f$log.AminusB=f$log.A_pVal-f$log.B_pVal
f=f[f$Var1.x!=f$Var2.x,]
write.csv(f,"20190712_result\\pcorr\\network\\network.csv")




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

s1=cal_cor_mean(A.cor.left,A.cor.right)
s1=cal_cor_mean(fisher_transfer(A.cor.left),fisher_transfer(A.cor.right))
colnames(s1)=ROI_names
rownames(s1)=ROI_names
write.csv(s1,"20190712_result\\corr\\A_raw_correlation_matrix.csv")

s2=cal_cor_mean(B.cor.left,B.cor.right)
s2=cal_cor_mean(fisher_transfer(B.cor.left),fisher_transfer(B.cor.right))
colnames(s2)=ROI_names
rownames(s2)=ROI_names
heatmap.2(dia_transfer(s2,max(s2)),trace="none",col=bluered(100))
write.csv(s2,"20190712_result\\corr\\B_raw_correlation_matrix.csv")

s3=s1-s2
colnames(s3)=ROI_names
rownames(s3)=ROI_names
write.csv(s3,"20190712_result\\corr\\diff_raw_correlation_matrix.csv")

s1=dia_transfer(s1,max(s1))
s1[1,1]=0
s1[2,2]=1
s1=as.data.frame(s1)
s1$id=row.names(s1)
h=melt(s1,id.vars = "id")
h$variable=factor(h$variable,levels=c("CP","CA3","Sub","DG","CA1","CEA","BLA","DB","VT","MD",
                                      "MS","IC","EC","RSP","ACA","MO","S1"))

h$id=factor(h$id,levels=c("CP","CA3","Sub","DG","CA1","CEA","BLA","DB","VT","MD",
                          "MS","IC","EC","RSP","ACA","MO","S1"))
ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=h$value))+scale_fill_material("blue-grey")


s2=dia_transfer(s2,0)
s2[1,1]=1
s2=as.data.frame(s2)
s2$id=row.names(s2)
h=melt(s2,id.vars = "id")
h$variable=factor(h$variable,levels=c("CP","CA3","Sub","DG","CA1","CEA","BLA","DB","VT","MD",
                                      "MS","IC","EC","RSP","ACA","MO","S1"))

h$id=factor(h$id,levels=c("CP","CA3","Sub","DG","CA1","CEA","BLA","DB","VT","MD",
                          "MS","IC","EC","RSP","ACA","MO","S1"))

ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=h$value))+scale_fill_material("blue-grey")

s3=dia_transfer(s3,0)
max(s3)
min(s3)
s3[1,1]=max(s3)
s3[2,2]= -max(s3)
s3=as.data.frame(s3)
s3$id=row.names(s3)
h=melt(s3,id.vars = "id")
h$variable=factor(h$variable,levels=c("CP","CA3","Sub","DG","CA1","CEA","BLA","DB","VT","MD",
                                      "MS","IC","EC","RSP","ACA","MO","S1"))
h$id=factor(h$id,levels=c("CP","CA3","Sub","DG","CA1","CEA","BLA","DB","VT","MD",
                          "MS","IC","EC","RSP","ACA","MO","S1"))
ggplot()+geom_tile(aes(x=h$id,y=h$variable,fill=h$value))+scale_fill_gradient2(low="blue",high="red")



######################### biDG ###################
#biDG
merge_DG<-function(x){
  x$DG=(x$R_DG*287+x$L_DG*283)/(283+287)
  return(x)
}

# update ROI
merge_TH<-function(x){
  x$L_TH=(x$L_MD*69+x$L_VT*75)/(69+75)
  x$R_TH=(x$R_MD*69+x$R_VT*75)/(69+75)
  return(x)
}
A1=merge_DG(A1)
A2=merge_DG(A2)
A3=merge_DG(A3)
A4=merge_DG(A4)
A5=merge_DG(A5)
A6=merge_DG(A6)
A7=merge_DG(A7)
A8=merge_DG(A8)
B1=merge_DG(B1)
B2=merge_DG(B2)
B3=merge_DG(B3)
B4=merge_DG(B4)
B5=merge_DG(B5)
B6=merge_DG(B6)
B7=merge_DG(B7)
B8=merge_DG(B8)
A1.cor.mean=cor_region(A1)
A2.cor.mean=cor_region(A2)
A3.cor.mean=cor_region(A3)
A4.cor.mean=cor_region(A4)
A5.cor.mean=cor_region(A5)
A6.cor.mean=cor_region(A6)
A7.cor.mean=cor_region(A7)
A8.cor.mean=cor_region(A8)
B1.cor.mean=cor_region(B1)
B2.cor.mean=cor_region(B2)
B3.cor.mean=cor_region(B3)
B4.cor.mean=cor_region(B4)
B5.cor.mean=cor_region(B5)
B6.cor.mean=cor_region(B6)
B7.cor.mean=cor_region(B7)
B8.cor.mean=cor_region(B8)
A.cor=list(A1.cor.mean,A2.cor.mean,A3.cor.mean,A4.cor.mean,
           A5.cor.mean,A6.cor.mean,A7.cor.mean,A8.cor.mean)
B.cor=list(B1.cor.mean,B2.cor.mean,B3.cor.mean,B4.cor.mean,
           B5.cor.mean,B6.cor.mean,B7.cor.mean,B8.cor.mean)

#  A.pcor.left=list(A1.pcor.mean.left,A2.pcor.mean.left,A3.pcor.mean.left,A4.pcor.mean.left,
#                   A5.pcor.mean.left,A6.pcor.mean.left,A7.pcor.mean.left,A8.pcor.mean.left)
#B.pcor.left=list(B1.pcor.mean.left,B2.pcor.mean.left,B3.pcor.mean.left,B4.pcor.mean.left,
#                   B5.pcor.mean.left,B6.pcor.mean.left,B7.pcor.mean.left,B8.pcor.mean.left)
#A.pcor.right=list(A1.pcor.mean.right,A2.pcor.mean.right,A3.pcor.mean.right,A4.pcor.mean.right,
#                   A5.pcor.mean.right,A6.pcor.mean.right,A7.pcor.mean.right,A8.pcor.mean.right)
#B.pcor.right=list(B1.pcor.mean.right,B2.pcor.mean.right,B3.pcor.mean.right,B4.pcor.mean.right,
#                 B5.pcor.mean.right,B6.pcor.mean.right,B7.pcor.mean.right,B8.pcor.mean.right)

#A.pcor=list(A1.pcor.mean,A2.pcor.mean,A3.pcor.mean,A4.pcor.mean,
#A5.pcor.mean,A6.pcor.mean,A7.pcor.mean,A8.pcor.mean)
#B.pcor=list(B1.pcor.mean,B2.pcor.mean,B3.pcor.mean,B4.pcor.mean,
#B5.pcor.mean,B6.pcor.mean,B7.pcor.mean,B8.pcor.mean)

# compare A and B --- calculate ANOVA p-values using left and right as covariates (correlation)
k=combine_cor_diff(d1=fisher_transfer(A.cor.left),d2=fisher_transfer(B.cor.left),
                   d3=fisher_transfer(A.cor.right),d4=fisher_transfer(B.cor.right),method="t.test")
k=dia_transfer(k,NA)
ROI_names=c("IC","MO","S1","CP","NAC","DB","MD","PCN","HYTH","BLA","CEA","DG","CA3","CA1","Sub","EC","ACA","RSP","MS") 
#ROI_names=c("IC","MO","S1","CP","NAC","MD","PCN","HYTH","DG","CA3","CA1","Sub","EC") 
colnames(k)=ROI_names
rownames(k)=ROI_names
#write.csv(k,"20190712_result\\combine_left_right_2wANOVA_test_pval.csv")



for(i in 1:8){
  A.cor[[i]]$rho=round(A.cor[[i]]$rho,digits=5)
  B.cor[[i]]$rho=round(B.cor[[i]]$rho,digits=5)
}

biDG <- function(d1,d2){
  helper<-function(a,b){
    v1=sapply(1:length(d1), function(x) return(round(d1[[x]]$rho[a,b],digits=6)))
    v2=sapply(1:length(d2), function(x) return(round(d2[[x]]$rho[a,b],digits=6)))
    r=c(v1,v2)
    return(r)
  }
  k=colnames(d1[[1]]$rho)
  v=sapply(1:nrow(d1[[1]]$rho),function(x) helper(x,"DG"))
  colnames(v)=k
  rownames(v)=c(rep("A",8),rep("B",8))
  return(v)
}

write.csv(biDG(fisher_transfer(A.cor),fisher_transfer(B.cor)),"region_mean_newData_20181221/20181221_result/a.csv")
write.csv(cor_diff(fisher_transfer(A.cor),fisher_transfer(B.cor),method="t.test"),
          "region_mean_newData_20181221/20181221_result/b.csv")

heatmap.2(cor_diff(fisher_transfer(A.cor),fisher_transfer(B.cor),method="t.test"),trace="none",col=bluered(100))

av<-function(d){
  t=d[[1]]$rho
  for(i in 2:8){
    t=t+d[[i]]$rho
  }
  t=t/8
  return(t)
}

heatmap.2(av(fisher_transfer(A.cor))-av(fisher_transfer(B.cor)),trace="none",col=bluered(100))
write.csv(av(A.cor),"20181218/Agroup_mean_raw_correlation.csv")
write.csv(av(B.cor),"20181218/Bgroup_mean_raw_correlation.csv")
write.csv(av(fisher_transfer(A.cor)),"20181218/Agroup_mean_fisher_transferred_correlation.csv")
write.csv(av(fisher_transfer(B.cor)),"20181218/Bgroup_mean_fisher_transferred_correlation.csv")

##################################
#pcor
q1=cal_cor_mean(A.pcor)
q1=cal_cor_mean(fisher_transfer(A.pcor))
q1=q1[-20,-20]
colnames(q1)=ROI_names
rownames(q1)=ROI_names
write.csv(q1,"20190712_result\\pcorr\\A_pcorr_matrix.csv")

q2=cal_cor_mean(B.pcor)
q2=cal_cor_mean(fisher_transfer(B.pcor))
q2=q2[-20,-20]
colnames(q2)=ROI_names
rownames(q2)=ROI_names
heatmap.2(dia_transfer(s2,max(s2)),trace="none",col=bluered(100))
write.csv(q2,"20190712_result\\pcorr\\B_pcorrp_matrix.csv")

q3=q1-q2
write.csv(q3,"20190712_result\\pcorr\\diff_pcorr_matrix.csv")
