%% load data path
clc
Data=dir('*.mat'); % extract the names of all txt files
path_data=pwd; % get current folder path 

%% input event timepoint, expanded time window
for j = [1:length(Data)]
    %% load data mat, preprocess
    file = load([path_data,'/',Data(j).name],'-mat');

    DG_ratio = file.DG_ratio;
    CA3_ratio = file.CA3_ratio;
    eventOld = file.eventOld;
    eventNovel = file.eventNovel;

    before = 30;
    after = 30;
    t=[-before:after]./10;

    rasterOld_CA3 = [];
    rasterNovel_CA3 = [];
    rasterOld_DG = [];
    rasterNovel_DG = [];
    
    zscore_Old_CA3 = [];
    zscore_Novel_CA3 = [];
    zscore_Old_DG = [];
    zscore_Novel_DG = [];
    

    filtered_eventOld = eventOld(eventOld>=before & eventOld<=(length(DG_ratio)-after));
    filtered_eventNovel = eventNovel(eventNovel>=before & eventNovel<=(length(DG_ratio)-after));

%% extract CA3 event perievent data

    for i=1:length(filtered_eventOld)
        rasterOld_CA3(i,:)=CA3_ratio(filtered_eventOld(i)-before:filtered_eventOld(i)+after);
    end

    for i=1:length(filtered_eventNovel)
        rasterNovel_CA3(i,:)=CA3_ratio(filtered_eventNovel(i)-before:filtered_eventNovel(i)+after);
    end

%% extract DG event perievent data

    for i=1:length(filtered_eventOld)
        rasterOld_DG(i,:)=DG_ratio(filtered_eventOld(i)-before:filtered_eventOld(i)+after);
    end

    for i=1:length(filtered_eventNovel)
        rasterNovel_DG(i,:)=DG_ratio(filtered_eventNovel(i)-before:filtered_eventNovel(i)+after);
    end
%% zscore
    for i=1:length(filtered_eventOld)
        zscore_Old_CA3(i,:) = zscore(rasterOld_CA3(i,:));
    end
    
    for i=1:length(filtered_eventNovel)
        zscore_Novel_CA3(i,:) = zscore(rasterNovel_CA3(i,:));
    end    

    for i=1:length(filtered_eventOld)
        zscore_Old_DG(i,:) = zscore(rasterOld_DG(i,:));
    end
    
    for i=1:length(filtered_eventNovel)
        zscore_Novel_DG(i,:) = zscore(rasterNovel_DG(i,:));
    end    

    %% save data
    varName = Data(j).name(1: end-4); 
    save(fullfile(path_data, [varName '.mat']))
  
end




