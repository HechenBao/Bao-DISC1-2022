function [] = Rep_threshold_NP_CA (CA1_ratio, CA3_ratio, fs, sd, before, after, eventNovel, eventOld, name, output_dir)
% This function is to apply multiple threshold to the data, and get calcium
% events associated with NPR events

% CA1_ratio, ROI1 data
% CA3_ratio, ROI2 data
% fs, sampling frequency
% sd,  threshold further multiply by standard deviation
% before, time window before NPR event
% after, time window after NPR event
% eventNovel, event of sniffing Novel object
% eventOld, event of sniffing Old object
% name, nameof the executed file
% output_dir, output directory for the processed data
    
%% General parameters

    s = size(CA1_ratio,2);   % length of the recording
    time = [1:1:s]./60./fs;  % convert to minute
        
%     export_path = path_data(1:end-5);       % export path
    
%% CA1 threshold analysis
   
% thresholding total recording session
% find peak raw data, thresholding at 2SD
    [pks_CA1,locs_CA1] = findpeaks(CA1_ratio,'MinPeakDistance',1);
    threshold_CA1_SD = sd*std(CA1_ratio);
    locs_CA1_SD = locs_CA1(pks_CA1>threshold_CA1_SD);
    pks_CA1_SD = CA1_ratio(locs_CA1_SD);

% exclude peaks from 1st round, and find peak for rest of the data, thresholding at 2SD
    CA1_ratio_2 = CA1_ratio;
    CA1_ratio_2 (CA1_ratio_2 > threshold_CA1_SD) = nan;
    threshold_CA1_SD_2 = sd*std(CA1_ratio_2(~isnan(CA1_ratio_2)));
    [pks_CA1_2,locs_CA1_2] = findpeaks(CA1_ratio_2,'MinPeakDistance',1);
    locs_CA1_SD_2 = locs_CA1_2(pks_CA1_2>threshold_CA1_SD_2);
    pks_CA1_SD_2 = CA1_ratio(locs_CA1_SD_2);

% exclude peaks from 1st, 2nd round, and find peak for rest of the data, thresholding at 2SD
    CA1_ratio_3 = CA1_ratio;
    CA1_ratio_3 (CA1_ratio_3 > threshold_CA1_SD_2) = nan;
    threshold_CA1_SD_3 = sd*std(CA1_ratio_3(~isnan(CA1_ratio_3)));
    [pks_CA1_3,locs_CA1_3] = findpeaks(CA1_ratio_3,'MinPeakDistance',1);
    locs_CA1_SD_3 = locs_CA1_3(pks_CA1_3>threshold_CA1_SD_3);
    pks_CA1_SD_3 = CA1_ratio(locs_CA1_SD_3);

    eventCount_CA11 = length(locs_CA1_SD);
    eventCount_CA12 = length(locs_CA1_SD_2);
    eventCount_CA13 = length(locs_CA1_SD_3);
    eventSum_CA1 =  length(locs_CA1_SD) +  length(locs_CA1_SD_2)+length(locs_CA1_SD_3);

% analysis frequency, amplitude, AUC
    frequency_CA1 = eventSum_CA1./(s/fs); % frequency in Hz
    amplitude_CA1 = mean([pks_CA1_SD, pks_CA1_SD_2, pks_CA1_SD_3]); % averaged Ca2+ event peak values
    AUC_CA1 = sum(CA1_ratio(CA1_ratio>threshold_CA1_SD_3)); % sum of everything above the 3rd threshold
    above_SD_CA1 = sum(CA1_ratio>threshold_CA1_SD_3)./s*100; % sum of datapoints above the 3rd threshold

    Output_overall_CA1 = [frequency_CA1, amplitude_CA1, AUC_CA1, above_SD_CA1];
    Output_thresholds_CA1 = [threshold_CA1_SD,threshold_CA1_SD_2,threshold_CA1_SD_3];
    
    
%% CA3 threshold analysis

% thresholding total recording session
% find peak raw data, thresholding at 2SD
    [pks_CA3,locs_CA3] = findpeaks(CA3_ratio,'MinPeakDistance',1);
    threshold_CA3_SD = sd*std(CA3_ratio);
    locs_CA3_SD = locs_CA3(pks_CA3>threshold_CA3_SD);
    pks_CA3_SD = CA3_ratio(locs_CA3_SD);

% exclude peaks from 1st round, and find peak for rest of the data, thresholding at 2SD
    CA3_ratio_2 = CA3_ratio;
    CA3_ratio_2 (CA3_ratio_2 > threshold_CA3_SD) = nan;
    threshold_CA3_SD_2 = sd*std(CA3_ratio_2(~isnan(CA3_ratio_2)));
    [pks_CA3_2,locs_CA3_2] = findpeaks(CA3_ratio_2,'MinPeakDistance',1);
    locs_CA3_SD_2 = locs_CA3_2(pks_CA3_2>threshold_CA3_SD_2);
    pks_CA3_SD_2 = CA3_ratio(locs_CA3_SD_2);

% exclude peaks from 1st, 2nd round, and find peak for rest of the data, thresholding at 2SD
    CA3_ratio_3 = CA3_ratio;
    CA3_ratio_3 (CA3_ratio_3 > threshold_CA3_SD_2) = nan;
    threshold_CA3_SD_3 = sd*std(CA3_ratio_3(~isnan(CA3_ratio_3)));
    [pks_CA3_3,locs_CA3_3] = findpeaks(CA3_ratio_3,'MinPeakDistance',1);
    locs_CA3_SD_3 = locs_CA3_3(pks_CA3_3>threshold_CA3_SD_3);
    pks_CA3_SD_3 = CA3_ratio(locs_CA3_SD_3);

    eventCount_CA31 = length(locs_CA3_SD);
    eventCount_CA32 = length(locs_CA3_SD_2);
    eventCount_CA33 = length(locs_CA3_SD_3);
    eventSum_CA3 =  length(locs_CA3_SD) +  length(locs_CA3_SD_2)+length(locs_CA3_SD_3);

% analysis frequency, amplitude, AUC
    frequency_CA3 = eventSum_CA3./(s/fs); % frequency in Hz
    amplitude_CA3 = mean([pks_CA3_SD, pks_CA3_SD_2, pks_CA3_SD_3]); % averaged Ca2+ event peak values
    AUC_CA3 = sum(CA3_ratio(CA3_ratio>threshold_CA3_SD_3)); % sum of everything above the 3rd threshold
    above_SD_CA3 = sum(CA3_ratio>threshold_CA3_SD_3)./s*100; % sum of datapoints above the 3rd threshold

    Output_overall_CA3 = [frequency_CA3, amplitude_CA3, AUC_CA3, above_SD_CA3];
    Output_thresholds_CA3 = [threshold_CA3_SD,threshold_CA3_SD_2,threshold_CA3_SD_3];
    
    
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
    for ii =1:length(eventNovel)
        eventWindowNovel(ii,:) = [eventNovel(ii)-before :1: eventNovel(ii)+after]; 
    end

    for ii =1:length(eventOld)
        eventWindowOld(ii,:) = [eventOld(ii)-before :1: eventOld(ii)+after]; 
    end

  
%%  CA1 (Novel and Old)
    locs_CA1_SD_sum = [locs_CA1_SD, locs_CA1_SD_2, locs_CA1_SD_3]; 
    locs_CA1_SD_sort = sort(locs_CA1_SD_sum);  % ascend sorting all the locs of calcium events
  
    locs_CA1_SD_Novel = locs_CA1_SD_sort(ismember(locs_CA1_SD_sort, eventWindowNovel)); % find NPR related events
    pks_CA1_SD_Novel = CA1_ratio(locs_CA1_SD_Novel); % get amplitude of these NPR related calcium events
   
    locs_CA1_SD_Old = locs_CA1_SD_sort(ismember(locs_CA1_SD_sort, eventWindowOld)); % find NPR related events
    pks_CA1_SD_Old = CA1_ratio(locs_CA1_SD_Old); % get amplitude of these NPR related calcium events
    
% register Ca-NPR events to the empty matrix
    locs_CA1_SD_Novel_seq = NaN(1, s);
    for ii = 1:size(locs_CA1_SD_Novel,2)
        locs_CA1_SD_Novel_seq(locs_CA1_SD_Novel(ii)) = 1;
    end
        
% register Ca-NPR events to the empty matrix
    locs_CA1_SD_Old_seq = NaN(1, s);
    for ii = 1:size(locs_CA1_SD_Old,2)
        locs_CA1_SD_Old_seq(locs_CA1_SD_Old(ii)) = 1;
    end
    
% analysis Ca-NPR event peak amplitude and frequency

    % amplitude
    Output_CA1_SD_pks = [pks_CA1_SD_Novel, pks_CA1_SD_Old];    % peak amplitude of all Ca-NPR in trials
    Output_CA1_SD_pksmean = mean(Output_CA1_SD_pks);      % averaged peak amplitude of all Ca-NPR
    Output_CA1_SD_pksmean_Novel = mean(pks_CA1_SD_Novel);      % averaged peak amplitude of  Ca-Novel
    Output_CA1_SD_pksmean_Old = mean(pks_CA1_SD_Old);      % averaged peak amplitude of all Ca-Old
    
    NPR_CA1_locs = [locs_CA1_SD_Novel,locs_CA1_SD_Old];    % NPR related Ca events locs
    nonNPR_CA1_locs = setdiff(locs_CA1_SD_sum, NPR_CA1_locs);   % non-NPR related Ca events locs
    Output_CA1_SD_pksmean_nonevent = mean(CA1_ratio(nonNPR_CA1_locs)); % averaged peak amplitude of Ca-non-NPR
    
    % frequency 
    perievent_length_Novel =  length(eventNovel).*(before+after+1); % datapoints during novel events
    perievent_length_Old =  length(eventOld).*(before+after+1);  % datapoints during old events
    perievent_length = perievent_length_Novel +  perievent_length_Old; % total datapoints during all events
    
    Output_CA1_SD_eventfreq_all = length(Output_CA1_SD_pks)./(perievent_length./fs);   % frequency during all Ca-NPR
    Output_CA1_SD_eventfreq_Novel = length(pks_CA1_SD_Novel)./(perievent_length_Novel./fs);  % frequency during Ca-Novel
    Output_CA1_SD_eventfreq_Old = length(pks_CA1_SD_Old)./(perievent_length_Old./fs);     % frequency during Ca-Old
    
    nonNPR_CA1_counts = eventSum_CA1 - (length(locs_CA1_SD_Novel)+length(locs_CA1_SD_Old)); % non-NPR related Ca events
    Output_CA1_SD_nonevenfreq = nonNPR_CA1_counts./(s-perievent_length);  % frequency during Ca-non-NPR
    
%% CA3 (Novel and Old CA3)
    locs_CA3_SD_sum = [locs_CA3_SD, locs_CA3_SD_2, locs_CA3_SD_3]; 
    locs_CA3_SD_sort = sort(locs_CA3_SD_sum);  % ascend sorting all the locs of calcium events
  
    locs_CA3_SD_Novel = locs_CA3_SD_sort(ismember(locs_CA3_SD_sort, eventWindowNovel)); % find NPR related events
    pks_CA3_SD_Novel = CA3_ratio(locs_CA3_SD_Novel); % get amplitude of these NPR related calcium events
   
    locs_CA3_SD_Old = locs_CA3_SD_sort(ismember(locs_CA3_SD_sort, eventWindowOld)); % find NPR related events
    pks_CA3_SD_Old = CA3_ratio(locs_CA3_SD_Old); % get amplitude of these NPR related calcium events
    
% register Ca-NPR events to the empty matrix
    locs_CA3_SD_Novel_seq = NaN(1, s);
    for ii = 1:size(locs_CA3_SD_Novel,2)
        locs_CA3_SD_Novel_seq(locs_CA3_SD_Novel(ii)) = 1;
    end
        
% register Ca-NPR events to the empty matrix
    locs_CA3_SD_Old_seq = NaN(1, s);
    for ii = 1:size(locs_CA3_SD_Old,2)
        locs_CA3_SD_Old_seq(locs_CA3_SD_Old(ii)) = 1;
    end    
    
% analysis Ca-NPR event peak amplitude and frequency

    % amplitude
    Output_CA3_SD_pks = [pks_CA3_SD_Novel, pks_CA3_SD_Old];    % peak amplitude of all Ca-NPR in trials
    Output_CA3_SD_pksmean = mean(Output_CA3_SD_pks);      % averaged peak amplitude of all Ca-NPR
    Output_CA3_SD_pksmean_Novel = mean(pks_CA3_SD_Novel);      % averaged peak amplitude of  Ca-Novel
    Output_CA3_SD_pksmean_Old = mean(pks_CA3_SD_Old);      % averaged peak amplitude of all Ca-Old
    
    NPR_CA3_locs = [locs_CA3_SD_Novel,locs_CA3_SD_Old];    % NPR related Ca events locs
    nonNPR_CA3_locs = setdiff(locs_CA3_SD_sum, NPR_CA3_locs);   % non-NPR related Ca events locs
    Output_CA3_SD_pksmean_nonevent = mean(CA3_ratio(nonNPR_CA3_locs)); % averaged peak amplitude of Ca-non-NPR
    
    % frequency 
    perievent_length_Novel =  length(eventNovel).*(before+after+1); % datapoints during novel events
    perievent_length_Old =  length(eventOld).*(before+after+1);  % datapoints during old events
    perievent_length = perievent_length_Novel +  perievent_length_Old; % total datapoints during all events
    
    Output_CA3_SD_eventfreq_all = length(Output_CA3_SD_pks)./(perievent_length./fs);   % frequency during all Ca-NPR
    Output_CA3_SD_eventfreq_Novel = length(pks_CA3_SD_Novel)./(perievent_length_Novel./fs);  % frequency during Ca-Novel
    Output_CA3_SD_eventfreq_Old = length(pks_CA3_SD_Old)./(perievent_length_Old./fs);     % frequency during Ca-Old
    
    nonNPR_CA3_counts = eventSum_CA3 - (length(locs_CA3_SD_Novel)+length(locs_CA3_SD_Old)); % non-NPR related Ca events
    Output_CA3_SD_nonevenfreq = nonNPR_CA3_counts./(s-perievent_length);  % frequency during Ca-non-NPR
    
%% plot NP events
    figure
    x0=100;
    y0=200;
    width=1200;
    height=300;
    set(gcf,'position',[x0,y0,width,height])   % set figure configurations    

% CA1
    subplot(2,1,1)
% plot traces and detected calcium events
    plot (time,CA1_ratio, time(locs_CA1_SD), pks_CA1_SD,'*r','MarkerSize', 3)
    hold on
    plot(time(locs_CA1_SD_2),pks_CA1_SD_2,'*m','MarkerSize', 3)
    plot(time(locs_CA1_SD_3),pks_CA1_SD_3,'*k','MarkerSize', 3)

% plot threshold lines
    threshold_CA1_SD_seq = ones(1, s).*threshold_CA1_SD;
    threshold_CA1_SD_seq_2 = ones(1, s).*threshold_CA1_SD_2;
    threshold_CA1_SD_seq_3 = ones(1, s).*threshold_CA1_SD_3;

    plot(time,threshold_CA1_SD_seq,'LineWidth',1, 'Color', [1, 0, 0, 0.2])
    plot(time,threshold_CA1_SD_seq_2,'LineWidth',1, 'Color', [1, 0, 1, 0.2])
    plot(time,threshold_CA1_SD_seq_3,'LineWidth',1, 'Color', [0, 0, 0, 0.2])

% plot NP events
    plot(time,eventNovel_seq*max(CA1_ratio)+2,'LineWidth',10,'Color', [0, 0, 1, 0.2])
    plot(time,eventOld_seq*max(CA1_ratio)+2,'LineWidth',10, 'Color', [1, 0, 1, 0.2])
    area(time,locs_CA1_SD_Novel_seq*max(CA1_ratio)+2, 'EdgeColor', 'b')    
    area(time,locs_CA1_SD_Old_seq*max(CA1_ratio)+2, 'EdgeColor', 'm')   
    title(['CA1 NP' '    Events1=' num2str(length(locs_CA1_SD)) '      Events2=' num2str(length(locs_CA1_SD_2)) '      Events3=' num2str(length(locs_CA1_SD_3))])
    xlabel('Time (mins)')
    ylabel('dF/F%')
    
    % CA3
    subplot(2,1,2)
% plot traces and detected calcium events
    plot (time,CA3_ratio, time(locs_CA3_SD), pks_CA3_SD,'*r','MarkerSize', 3)
    hold on
    plot(time(locs_CA3_SD_2),pks_CA3_SD_2,'*m','MarkerSize', 3)
    plot(time(locs_CA3_SD_3),pks_CA3_SD_3,'*k','MarkerSize', 3)

% plot threshold lines
    threshold_CA3_SD_seq = ones(1, s).*threshold_CA3_SD;
    threshold_CA3_SD_seq_2 = ones(1, s).*threshold_CA3_SD_2;
    threshold_CA3_SD_seq_3 = ones(1, s).*threshold_CA3_SD_3;

    plot(time,threshold_CA3_SD_seq,'LineWidth',1, 'Color', [1, 0, 0, 0.2])
    plot(time,threshold_CA3_SD_seq_2,'LineWidth',1, 'Color', [1, 0, 1, 0.2])
    plot(time,threshold_CA3_SD_seq_3,'LineWidth',1, 'Color', [0, 0, 0, 0.2])

% plot NP events
    plot(time,eventNovel_seq*max(CA3_ratio)+2,'LineWidth',10,'Color', [0, 0, 1, 0.2])
    plot(time,eventOld_seq*max(CA3_ratio)+2,'LineWidth',10, 'Color', [1, 0, 1, 0.2])
    area(time,locs_CA3_SD_Novel_seq*max(CA3_ratio)+2, 'EdgeColor', 'b')    
    area(time,locs_CA3_SD_Old_seq*max(CA3_ratio)+2, 'EdgeColor', 'm')   
    title(['CA3 NP' '    Events1=' num2str(length(locs_CA3_SD)) '      Events2=' num2str(length(locs_CA3_SD_2)) '      Events3=' num2str(length(locs_CA3_SD_3))])
    xlabel('Time (mins)')
    ylabel('dF/F%')
    
    saveas(gcf,fullfile(output_dir,'SD_Plots',[name '_SD_NP.png']))
    exportgraphics(gcf,fullfile(output_dir,'SD_Plots',[name '_SD_NP.pdf']),'ContentType','vector')

    close
    
%% save data and variables to the summarized file


% summarize all output variables
Output_CA1_sum = [frequency_CA1, amplitude_CA1, AUC_CA1, above_SD_CA1,...
    threshold_CA1_SD,threshold_CA1_SD_2,threshold_CA1_SD_3,...
    Output_CA1_SD_pksmean, Output_CA1_SD_pksmean_Novel, Output_CA1_SD_pksmean_Old,...
    Output_CA1_SD_pksmean_nonevent,...
    Output_CA1_SD_eventfreq_all, Output_CA1_SD_eventfreq_Novel, Output_CA1_SD_eventfreq_Old,...
    Output_CA1_SD_nonevenfreq];
header_CA1_sum = {'frequency_CA1', 'amplitude_CA1', 'AUC_CA1', 'above_SD_CA1',...
    'threshold_CA1_SD','threshold_CA1_SD_2','threshold_CA1_SD_3',...
    'Output_CA1_SD_pksmean', 'Output_CA1_SD_pksmean_Novel', 'Output_CA1_SD_pksmean_Old',...
    'Output_CA1_SD_pksmean_nonevent',...
    'Output_CA1_SD_eventfreq_all', 'Output_CA1_SD_eventfreq_Novel', 'Output_CA1_SD_eventfreq_Old',...
    'Output_CA1_SD_nonevenfreq'};

Output_CA3_sum = [frequency_CA3, amplitude_CA3, AUC_CA3, above_SD_CA3,...
    threshold_CA3_SD,threshold_CA3_SD_2,threshold_CA3_SD_3,...
    Output_CA3_SD_pksmean, Output_CA3_SD_pksmean_Novel, Output_CA3_SD_pksmean_Old,...
    Output_CA3_SD_pksmean_nonevent,...
    Output_CA3_SD_eventfreq_all, Output_CA3_SD_eventfreq_Novel, Output_CA3_SD_eventfreq_Old,...
    Output_CA3_SD_nonevenfreq];
header_CA3_sum = {'frequency_CA3', 'amplitude_CA3', 'AUC_CA3', 'above_SD_CA3',...
    'threshold_CA3_SD','threshold_CA3_SD_2','threshold_CA3_SD_3',...
    'Output_CA3_SD_pksmean', 'Output_CA3_SD_pksmean_Novel', 'Output_CA3_SD_pksmean_Old',...
    'Output_CA3_SD_pksmean_nonevent',...
    'Output_CA3_SD_eventfreq_all', 'Output_CA3_SD_eventfreq_Novel', 'Output_CA3_SD_eventfreq_Old',...
    'Output_CA3_SD_nonevenfreq'};

save(fullfile(output_dir,[name '_SDprocessed.mat']))

% Output_CA1_sum = [header_CA1_sum; num2cell(Output_CA1_sum)];
% save(fullfile(path_folder,'output_CA1.mat'),'Output_CA1_sum')

end