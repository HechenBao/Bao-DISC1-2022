function [] = Rep_threshold_homecage_MDIC (IC_ratio, MD_ratio, fs, sd, name, output_dir)
% This function is to apply multiple threshold to the data, and get calcium

% IC_ratio, ROI1 data
% MD_ratio, ROI2 data
% fs, sampling frequency
% sd,  threshold further multiply by standard deviation
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
    
    

%% plot homecage traces
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

    title(['IC homecage' '    Events1=' num2str(length(locs_IC_SD)) '      Events2=' num2str(length(locs_IC_SD_2)) '      Events3=' num2str(length(locs_IC_SD_3))])
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

    title(['MD homecage' '    Events1=' num2str(length(locs_MD_SD)) '      Events2=' num2str(length(locs_MD_SD_2)) '      Events3=' num2str(length(locs_MD_SD_3))])
    xlabel('Time (mins)')
    ylabel('dF/F%')
    
    saveas(gcf,fullfile(output_dir,'SD_Plots',[name '_SD_homecage.png']))
    exportgraphics(gcf,fullfile(output_dir,'SD_Plots',[name '_SD_homecage.pdf']),'ContentType','vector')

    close
    
%% save data and variables to the summarized file


% summarize all output variables
Output_IC_sum = [frequency_IC, amplitude_IC, AUC_IC, above_SD_IC,...
    threshold_IC_SD,threshold_IC_SD_2,threshold_IC_SD_3];
header_IC_sum = {'frequency_IC', 'amplitude_IC', 'AUC_IC', 'above_SD_IC',...
    'threshold_IC_SD','threshold_IC_SD_2','threshold_IC_SD_3'};

Output_MD_sum = [frequency_MD, amplitude_MD, AUC_MD, above_SD_MD,...
    threshold_MD_SD,threshold_MD_SD_2,threshold_MD_SD_3];
header_MD_sum = {'frequency_MD', 'amplitude_MD', 'AUC_MD', 'above_SD_MD',...
    'threshold_MD_SD','threshold_MD_SD_2','threshold_MD_SD_3'};

save(fullfile(output_dir,[name '_SDprocessed.mat']))

% Output_IC_sum = [header_IC_sum; num2cell(Output_IC_sum)];
% save(fullfile(path_folder,'output_IC.mat'),'Output_IC_sum')

end