%% combine all the trials under the directory
%% load data path
clear
clc

Data=dir('*.mat'); % extract the names of all txt files
path_data=pwd; % get current folder path

zscore_rand_CA1 = [];
zscore_rand_CA3 = []; 
 %% load data mat, preprocess
for j = [1:length(Data)] 
    file = load([path_data,'/',Data(j).name],'-mat');
    i = j-1; 
    zscore_rand_CA1(i*30+1:(i+1)*30,:) = file.zscore_rand_CA1;
    zscore_rand_CA3(i*30+1:(i+1)*30,:) = file.zscore_rand_CA3;
end

%% plot
subplot(2,1,1)
imagesc(sortrows(zscore_rand_CA1,31,'descend'))
caxis([-1 5]);
colorbar;
xlim([10 51])
title('rand CA1')
hold on
subplot(2,1,2)
imagesc(sortrows(zscore_rand_CA3,31,'descend'))
caxis([-1 5]);
colorbar;
xlim([10 51])
title('rand CA3')
hold on

%% save output
save ('zscore_rand.mat')
    
