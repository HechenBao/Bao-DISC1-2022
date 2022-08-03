function [] = Rep_threshold_NP_MDIC (IC_ratio, MD_ratio, fs, sd, before, after, eventNovel, eventOld, name, output_dir)
% This function is to apply multiple threshold to the data, and get calcium
% events associated with NPR events

% IC_ratio, ROI1 data
% MD_ratio, ROI2 data
% fs, sampling frequency
% sd,  threshold further multiply by standard deviation
% before, time window before NPR event
% after, time window after NPR event
% eventNovel, event of sniffing Novel object
% eventOld, event of sniffing Old object
% name, nameof the executed file
% output_dir, output directory for the processed data
    
%% General parameters

    s = size(IC_ratio,2);   % length of the recording
    time = [1:1:s]./60./fs;  % convert to minute
        
%     export_path = path_data(1:end-5);       % export path
    
%% IC threshold analysis
   
% thresholding total recording session
% find peak raw data, thresholding at 2SD
    [pks_IC,locs_IC] = findpeaks(IC_ratio,'MinPeakDistance',1);
    threshold_IC_SD = sd*std(IC_ratio);
    locs_IC_SD = locs_IC(pks_IC>threshold_IC_SD);
    pks_IC_SD = IC_ratio(locs_IC_SD);

% exclude peaks from 1st round, and find peak for rest of the data, thresholding at 2SD
    IC_ratio_2 = IC_ratio;
    IC_ratio_2 (IC_ratio_2 > threshold_IC_SD) = nan;
    threshold_IC_SD_2 = sd*std(IC_ratio_2(~isnan(IC_ratio_2)));
    [pks_IC_2,locs_IC_2] = findpeaks(IC_ratio_2,'MinPeakDistance',1);
    locs_IC_SD_2 = locs_IC_2(pks_IC_2>threshold_IC_SD_2);
    pks_IC_SD_2 = IC_ratio(locs_IC_SD_2);

% exclude peaks from 1st, 2nd round, and find peak for rest of the data, thresholding at 2SD
    IC_ratio_3 = IC_ratio;
    IC_ratio_3 (IC_ratio_3 > threshold_IC_SD_2) = nan;
    threshold_IC_SD_3 = sd*std(IC_ratio_3(~isnan(IC_ratio_3)));
    [pks_IC_3,locs_IC_3] = findpeaks(IC_ratio_3,'MinPeakDistance',1);
    locs_IC_SD_3 = locs_IC_3(pks_IC_3>threshold_IC_SD_3);
    pks_IC_SD_3 = IC_ratio(locs_IC_SD_3);

    eventCount_IC1 = length(locs_IC_SD);
    eventCount_IC2 = length(locs_IC_SD_2);
    eventCount_IC3 = length(locs_IC_SD_3);
    eventSum_IC =  length(locs_IC_SD) +  length(locs_IC_SD_2)+length(locs_IC_SD_3);

% analysis frequency, amplitude, AUC
    frequency_IC = eventSum_IC./(s/fs); % frequency in Hz
    amplitude_IC = mean([pks_IC_SD, pks_IC_SD_2, pks_IC_SD_3]); % averaged Ca2+ event peak values
    AUC_IC = sum(IC_ratio(IC_ratio>threshold_IC_SD_3)); % sum of everything above the 3rd threshold
    above_SD_IC = sum(IC_ratio>threshold_IC_SD_3)./s*100; % sum of datapoints above the 3rd threshold

    Output_overall_IC = [frequency_IC, amplitude_IC, AUC_IC, above_SD_IC];
    Output_thresholds_IC = [threshold_IC_SD,threshold_IC_SD_2,threshold_IC_SD_3];
    
    
%% MD threshold analysis

% thresholding total recording session
% find peak raw data, thresholding at 2SD
    [pks_MD,locs_MD] = findpeaks(MD_ratio,'MinPeakDistance',1);
    threshold_MD_SD = sd*std(MD_ratio);
    locs_MD_SD = locs_MD(pks_MD>threshold_MD_SD);
    pks_MD_SD = MD_ratio(locs_MD_SD);

% exclude peaks from 1st round, and find peak for rest of the data, thresholding at 2SD
    MD_ratio_2 = MD_ratio;
    MD_ratio_2 (MD_ratio_2 > threshold_MD_SD) = nan;
    threshold_MD_SD_2 = sd*std(MD_ratio_2(~isnan(MD_ratio_2)));
    [pks_MD_2,locs_MD_2] = findpeaks(MD_ratio_2,'MinPeakDistance',1);
    locs_MD_SD_2 = locs_MD_2(pks_MD_2>threshold_MD_SD_2);
    pks_MD_SD_2 = MD_ratio(locs_MD_SD_2);

% exclude peaks from 1st, 2nd round, and find peak for rest of the data, thresholding at 2SD
    MD_ratio_3 = MD_ratio;
    MD_ratio_3 (MD_ratio_3 > threshold_MD_SD_2) = nan;
    threshold_MD_SD_3 = sd*std(MD_ratio_3(~isnan(MD_ratio_3)));
    [pks_MD_3,locs_MD_3] = findpeaks(MD_ratio_3,'MinPeakDistance',1);
    locs_MD_SD_3 = locs_MD_3(pks_MD_3>threshold_MD_SD_3);
    pks_MD_SD_3 = MD_ratio(locs_MD_SD_3);

    eventCount_MD1 = length(locs_MD_SD);
    eventCount_MD2 = length(locs_MD_SD_2);
    eventCount_MD3 = length(locs_MD_SD_3);
    eventSum_MD =  length(locs_MD_SD) +  length(locs_MD_SD_2)+length(locs_MD_SD_3);

% analysis frequency, amplitude, AUC
    frequency_MD = eventSum_MD./(s/fs); % frequency in Hz
    amplitude_MD = mean([pks_MD_SD, pks_MD_SD_2, pks_MD_SD_3]); % averaged Ca2+ event peak values
    AUC_MD = sum(MD_ratio(MD_ratio>threshold_MD_SD_3)); % sum of everything above the 3rd threshold
    above_SD_MD = sum(MD_ratio>threshold_MD_SD_3)./s*100; % sum of datapoints above the 3rd threshold

    Output_overall_MD = [frequency_MD, amplitude_MD, AUC_MD, above_SD_MD];
    Output_thresholds_MD = [threshold_MD_SD,threshold_MD_SD_2,threshold_MD_SD_3];
    
    
%% relavent to NP peri-events

% generate matrix for NP events (for plot)
    eventNovel_seq = NaN(1, s);  % empty matrix for events
    eventOld_seq = NaN(1, s);  % empty matrix for events
    
    for ii = 1:size(eventNovel,1)
        eventNovel_seq(eventNovel(ii)-before:eventNovel(ii)+after) = 1;
    end
    for ii = 1:size(eventOld,1)
        eventOld_seq(eventOld(ii)-before:eventOld(ii)+after) = 1;
    end
    
% assign the calcium events to behavior events
% column 1 starting time point, column 2 ending time point
    
    % in case the event matrix is empty and prevent the program to run
    % through, these ariticial event array will help error reporting
    if isempty(eventNovel) == 1
        eventNovel = 50;
    end
    if isempty(eventOld) == 1
        eventOld = 100;
    end


    for ii =1:length(eventNovel)
        eventWindowNovel(ii,:) = [eventNovel(ii)-before :1: eventNovel(ii)+after]; 
    end

    for ii =1:length(eventOld)
        eventWindowOld(ii,:) = [eventOld(ii)-before :1: eventOld(ii)+after]; 
    end

  
%%  IC (Novel and Old)
    locs_IC_SD_sum = [locs_IC_SD, locs_IC_SD_2, locs_IC_SD_3]; 
    locs_IC_SD_sort = sort(locs_IC_SD_sum);  % ascend sorting all the locs of calcium events
  
    locs_IC_SD_Novel = locs_IC_SD_sort(ismember(locs_IC_SD_sort, eventWindowNovel)); % find NPR related events
    pks_IC_SD_Novel = IC_ratio(locs_IC_SD_Novel); % get amplitude of these NPR related calcium events
   
    locs_IC_SD_Old = locs_IC_SD_sort(ismember(locs_IC_SD_sort, eventWindowOld)); % find NPR related events
    pks_IC_SD_Old = IC_ratio(locs_IC_SD_Old); % get amplitude of these NPR related calcium events
    
% register Ca-NPR events to the empty matrix
    locs_IC_SD_Novel_seq = NaN(1, s);
    for ii = 1:size(locs_IC_SD_Novel,2)
        locs_IC_SD_Novel_seq(locs_IC_SD_Novel(ii)) = 1;
    end
        
% register Ca-NPR events to the empty matrix
    locs_IC_SD_Old_seq = NaN(1, s);
    for ii = 1:size(locs_IC_SD_Old,2)
        locs_IC_SD_Old_seq(locs_IC_SD_Old(ii)) = 1;
    end
    
% analysis Ca-NPR event peak amplitude and frequency

    % amplitude
    Output_IC_SD_pks = [pks_IC_SD_Novel, pks_IC_SD_Old];    % peak amplitude of all Ca-NPR in trials
    Output_IC_SD_pksmean = mean(Output_IC_SD_pks);      % averaged peak amplitude of all Ca-NPR
    Output_IC_SD_pksmean_Novel = mean(pks_IC_SD_Novel);      % averaged peak amplitude of  Ca-Novel
    Output_IC_SD_pksmean_Old = mean(pks_IC_SD_Old);      % averaged peak amplitude of all Ca-Old
    
    NPR_IC_locs = [locs_IC_SD_Novel,locs_IC_SD_Old];    % NPR related Ca events locs
    nonNPR_IC_locs = setdiff(locs_IC_SD_sum, NPR_IC_locs);   % non-NPR related Ca events locs
    Output_IC_SD_pksmean_nonevent = mean(IC_ratio(nonNPR_IC_locs)); % averaged peak amplitude of Ca-non-NPR
    
    % frequency 
    perievent_length_Novel =  length(eventNovel).*(before+after+1); % datapoints during novel events
    perievent_length_Old =  length(eventOld).*(before+after+1);  % datapoints during old events
    perievent_length = perievent_length_Novel +  perievent_length_Old; % total datapoints during all events
    
    Output_IC_SD_eventfreq_all = length(Output_IC_SD_pks)./(perievent_length./fs);   % frequency during all Ca-NPR
    Output_IC_SD_eventfreq_Novel = length(pks_IC_SD_Novel)./(perievent_length_Novel./fs);  % frequency during Ca-Novel
    Output_IC_SD_eventfreq_Old = length(pks_IC_SD_Old)./(perievent_length_Old./fs);     % frequency during Ca-Old
    
    nonNPR_IC_counts = eventSum_IC - (length(locs_IC_SD_Novel)+length(locs_IC_SD_Old)); % non-NPR related Ca events
    Output_IC_SD_nonevenfreq = nonNPR_IC_counts./(s-perievent_length);  % frequency during Ca-non-NPR
    
%% MD (Novel and Old MD)
    locs_MD_SD_sum = [locs_MD_SD, locs_MD_SD_2, locs_MD_SD_3]; 
    locs_MD_SD_sort = sort(locs_MD_SD_sum);  % ascend sorting all the locs of calcium events
  
    locs_MD_SD_Novel = locs_MD_SD_sort(ismember(locs_MD_SD_sort, eventWindowNovel)); % find NPR related events
    pks_MD_SD_Novel = MD_ratio(locs_MD_SD_Novel); % get amplitude of these NPR related calcium events
   
    locs_MD_SD_Old = locs_MD_SD_sort(ismember(locs_MD_SD_sort, eventWindowOld)); % find NPR related events
    pks_MD_SD_Old = MD_ratio(locs_MD_SD_Old); % get amplitude of these NPR related calcium events
    
% register Ca-NPR events to the empty matrix
    locs_MD_SD_Novel_seq = NaN(1, s);
    for ii = 1:size(locs_MD_SD_Novel,2)
        locs_MD_SD_Novel_seq(locs_MD_SD_Novel(ii)) = 1;
    end
        
% register Ca-NPR events to the empty matrix
    locs_MD_SD_Old_seq = NaN(1, s);
    for ii = 1:size(locs_MD_SD_Old,2)
        locs_MD_SD_Old_seq(locs_MD_SD_Old(ii)) = 1;
    end    
    
% analysis Ca-NPR event peak amplitude and frequency

    % amplitude
    Output_MD_SD_pks = [pks_MD_SD_Novel, pks_MD_SD_Old];    % peak amplitude of all Ca-NPR in trials
    Output_MD_SD_pksmean = mean(Output_MD_SD_pks);      % averaged peak amplitude of all Ca-NPR
    Output_MD_SD_pksmean_Novel = mean(pks_MD_SD_Novel);      % averaged peak amplitude of  Ca-Novel
    Output_MD_SD_pksmean_Old = mean(pks_MD_SD_Old);      % averaged peak amplitude of all Ca-Old
    
    NPR_MD_locs = [locs_MD_SD_Novel,locs_MD_SD_Old];    % NPR related Ca events locs
    nonNPR_MD_locs = setdiff(locs_MD_SD_sum, NPR_MD_locs);   % non-NPR related Ca events locs
    Output_MD_SD_pksmean_nonevent = mean(MD_ratio(nonNPR_MD_locs)); % averaged peak amplitude of Ca-non-NPR
    
    % frequency 
    perievent_length_Novel =  length(eventNovel).*(before+after+1); % datapoints during novel events
    perievent_length_Old =  length(eventOld).*(before+after+1);  % datapoints during old events
    perievent_length = perievent_length_Novel +  perievent_length_Old; % total datapoints during all events
    
    Output_MD_SD_eventfreq_all = length(Output_MD_SD_pks)./(perievent_length./fs);   % frequency during all Ca-NPR
    Output_MD_SD_eventfreq_Novel = length(pks_MD_SD_Novel)./(perievent_length_Novel./fs);  % frequency during Ca-Novel
    Output_MD_SD_eventfreq_Old = length(pks_MD_SD_Old)./(perievent_length_Old./fs);     % frequency during Ca-Old
    
    nonNPR_MD_counts = eventSum_MD - (length(locs_MD_SD_Novel)+length(locs_MD_SD_Old)); % non-NPR related Ca events
    Output_MD_SD_nonevenfreq = nonNPR_MD_counts./(s-perievent_length);  % frequency during Ca-non-NPR
    
%% plot NP events
    figure
    x0=100;
    y0=200;
    width=1200;
    height=300;
    set(gcf,'position',[x0,y0,width,height])   % set figure configurations    

% IC
    subplot(2,1,1)
% plot traces and detected calcium events
    plot (time,IC_ratio, time(locs_IC_SD), pks_IC_SD,'*r','MarkerSize', 3)
    hold on
    plot(time(locs_IC_SD_2),pks_IC_SD_2,'*m','MarkerSize', 3)
    plot(time(locs_IC_SD_3),pks_IC_SD_3,'*k','MarkerSize', 3)

% plot threshold lines
    threshold_IC_SD_seq = ones(1, s).*threshold_IC_SD;
    threshold_IC_SD_seq_2 = ones(1, s).*threshold_IC_SD_2;
    threshold_IC_SD_seq_3 = ones(1, s).*threshold_IC_SD_3;

    plot(time,threshold_IC_SD_seq,'LineWidth',1, 'Color', [1, 0, 0, 0.2])
    plot(time,threshold_IC_SD_seq_2,'LineWidth',1, 'Color', [1, 0, 1, 0.2])
    plot(time,threshold_IC_SD_seq_3,'LineWidth',1, 'Color', [0, 0, 0, 0.2])

% plot NP events
    plot(time,eventNovel_seq*max(IC_ratio)+2,'LineWidth',10,'Color', [0, 0, 1, 0.2])
    plot(time,eventOld_seq*max(IC_ratio)+2,'LineWidth',10, 'Color', [1, 0, 1, 0.2])
    area(time,locs_IC_SD_Novel_seq*max(IC_ratio)+2, 'EdgeColor', 'b')    
    area(time,locs_IC_SD_Old_seq*max(IC_ratio)+2, 'EdgeColor', 'm')   
    title(['IC NP' '    Events1=' num2str(length(locs_IC_SD)) '      Events2=' num2str(length(locs_IC_SD_2)) '      Events3=' num2str(length(locs_IC_SD_3))])
    xlabel('Time (mins)')
    ylabel('dF/F%')
    
    % MD
    subplot(2,1,2)
% plot traces and detected calcium events
    plot (time,MD_ratio, time(locs_MD_SD), pks_MD_SD,'*r','MarkerSize', 3)
    hold on
    plot(time(locs_MD_SD_2),pks_MD_SD_2,'*m','MarkerSize', 3)
    plot(time(locs_MD_SD_3),pks_MD_SD_3,'*k','MarkerSize', 3)

% plot threshold lines
    threshold_MD_SD_seq = ones(1, s).*threshold_MD_SD;
    threshold_MD_SD_seq_2 = ones(1, s).*threshold_MD_SD_2;
    threshold_MD_SD_seq_3 = ones(1, s).*threshold_MD_SD_3;

    plot(time,threshold_MD_SD_seq,'LineWidth',1, 'Color', [1, 0, 0, 0.2])
    plot(time,threshold_MD_SD_seq_2,'LineWidth',1, 'Color', [1, 0, 1, 0.2])
    plot(time,threshold_MD_SD_seq_3,'LineWidth',1, 'Color', [0, 0, 0, 0.2])

% plot NP events
    plot(time,eventNovel_seq*max(MD_ratio)+2,'LineWidth',10,'Color', [0, 0, 1, 0.2])
    plot(time,eventOld_seq*max(MD_ratio)+2,'LineWidth',10, 'Color', [1, 0, 1, 0.2])
    area(time,locs_MD_SD_Novel_seq*max(MD_ratio)+2, 'EdgeColor', 'b')    
    area(time,locs_MD_SD_Old_seq*max(MD_ratio)+2, 'EdgeColor', 'm')   
    title(['MD NP' '    Events1=' num2str(length(locs_MD_SD)) '      Events2=' num2str(length(locs_MD_SD_2)) '      Events3=' num2str(length(locs_MD_SD_3))])
    xlabel('Time (mins)')
    ylabel('dF/F%')
    
    saveas(gcf,fullfile(output_dir,'SD_Plots',[name '_SD_NP.png']))
    exportgraphics(gcf,fullfile(output_dir,'SD_Plots',[name '_SD_NP.pdf']),'ContentType','vector')

    close
    
%% save data and variables to the summarized file


% summarize all output variables
Output_IC_sum = [frequency_IC, amplitude_IC, AUC_IC, above_SD_IC,...
    threshold_IC_SD,threshold_IC_SD_2,threshold_IC_SD_3,...
    Output_IC_SD_pksmean, Output_IC_SD_pksmean_Novel, Output_IC_SD_pksmean_Old,...
    Output_IC_SD_pksmean_nonevent,...
    Output_IC_SD_eventfreq_all, Output_IC_SD_eventfreq_Novel, Output_IC_SD_eventfreq_Old,...
    Output_IC_SD_nonevenfreq];
header_IC_sum = {'frequency_IC', 'amplitude_IC', 'AUC_IC', 'above_SD_IC',...
    'threshold_IC_SD','threshold_IC_SD_2','threshold_IC_SD_3',...
    'Output_IC_SD_pksmean', 'Output_IC_SD_pksmean_Novel', 'Output_IC_SD_pksmean_Old',...
    'Output_IC_SD_pksmean_nonevent',...
    'Output_IC_SD_eventfreq_all', 'Output_IC_SD_eventfreq_Novel', 'Output_IC_SD_eventfreq_Old',...
    'Output_IC_SD_nonevenfreq'};

Output_MD_sum = [frequency_MD, amplitude_MD, AUC_MD, above_SD_MD,...
    threshold_MD_SD,threshold_MD_SD_2,threshold_MD_SD_3,...
    Output_MD_SD_pksmean, Output_MD_SD_pksmean_Novel, Output_MD_SD_pksmean_Old,...
    Output_MD_SD_pksmean_nonevent,...
    Output_MD_SD_eventfreq_all, Output_MD_SD_eventfreq_Novel, Output_MD_SD_eventfreq_Old,...
    Output_MD_SD_nonevenfreq];
header_MD_sum = {'frequency_MD', 'amplitude_MD', 'AUC_MD', 'above_SD_MD',...
    'threshold_MD_SD','threshold_MD_SD_2','threshold_MD_SD_3',...
    'Output_MD_SD_pksmean', 'Output_MD_SD_pksmean_Novel', 'Output_MD_SD_pksmean_Old',...
    'Output_MD_SD_pksmean_nonevent',...
    'Output_MD_SD_eventfreq_all', 'Output_MD_SD_eventfreq_Novel', 'Output_MD_SD_eventfreq_Old',...
    'Output_MD_SD_nonevenfreq'};

save(fullfile(output_dir,[name '_SDprocessed.mat']))

% Output_IC_sum = [header_IC_sum; num2cell(Output_IC_sum)];
% save(fullfile(path_folder,'output_IC.mat'),'Output_IC_sum')

end