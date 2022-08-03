%% reliability NPR behavior traces
%% load data path
clc
Data=dir('*.mat'); % extract the names of all txt files
path_data=pwd; % get current folder path

%% load data mat, preprocess
for i = [1:length(Data)]
    load([path_data,'/',Data(i).name],'-mat');
    x = data(:,(11:51));
    y = data(:,(21:36));

%% reliability [-2,2]
[c,CrossCov,tlag] = crosscov(x,x,0.1); % original tlag=100, [c,CrossCov,tlag]=crosscov(x,x,100); 
response_cov = nanmean(CrossCov);
response_ste = (nanstd(CrossCov)./sqrt(size(CrossCov,1)));
response_reliability = c
n = size(x);

figure('Position', [400 400 400 400])    
plot(tlag,(nanmean(CrossCov)),'r');hold on
plot(tlag,response_cov+response_ste,'c-.');
plot(tlag,response_cov-response_ste,'c-.') 
hold on;plot([0 0],[-c,c+0.01],'k-.')
hold on;plot([tlag(1),tlag(end)],[0 0],'k-.')
ylim([-0.3, 0.3])
xlabel('Time (sec)'); 
ylabel('Reliability');

peak_ste = response_ste(find(response_cov == c));

export_path = path_data;
varName = Data(i).name(1:end-4); 

save(fullfile(export_path,'For plots 22',['output_' varName '.mat']),'response_reliability','peak_ste','n','response_cov','response_ste','tlag')
saveas(gcf,fullfile(export_path,'For plots 22',[varName '_reliability.eps']))
saveas(gcf,fullfile(export_path,'For plots 22',[varName '_reliability.png']))
close

%% reliability [-1,0.5]
[c,CrossCov,tlag] = crosscov(y,y,0.1); % original tlag=100, [c,CrossCov,tlag]=crosscov(x,x,100); 
response_cov = nanmean(CrossCov);
response_ste = (nanstd(CrossCov)./sqrt(size(CrossCov,1)));
response_reliability = c
n = size(x);

figure('Position', [400 400 400 400])    
plot(tlag,(nanmean(CrossCov)),'r');hold on
plot(tlag,response_cov+response_ste,'c-.');
plot(tlag,response_cov-response_ste,'c-.') 
hold on;plot([0 0],[-c,c+0.01],'k-.')
hold on;plot([tlag(1),tlag(end)],[0 0],'k-.')
ylim([-0.3, 0.3])
xlabel('Time (sec)'); 
ylabel('Reliability');

peak_ste = response_ste(find(response_cov == c));

export_path = path_data;
varName = Data(i).name(1:end-4); 

save(fullfile(export_path,'For plots 105',['output_' varName '.mat']),'response_reliability','peak_ste','n','response_cov','response_ste','tlag')
saveas(gcf,fullfile(export_path,'For plots 105',[varName '_reliability.eps']))
saveas(gcf,fullfile(export_path,'For plots 105',[varName '_reliability.png']))
close all

end

% %% sparseness before vs after modified by Yuguo??
%  xx=normalized(x);
%  mn=size(xx);
% for i=1:mn(1)
%  sbefore(i)=sparseness_mrate(xx(i,1:end/2));
%  safter(i)=sparseness_mrate(xx(i,end/2+1:end));
% end
% 
% response_sparseness0=mean(sbefore)
% response_sparsenesst=mean(safter)

%%  sparseness

 xx = normalized(x);
 yy = normalized(y);
 mn = size(xx);
 
for i = 1:mn(1)
 sparseness22(i) = sparseness_mrate(xx(i,:));
 sparseness105(i)=sparseness_mrate(yy(i,:));
end

sparseness22_ste = (nanstd(sparseness22)./sqrt(size(sparseness22,2)));
sparseness22_mean = mean(sparseness22);

sparseness105_ste = (nanstd(sparseness105)./sqrt(size(sparseness105,2)));
sparseness105_mean = mean(sparseness105);



