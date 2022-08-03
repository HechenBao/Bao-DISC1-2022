%% reliability NPR behavior traces
%% load data path
clc 
Data=dir('*.mat'); % extract the names of all txt files
path_data=pwd; % get current folder path

%% load data mat, preprocess
for i = [1:length(Data)]
    load([path_data,'/',Data(i).name],'-mat');

   Parameter 1
    x = data(:,(11:26));    % pre [-2,-0.5]
    y = data(:,(26:41));    % event [-0.5,1]
    z = data(:,(41:56));    %post [1, 2.5]

% %    Parameter 2
%     x = data(:,(1:20));    % pre [-3,-1]
%     y = data(:,(20:41));    % event [-1,1]
%     z = data(:,(41:61));    %post [1, 3]
    
%% reliability 
% Pre
[c_pre,CrossCov_pre,tlag_pre] = crosscov(x,x,0.1); % original tlag=100, [c,CrossCov,tlag]=crosscov(x,x,100); 
response_cov_pre = nanmean(CrossCov_pre);
response_ste_pre = (nanstd(CrossCov_pre)./sqrt(size(CrossCov_pre,1)));
response_reliability_pre = c_pre;
n_pre = size(x);
peak_ste_pre = response_ste_pre(find(response_cov_pre == c_pre));

% Event
[c_event,CrossCov_event,tlag_event] = crosscov(y,y,0.1); % original tlag=100, [c,CrossCov,tlag]=crosscov(x,x,100); 
response_cov_event = nanmean(CrossCov_event);
response_ste_event = (nanstd(CrossCov_event)./sqrt(size(CrossCov_event,1)));
response_reliability_event = c_event;
n_event = size(x);
peak_ste_event = response_ste_event(find(response_cov_event == c_event));

% Post
[c_post,CrossCov_post,tlag_post] = crosscov(z,z,0.1); % original tlag=100, [c,CrossCov,tlag]=crosscov(x,x,100); 
response_cov_post = nanmean(CrossCov_post);
response_ste_post = (nanstd(CrossCov_post)./sqrt(size(CrossCov_post,1)));
response_reliability_post = c_post;
n_post = size(x);
peak_ste_post = response_ste_post(find(response_cov_post == c_post));

% pool pre, event, post variables
n = [n_pre; n_event; n_post];
peak_ste = [peak_ste_pre; peak_ste_event; peak_ste_post];
response_reliability = [response_reliability_pre; response_reliability_event; response_reliability_post];
rzscore = zscore(response_reliability);

% export and save data
export_path = path_data;
varName = Data(i).name(1:end-4); 

output_sum = [response_reliability, peak_ste, n(:,1), rzscore];  
header = {'response_reliability', 'peak_ste', 'n','zscore'};
output = [header; num2cell(output_sum)];

save(fullfile(export_path,'PreEventPost',['output_' varName '.mat']), 'output_sum',...
    'response_reliability','peak_ste','n',...
    'response_cov_pre','response_cov_event','response_cov_post',...
    'response_ste_pre','response_ste_event','response_ste_post',...
    'tlag_pre','tlag_event','tlag_post')

close


end



% figure('Position', [400 400 400 400])    
% plot(tlag,(nanmean(CrossCov)),'r');hold on
% plot(tlag,response_cov+response_ste,'c-.');
% plot(tlag,response_cov-response_ste,'c-.') 
% hold on;plot([0 0],[-c,c+0.01],'k-.')
% hold on;plot([tlag(1),tlag(end)],[0 0],'k-.')
% ylim([-0.3, 0.3])
% xlabel('Time (sec)'); 
% ylabel('Reliability');
% saveas(gcf,fullfile(export_path,'For plots 22',[varName '_reliability.eps']))
% saveas(gcf,fullfile(export_path,'For plots 22',[varName '_reliability.png']))



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

%  xx = normalized(x);
%  yy = normalized(y);
%  mn = size(xx);
%  
% for i = 1:mn(1)
%  sparseness22(i) = sparseness_mrate(xx(i,:));
%  sparseness105(i)=sparseness_mrate(yy(i,:));
% end
% 
% sparseness22_ste = (nanstd(sparseness22)./sqrt(size(sparseness22,2)));
% sparseness22_mean = mean(sparseness22);
% 
% sparseness105_ste = (nanstd(sparseness105)./sqrt(size(sparseness105,2)));
% sparseness105_mean = mean(sparseness105);
% 


