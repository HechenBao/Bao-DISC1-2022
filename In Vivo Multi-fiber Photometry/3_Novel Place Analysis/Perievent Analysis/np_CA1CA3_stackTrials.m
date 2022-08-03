%% load data path
    clc
    Data=dir('*.mat'); % extract the names of all txt files
    path_data=pwd; % get current folder path

    rasterOld_CA3 = [];
    rasterNovel_CA3 = [];
    rasterOld_CA1 = [];
    rasterNovel_CA1 = [];
    
% raster all trials
for j = [1:length(Data)]
    %% load data mat, preprocess
    file = load([path_data,'/',Data(j).name],'-mat');
   
    rasterOld_CA3_temp = file.rasterOld_CA3;
    rasterNovel_CA3_temp = file.rasterNovel_CA3;
    rasterOld_CA1_temp = file.rasterOld_CA1;
    rasterNovel_CA1_temp = file.rasterNovel_CA1;
    
    rasterOld_CA3 = [rasterOld_CA3;rasterOld_CA3_temp];
    rasterNovel_CA3 = [rasterNovel_CA3;rasterNovel_CA3_temp];
    rasterOld_CA1 = [rasterOld_CA1;rasterOld_CA1_temp];
    rasterNovel_CA1 = [rasterNovel_CA1;rasterNovel_CA1_temp];
   
end

% zscore
    for i=1:size(rasterOld_CA3,1)
        zscore_Old_CA3(i,:) = zscore(rasterOld_CA3(i,:));
    end
    
    for i=1:size(rasterNovel_CA3,1)
        zscore_Novel_CA3(i,:) = zscore(rasterNovel_CA3(i,:));
    end    

    for i=1:size(rasterOld_CA1,1)
        zscore_Old_CA1(i,:) = zscore(rasterOld_CA1(i,:));
    end
    
    for i=1:size(rasterNovel_CA1,1)
        zscore_Novel_CA1(i,:) = zscore(rasterNovel_CA1(i,:));
    end
    
% save data
    save('raster_output.mat', 'rasterOld_CA3', 'rasterNovel_CA3','rasterOld_CA1','rasterNovel_CA1',...
        'zscore_Old_CA3','zscore_Novel_CA3','zscore_Old_CA1','zscore_Novel_CA1')
    
    
    
%% plot raster and mean curve
    before = 30;
    after = 30;
    t=[-before:after]./10;
 
% figure;
%     x0=100;
%     y0=100;
%     width=1200;
%     height=400;
%     set(gcf,'position',[x0,y0,width,height])    
%         
% %Old place
% subplot(2,4,1)
% imagesc(sortrows(rasterOld_CA1,31,'descend'))
% %xlim([0 before+after])
% title('CA1 Old Place')
% caxis([-1 2]);
% colorbar;
% subplot(2,4,2)
% plot(t,mean(rasterOld_CA1))
% xlim([t(1) t(length(t))])
% hold on
% 
% subplot(2,4,5)
% imagesc(sortrows(rasterOld_CA3,31,'descend'))
% %xlim([0 before+after])
% title('CA3 Old Place')
% caxis([-1 2]);
% colorbar;
% subplot(2,4,6)
% plot(t,mean(rasterOld_CA3))
% xlim([t(1) t(length(t))])
% hold on
% 
% %Novel place
% subplot(2,4,3)
% imagesc(sortrows(rasterNovel_CA1,31,'descend'))
% %xlim([0 before+after])
% title('CA1 Novel Place')
% caxis([-1 2]);
% colorbar;
% subplot(2,4,4)
% plot(t,mean(rasterNovel_CA1))
% xlim([t(1) t(length(t))])
% hold on
% 
% subplot(2,4,7)
% imagesc(sortrows(rasterNovel_CA3,31,'descend'))
% %xlim([0 before+after])
% title('CA3 Novel Place')
% caxis([-1 2]);
% colorbar;
% subplot(2,4,8)
% plot(t,mean(rasterNovel_CA3))
% xlim([t(1) t(length(t))])
% hold on


figure;
    x0=100;
    y0=100;
    width=1200;
    height=400;
    set(gcf,'position',[x0,y0,width,height])    

%Old place
subplot(2,4,1)
imagesc(sortrows(zscore_Old_CA1,31,'descend'))
%xlim([0 before+after])
title('z CA1 Old Place')
caxis([-1 2]);
colorbar;
subplot(2,4,2)
plot(t,mean(zscore_Old_CA1))
xlim([t(1) t(length(t))])
hold on

subplot(2,4,5)
imagesc(sortrows(zscore_Old_CA3,31,'descend'))
%xlim([0 before+after])
title('z CA3 Old Place')
caxis([-1 2]);
colorbar;
subplot(2,4,6)
plot(t,mean(zscore_Old_CA3))
xlim([t(1) t(length(t))])
hold on

%Novel place
subplot(2,4,3)
imagesc(sortrows(zscore_Novel_CA1,31,'descend'))
%xlim([0 before+after])
title('z CA1 Novel Place')
caxis([-1 2]);
colorbar;
subplot(2,4,4)
plot(t,mean(zscore_Novel_CA1))
xlim([t(1) t(length(t))])
hold on

subplot(2,4,7)
imagesc(sortrows(zscore_Novel_CA3,31,'descend'))
%xlim([0 before+after])
title('z CA3 Novel Place')
caxis([-1 2]);
colorbar;
subplot(2,4,8)
plot(t,mean(zscore_Novel_CA3))
xlim([t(1) t(length(t))])
hold on

exportgraphics(gcf,fullfile(pwd,['zscore_np_raster.pdf']),'ContentType','vector')
