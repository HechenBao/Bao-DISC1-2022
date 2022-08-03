%% Execute batch process for the homecage data folder    
    clc

%% load data and input variables
    Data = dir('*.mat'); % extract the names of all mat files
    path_data = pwd; % get current folder path
       
    for i = 1:length(Data)
        file = load([path_data,'/',Data(i).name],'-mat');
        stitch_ratio = file.stitch_ratio;
        pre_length = size(file.pre_coef,2);
        post_length = size(file.post_coef,2);
        
        % to make sure the length of both session are the same (some dataset has longer post sessions, eg. AM3)
        if post_length >= pre_length
            post_length = pre_length;
        else
            post_length = post_length;
        end
                
        pre = 1:pre_length; 
        post = (pre_length+1):(pre_length+post_length);
        name = Data(i).name (1:end-4);   % name of the dataset
        
 %% set parameters for analysis
        fs = 10;
        
        % threshold further multiply by SD/  test sd=2, 2.5, 3     
        sd2 = 2; 
        sd25 = 2.5;    
        sd3 = 3;
        
        % set output directory
        % IC directory
%         output_dir_2= ('D:\disc1_photometry_data\disc1_multi-fiber\Revision data\NewSD_analysis\M4\M4_homecage\IC\SD_Output\2SDprocessed');
%         output_dir_25= ('D:\disc1_photometry_data\disc1_multi-fiber\Revision data\NewSD_analysis\M4\M4_homecage\IC\SD_Output\25SDprocessed');
%         output_dir_3= ('D:\disc1_photometry_data\disc1_multi-fiber\Revision data\NewSD_analysis\M4\M4_homecage\IC\SD_Output\3SDprocessed');
%         
        % MD directory
%         output_dir_2= ('D:\disc1_photometry_data\disc1_multi-fiber\Revision data\NewSD_analysis\M4\M4_homecage\MD\SD_Output\2SDprocessed');
%         output_dir_25= ('D:\disc1_photometry_data\disc1_multi-fiber\Revision data\NewSD_analysis\M4\M4_homecage\MD\SD_Output\25SDprocessed');
%         output_dir_3= ('D:\disc1_photometry_data\disc1_multi-fiber\Revision data\NewSD_analysis\M4\M4_homecage\MD\SD_Output\3SDprocessed');
%         
%         
        Rep_threshold_homecage_prepostCNO(stitch_ratio, pre, post, fs, sd2, name, output_dir_2)
        Rep_threshold_homecage_prepostCNO(stitch_ratio, pre, post, fs, sd25, name, output_dir_25)
        Rep_threshold_homecage_prepostCNO(stitch_ratio, pre, post, fs, sd3, name, output_dir_3)
        
      
    end
    
    %% output variables
        Pool_output_prepostCNO(output_dir_2)
        Pool_output_prepostCNO(output_dir_25)
        Pool_output_prepostCNO(output_dir_3)
    