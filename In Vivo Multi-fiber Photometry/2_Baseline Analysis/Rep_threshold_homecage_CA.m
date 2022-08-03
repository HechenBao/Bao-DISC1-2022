function [] = Rep_threshold_homecage_CA (CA1_ratio, CA3_ratio, fs, sd, name, output_dir)
% This function is to apply multiple threshold to the data, and get calcium
% events associated with homecage behavior

% CA1_ratio, ROI1 data
% CA3_ratio, ROI2 data
% fs, sampling frequency
% sd,  threshold further multiply by standard deviation
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
    
    

%% plot homecage traces
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

    title(['CA1 homecage' '    Events1=' num2str(length(locs_CA1_SD)) '      Events2=' num2str(length(locs_CA1_SD_2)) '      Events3=' num2str(length(locs_CA1_SD_3))])
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

    title(['CA3 homecage' '    Events1=' num2str(length(locs_CA3_SD)) '      Events2=' num2str(length(locs_CA3_SD_2)) '      Events3=' num2str(length(locs_CA3_SD_3))])
    xlabel('Time (mins)')
    ylabel('dF/F%')
    
    saveas(gcf,fullfile(output_dir,'SD_Plots',[name '_SD_homecage.png']))
    exportgraphics(gcf,fullfile(output_dir,'SD_Plots',[name '_SD_homecage.pdf']),'ContentType','vector')

    close
    
%% save data and variables to the summarized file


% summarize all output variables
Output_CA1_sum = [frequency_CA1, amplitude_CA1, AUC_CA1, above_SD_CA1,...
    threshold_CA1_SD,threshold_CA1_SD_2,threshold_CA1_SD_3];
header_CA1_sum = {'frequency_CA1', 'amplitude_CA1', 'AUC_CA1', 'above_SD_CA1',...
    'threshold_CA1_SD','threshold_CA1_SD_2','threshold_CA1_SD_3'};

Output_CA3_sum = [frequency_CA3, amplitude_CA3, AUC_CA3, above_SD_CA3,...
    threshold_CA3_SD,threshold_CA3_SD_2,threshold_CA3_SD_3];
header_CA3_sum = {'frequency_CA3', 'amplitude_CA3', 'AUC_CA3', 'above_SD_CA3',...
    'threshold_CA3_SD','threshold_CA3_SD_2','threshold_CA3_SD_3'};

save(fullfile(output_dir,[name '_SDprocessed.mat']))

% Output_CA1_sum = [header_CA1_sum; num2cell(Output_CA1_sum)];
% save(fullfile(path_folder,'output_CA1.mat'),'Output_CA1_sum')

end
