%% np behavior non-event
%% load data path
clc
Data=dir('*.mat'); % extract the names of all txt files
path_data=pwd; % get current folder path

%% generate randomized events
for j = [1:length(Data)]
    %% load data mat, preprocess
    file = load([path_data,'/',Data(j).name],'-mat');

    IC_ratio = file.IC_ratio;
    MD_ratio = file.MD_ratio;
    eventOld = file.eventOld;
    eventNovel = file.eventNovel;
    
    event = [eventOld;eventNovel]';
    before = 30;
    after = 30;

    iMin = 1+before;
    iMax = size(IC_ratio,2)-after;
    %numToTake = 50; % Must be less than iMax - iMin
    % Get (iMax-iMin) numbers between iMin and iMax
    r = randperm(iMax-iMin) + iMin;
    % extract random non-event data
    numberToRemove = event;
    % remove event timestamps
    for i = 1:size(event,2)
        r(r == numberToRemove(1,i)) = []; % r is smaller now.
    end
    % Now get the first 30 random numbers.
    r = r(1:30);

    %% generate non-event trials
    for i = 1:size(r,2)
        raster_random_IC(i,:) = IC_ratio(r(i)-before:r(i)+after);
    end
    for i = 1:size(r,2)
        raster_random_MD(i,:) = MD_ratio(r(i)-before:r(i)+after);
    end

    %normalize to z-score
    for i=1:size(r,2)
        zscore_rand_IC(i,:) = zscore(raster_random_IC(i,:));
    end
    for i=1:size(r,2)
        zscore_rand_MD(i,:) = zscore(raster_random_MD(i,:));
    end
    
     varName = Data(j).name(1:12); 

    %% output data, change folder
    %% hM4 MDIC
    % hab save
%     savdir = 'D:\disc1_photometry_data\disc1_multi-fiber\Revision data\revision codes\np\reliability\M4\rand events\M4 hab rand\Output';
%     save(fullfile(savdir,[varName '_rand.mat']),'zscore_rand_IC','zscore_rand_MD') % save for individual animal
%     
    % test save
%     savdir = 'D:\disc1_photometry_data\disc1_multi-fiber\Revision data\revision codes\np\reliability\M4\rand events\M4 test rand\Output';
%     save(fullfile(savdir,[varName '_rand.mat']),'zscore_rand_IC','zscore_rand_MD') % save for individual animal
     
    %% AM3 MDIC
    % hab save
%     savdir = 'D:\disc1_photometry_data\disc1_multi-fiber\Revision data\revision codes\np\reliability\AM3\rand events\AM3 hab rand\Output';
%     save(fullfile(savdir,[varName '_rand.mat']),'zscore_rand_IC','zscore_rand_MD') % save for individual animal
%     
    % test save
%     savdir = 'D:\disc1_photometry_data\disc1_multi-fiber\Revision data\revision codes\np\reliability\AM3\rand events\AM3 test rand\Output';
%     save(fullfile(savdir,[varName '_rand.mat']),'zscore_rand_IC','zscore_rand_MD') % save for individual animal
%      
    %% MDIC
    % hab save
%     savdir = 'D:\disc1_photometry_data\disc1_multi-fiber\Revision data\revision codes\np\reliability\MDIC\rand events\MDIC hab rand\Output';
%     save(fullfile(savdir,[varName '_rand.mat']),'zscore_rand_IC','zscore_rand_MD') % save for individual animal
%     
    % test save
%     savdir = 'D:\disc1_photometry_data\disc1_multi-fiber\Revision data\revision codes\np\reliability\MDIC\rand events\MDIC test rand\Output';
%     save(fullfile(savdir,[varName '_rand.mat']),'zscore_rand_IC','zscore_rand_MD') % save for individual animal
%   
    %% Rap MDIC
    % hab save
%     savdir = 'D:\disc1_photometry_data\disc1_multi-fiber\Revision data\revision codes\np\reliability\Rap\rand events\Rap hab rand\Output';
%     save(fullfile(savdir,[varName '_rand.mat']),'zscore_rand_IC','zscore_rand_MD') % save for individual animal
%     
    % test save
    savdir = 'D:\disc1_photometry_data\disc1_multi-fiber\Revision data\revision codes\np\reliability\Rap\rand events\Rap test rand\Output';
    save(fullfile(savdir,[varName '_rand.mat']),'zscore_rand_IC','zscore_rand_MD') % save for individual animal
  
end
