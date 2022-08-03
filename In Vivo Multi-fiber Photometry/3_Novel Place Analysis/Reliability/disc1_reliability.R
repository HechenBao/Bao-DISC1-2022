rm(list = ls())    #clear environement
#sert_data <- read.csv(file.choose())

#load library
{
  library(oro.nifti)
  library(neurobase)
  library(RColorBrewer)
  library(wesanderson)
  library(scales)
  library(ggplot2)
  library(gplots)
  library(reshape)
  library(reshape2)
  library(ppcor)
  library(plyr)
  library(dplyr)
  library(ggpubr)
  library(factoextra)
  library(multcomp)
}

# set working directory and load data
{
  setwd('D:\\disc1_photometry_data\\disc1_multi-fiber\\Revision data\\revision data summary\\Reliability')
  data <- read.csv('reliability_Pool1+rand.csv')
}

{
  #define factors
  data$Group<-as.factor(data$Group)
  data$ROI<-as.factor(data$ROI)
  data$Phase<-as.factor(data$Phase)
  data$Time<-as.factor(data$Time)
}

{
 data$ROI<-factor(data$ROI,levels=c("IC","MD","CA1","CA3","DG"))
 data$Phase<-factor(data$Phase,levels=c("Hab","Test","Hab_rand","Test_rand"))
 data$Time<-factor(data$Time,levels=c("Pre","Event","Post"))
 
 data_cont <- subset(data,Group == "Control")
 data_disc1 <- subset(data,Group == "DISC1")
 
 ## difference dataframe
 data$GroupPhase <- paste(data$Group, data$Phase, sep="_")
 
 diff_rb <- data_disc1$Reliability - data_cont$Reliability
 data_cont$diff_rb <- diff_rb  
 
 data_cont_hab <- subset(data,Group == "Control" & Phase == 'Hab')
 data_cont_test <- subset(data,Group == "Control" & Phase == 'Test')
 
 data_disc1_hab <- subset(data,Group == "DISC1" & Phase == 'Hab')
 data_disc1_test <- subset(data,Group == "DISC1" & Phase == 'Test')
 
 data_cont_habrand <- subset(data,Group == "Control" & Phase == 'Hab_rand')
 data_cont_testrand <- subset(data,Group == "Control" & Phase == 'Test_rand')
 
 data_disc1_habrand <- subset(data,Group == "DISC1" & Phase == 'Hab_rand')
 data_disc1_testrand <- subset(data,Group == "DISC1" & Phase == 'Test_rand')
 
}
 

 ## zscore 
 {
 p.zscore.cont.hab <- ggplot()+geom_tile(aes(x=data_cont_hab$Time,y=data_cont_hab$ROI,fill=data_cont_hab$zscore))+
   scale_fill_gradient2(low=("deepskyblue4"),mid="white",high=("firebrick1"),midpoint=0)+
   scale_x_discrete(expand = c(0, 0)) +
   scale_y_discrete(expand = c(0, 0)) + 
   theme(legend.title = element_blank())+
   coord_equal()  
 
 p.zscore.cont.test <- ggplot()+geom_tile(aes(x=data_cont_test$Time,y=data_cont_test$ROI,fill=data_cont_test$zscore))+
   scale_fill_gradient2(low=("deepskyblue4"),mid="white",high=("firebrick1"),midpoint=0)+
   scale_x_discrete(expand = c(0, 0)) +
   scale_y_discrete(expand = c(0, 0)) + 
   theme(legend.title = element_blank())+
   coord_equal()  
 
 p.zscore.disc1.hab <- ggplot()+geom_tile(aes(x=data_disc1_hab$Time,y=data_disc1_hab$ROI,fill=data_disc1_hab$zscore))+
   scale_fill_gradient2(low=("deepskyblue4"),mid="white",high=("firebrick1"),midpoint=0)+
   scale_x_discrete(expand = c(0, 0)) +
   scale_y_discrete(expand = c(0, 0)) + 
   theme(legend.title = element_blank())+
   coord_equal()  
 
 p.zscore.disc1.test <- ggplot()+geom_tile(aes(x=data_disc1_test$Time,y=data_disc1_test$ROI,fill=data_disc1_test$zscore))+
   scale_fill_gradient2(low=("deepskyblue4"),mid="white",high=("firebrick1"),midpoint=0)+
   scale_x_discrete(expand = c(0, 0)) +
   scale_y_discrete(expand = c(0, 0)) + 
   theme(legend.title = element_blank())+
   coord_equal()
 
 zscore.plot<-ggarrange(p.zscore.cont.hab, p.zscore.cont.test, p.zscore.disc1.hab,p.zscore.disc1.test, 
                              labels = c("Cont hab", "Cont test", "DISC1 hab", "DISC1 test"),
                              ncol = 2, nrow = 2)
                        
 pdf("zscore.plot.pdf",     # File name
     width = 8, height = 7, # Width and height in inches
     paper = "A4")          # Paper size
 plot(zscore.plot)
 dev.off()
 }
 
 ## Reliability 
 {
 rb_min <- min(data$Reliability)
 rb_max <- max(data$Reliability)
 print(rb_min) 
 print(rb_max)
 }

 {
 p.rb.cont.hab <- ggplot()+geom_tile(aes(x=data_cont_hab$Time,y=data_cont_hab$ROI,fill=data_cont_hab$Reliability))+
   scale_fill_gradient2(low=("deepskyblue4"),mid="white",high=("firebrick1"), limits = c(0,rb_max))+
   scale_x_discrete(expand = c(0, 0)) +
   scale_y_discrete(expand = c(0, 0)) + 
   theme(legend.title = element_blank())+
   coord_equal()  
 
 p.rb.cont.test <- ggplot()+geom_tile(aes(x=data_cont_test$Time,y=data_cont_test$ROI,fill=data_cont_test$Reliability))+
   scale_fill_gradient2(low=("deepskyblue4"),mid="white",high=("firebrick1"), limits = c(0,rb_max))+
   scale_x_discrete(expand = c(0, 0)) +
   scale_y_discrete(expand = c(0, 0)) + 
   theme(legend.title = element_blank())+
   coord_equal()  
 
 p.rb.disc1.hab <- ggplot()+geom_tile(aes(x=data_disc1_hab$Time,y=data_disc1_hab$ROI,fill=data_disc1_hab$Reliability))+
   scale_fill_gradient2(low=("deepskyblue4"),mid="white",high=("firebrick1"),limits = c(0,rb_max))+
   scale_x_discrete(expand = c(0, 0)) +
   scale_y_discrete(expand = c(0, 0)) + 
   theme(legend.title = element_blank())+ 
   coord_equal()  
 
 p.rb.disc1.test <- ggplot()+geom_tile(aes(x=data_disc1_test$Time,y=data_disc1_test$ROI,fill=data_disc1_test$Reliability))+
   scale_fill_gradient2(low=("deepskyblue4"),mid="white",high=("firebrick1"), limits = c(0,rb_max))+
   scale_x_discrete(expand = c(0, 0)) +
   scale_y_discrete(expand = c(0, 0)) + 
   theme(legend.title = element_blank())+
   coord_equal()
 
 rb.plot<-ggarrange(p.rb.cont.hab, p.rb.cont.test, p.rb.disc1.hab,p.rb.disc1.test, 
                        labels = c("Cont hab", "Cont test", "DISC1 hab", "DISC1 test"),
                        ncol = 2, nrow = 2)
 pdf("reliability.plot.pdf",     # File name
     width = 8, height = 7, # Width and height in inches
     paper = "A4")          # Paper size
 plot(rb.plot)
 dev.off()
 }


 ## random event reliability
{ 
 p.rb.cont.habrand <- ggplot()+geom_tile(aes(x=data_cont_habrand$Time,y=data_cont_habrand$ROI,fill=data_cont_habrand$Reliability))+
   scale_fill_gradient2(low=("deepskyblue4"),mid="white",high=("firebrick1"), limits = c(0,rb_max))+
   scale_x_discrete(expand = c(0, 0)) +
   scale_y_discrete(expand = c(0, 0)) + 
   theme(legend.title = element_blank())+
   coord_equal()  
 
 p.rb.cont.testrand <- ggplot()+geom_tile(aes(x=data_cont_testrand$Time,y=data_cont_testrand$ROI,fill=data_cont_testrand$Reliability))+
   scale_fill_gradient2(low=("deepskyblue4"),mid="white",high=("firebrick1"), limits = c(0,rb_max))+
   scale_x_discrete(expand = c(0, 0)) +
   scale_y_discrete(expand = c(0, 0)) + 
   theme(legend.title = element_blank())+
   coord_equal()  
 
 p.rb.disc1.habrand <- ggplot()+geom_tile(aes(x=data_disc1_habrand$Time,y=data_disc1_habrand$ROI,fill=data_disc1_habrand$Reliability))+
   scale_fill_gradient2(low=("deepskyblue4"),mid="white",high=("firebrick1"),limits = c(0,rb_max))+
   scale_x_discrete(expand = c(0, 0)) +
   scale_y_discrete(expand = c(0, 0)) + 
   theme(legend.title = element_blank())+
   coord_equal()  
 
 p.rb.disc1.testrand <- ggplot()+geom_tile(aes(x=data_disc1_testrand$Time,y=data_disc1_testrand$ROI,fill=data_disc1_testrand$Reliability))+
   scale_fill_gradient2(low=("deepskyblue4"),mid="white",high=("firebrick1"), limits = c(0,rb_max))+
   scale_x_discrete(expand = c(0, 0)) +
   scale_y_discrete(expand = c(0, 0)) + 
   theme(legend.title = element_blank())+
   coord_equal()
 
 rb_rand.plot<-ggarrange(p.rb.cont.habrand, p.rb.cont.testrand, p.rb.disc1.habrand,p.rb.disc1.testrand, 
                    labels = c("Cont hab", "Cont test", "DISC1 hab", "DISC1 test"),
                    ncol = 2, nrow = 2)
 pdf("reliability_rand.plot.pdf",     # File name
     width = 8, height = 7, # Width and height in inches
     paper = "A4")          # Paper size
 plot(rb_rand.plot)
 dev.off()
}
 
 ## Event reliability
{
 data_event_hab = subset(data,Phase == "Hab" & Time == "Event")
 data_event_test = subset(data,Phase == "Test" & Time == "Event")

 p.event.rb.hab <- ggplot()+geom_tile(aes(x=data_event_hab$Group,y=data_event_hab$ROI,fill=data_event_hab$Reliability))+
  scale_fill_gradient2(low=("deepskyblue4"),mid="white",high=("firebrick1"),limits = c(0,rb_max))+
  scale_x_discrete(expand = c(0, 0)) +
  scale_y_discrete(expand = c(0, 0)) + 
  theme(legend.title = element_blank())+
  coord_equal()   
 
 p.event.rb.test <- ggplot()+geom_tile(aes(x=data_event_test$Group,y=data_event_test$ROI,fill=data_event_test$Reliability))+
   scale_fill_gradient2(low=("deepskyblue4"),mid="white",high=("firebrick1"),limits = c(0,rb_max))+
   scale_x_discrete(expand = c(0, 0)) +
   scale_y_discrete(expand = c(0, 0)) + 
   theme(legend.title = element_blank())+
   coord_equal()  

  data_cont_hab <- subset(data_cont,Phase == "Hab")
  data_cont_test <- subset(data_cont,Phase == "Test")
  
  p.diff.rb.hab <- ggplot()+geom_tile(aes(x=data_cont_hab$Time,y=data_cont_hab$ROI,fill=data_cont_hab$diff_rb))+
    scale_fill_gradient2(low=("deepskyblue4"),mid="white",high=("firebrick1"),midpoint=0,limits = c(min(data_cont$diff_rb),max(data_cont$diff_rb)))+
    scale_x_discrete(expand = c(0, 0)) +
    scale_y_discrete(expand = c(0, 0)) + 
    theme(legend.title = element_blank())+
    coord_equal()  
  p.diff.rb.test <- ggplot()+geom_tile(aes(x=data_cont_test$Time,y=data_cont_test$ROI,fill=data_cont_test$diff_rb))+
    scale_fill_gradient2(low=("deepskyblue4"),mid="white",high=("firebrick1"),midpoint=0,limits = c(min(data_cont$diff_rb),max(data_cont$diff_rb)))+
    scale_x_discrete(expand = c(0, 0)) +
    scale_y_discrete(expand = c(0, 0)) + 
    theme(legend.title = element_blank())+
    coord_equal()  
  
  diff_rb.plot <- ggarrange(p.event.rb.hab, p.event.rb.test, p.diff.rb.hab,p.diff.rb.test, 
                          labels = c("rb event hab", "rb event test", "diff.rb hab", "diff.rb test"),
                          ncol = 2, nrow = 2)
  pdf("diff.reliability.plot.pdf",     # File name
      width = 8, height = 7, # Width and height in inches
      paper = "A4")          # Paper size
  plot(diff_rb.plot)
  dev.off()
  }

  

  data_cont_hab$GroupROI <- paste(data_cont_hab$Group,data_cont_hab$ROI, sep="_")
  data_cont_hab_weight <- aggregate(abs(data_cont_hab$diff_rb), list(data_cont_hab$GroupROI), sum)
  colnames(data_cont_hab_weight) <- c('ROI','weight')
  
  data_cont_test$GroupROI <- paste(data_cont_test$Group,data_cont_test$ROI, sep="_")
  data_cont_test_weight <- aggregate(abs(data_cont_test$diff_rb), list(data_cont_test$GroupROI), sum)
  colnames(data_cont_test_weight) <- c('ROI','weight')
  
  # ggplot(data=data_cont_hab_weight,aes(x=(ROI),y=(weight)))+geom_bar()
                                    
 
## ANOVA test
  # data_hab = subset(data,Phase == "Hab")
  # result_zscore.hab <- lm(formula = zscore~Group+Time+ROI+Group*ROI, data = data_hab)
  # anova(result_zscore.hab)
  # summary(result_zscore.hab)

  
  
                      