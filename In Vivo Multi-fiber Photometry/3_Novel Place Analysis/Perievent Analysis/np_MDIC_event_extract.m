%% load data path
clc
Data=dir('*.mat'); % extract the names of all txt files
path_data=pwd; % get current folder path

%% input event timepoint, expanded time window
for j = [1:length(Data)]
    %% load data mat, preprocess
    file = load([path_data,'/',Data(j).name],'-mat');

    IC_ratio = file.IC_ratio;
    MD_ratio = file.MD_ratio;
    eventOld = file.eventOld;
    eventNovel = file.eventNovel;

    before = 30;
    after = 30;
    t=[-before:after]./10;

    rasterOld_MD = [];
    rasterNovel_MD = [];
    rasterOld_IC = [];
    rasterNovel_IC = [];
    
    zscore_Old_MD = [];
    zscore_Novel_MD = [];
    zscore_Old_IC = [];
    zscore_Novel_IC = [];
    

    filtered_eventOld = eventOld(eventOld>=before & eventOld<=(length(IC_ratio)-after));
    filtered_eventNovel = eventNovel(eventNovel>=before & eventNovel<=(length(IC_ratio)-after));

%% extract MD event perievent data

    for i=1:length(filtered_eventOld)
        rasterOld_MD(i,:)=MD_ratio(filtered_eventOld(i)-before:filtered_eventOld(i)+after);
    end

    for i=1:length(filtered_eventNovel)
        rasterNovel_MD(i,:)=MD_ratio(filtered_eventNovel(i)-before:filtered_eventNovel(i)+after);
    end

%% extract IC event perievent data

    for i=1:length(filtered_eventOld)
        rasterOld_IC(i,:)=IC_ratio(filtered_eventOld(i)-before:filtered_eventOld(i)+after);
    end

    for i=1:length(filtered_eventNovel)
        rasterNovel_IC(i,:)=IC_ratio(filtered_eventNovel(i)-before:filtered_eventNovel(i)+after);
    end
%% zscore
    for i=1:length(filtered_eventOld)
        zscore_Old_MD(i,:) = zscore(rasterOld_MD(i,:));
    end
    
    for i=1:length(filtered_eventNovel)
        zscore_Novel_MD(i,:) = zscore(rasterNovel_MD(i,:));
    end    

    for i=1:length(filtered_eventOld)
        zscore_Old_IC(i,:) = zscore(rasterOld_IC(i,:));
    end
    
    for i=1:length(filtered_eventNovel)
        zscore_Novel_IC(i,:) = zscore(rasterNovel_IC(i,:));
    end    

    %% save data
    varName = Data(j).name(1: end-4); 
    save(fullfile(path_data, [varName '.mat']))
  
end




