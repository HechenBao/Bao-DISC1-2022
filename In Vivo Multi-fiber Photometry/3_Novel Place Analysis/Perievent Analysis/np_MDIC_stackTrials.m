%% load data path
    clc
    Data=dir('*.mat'); % extract the names of all txt files
    path_data=pwd; % get current folder path

    rasterOld_MD = [];
    rasterNovel_MD = [];
    rasterOld_IC = [];
    rasterNovel_IC = [];
    
% raster all trials
for j = [1:length(Data)]
    %% load data mat, preprocess
    file = load([path_data,'/',Data(j).name],'-mat');
   
    rasterOld_MD_temp = file.rasterOld_MD;
    rasterNovel_MD_temp = file.rasterNovel_MD;
    rasterOld_IC_temp = file.rasterOld_IC;
    rasterNovel_IC_temp = file.rasterNovel_IC;
    
    rasterOld_MD = [rasterOld_MD;rasterOld_MD_temp];
    rasterNovel_MD = [rasterNovel_MD;rasterNovel_MD_temp];
    rasterOld_IC = [rasterOld_IC;rasterOld_IC_temp];
    rasterNovel_IC = [rasterNovel_IC;rasterNovel_IC_temp];
   
end

% zscore
    for i=1:size(rasterOld_MD,1)
        zscore_Old_MD(i,:) = zscore(rasterOld_MD(i,:));
    end
    
    for i=1:size(rasterNovel_MD,1)
        zscore_Novel_MD(i,:) = zscore(rasterNovel_MD(i,:));
    end    

    for i=1:size(rasterOld_IC,1)
        zscore_Old_IC(i,:) = zscore(rasterOld_IC(i,:));
    end
    
    for i=1:size(rasterNovel_IC,1)
        zscore_Novel_IC(i,:) = zscore(rasterNovel_IC(i,:));
    end
    
% save data
    save('raster_output.mat', 'rasterOld_MD', 'rasterNovel_MD','rasterOld_IC','rasterNovel_IC',...
        'zscore_Old_MD','zscore_Novel_MD','zscore_Old_IC','zscore_Novel_IC')
    
    
    
%% plot raster and mean curve
    before = 30;
    after = 30;
    t=[-before:after]./10;
 
figure;
    x0=100;
    y0=100;
    width=1200;
    height=400;
    set(gcf,'position',[x0,y0,width,height])    

%Old place
subplot(2,4,1)
imagesc(sortrows(zscore_Old_IC,31,'descend'))
%xlim([0 before+after])
title('z IC Old Place')
caxis([-1 2]);
colorbar;
subplot(2,4,2)
plot(t,mean(zscore_Old_IC))
xlim([t(1) t(length(t))])
hold on

subplot(2,4,5)
imagesc(sortrows(zscore_Old_MD,31,'descend'))
%xlim([0 before+after])
title('z MD Old Place')
caxis([-1 2]);
colorbar;
subplot(2,4,6)
plot(t,mean(zscore_Old_MD))
xlim([t(1) t(length(t))])
hold on

%Novel place
subplot(2,4,3)
imagesc(sortrows(zscore_Novel_IC,31,'descend'))
%xlim([0 before+after])
title('z IC Novel Place')
caxis([-1 2]);
colorbar;
subplot(2,4,4)
plot(t,mean(zscore_Novel_IC))
xlim([t(1) t(length(t))])
hold on

subplot(2,4,7)
imagesc(sortrows(zscore_Novel_MD,31,'descend'))
%xlim([0 before+after])
title('z MD Novel Place')
caxis([-1 2]);
colorbar;
subplot(2,4,8)
plot(t,mean(zscore_Novel_MD))
xlim([t(1) t(length(t))])
hold on

exportgraphics(gcf,fullfile(pwd,['zscore_np_raster.pdf']),'ContentType','vector')
