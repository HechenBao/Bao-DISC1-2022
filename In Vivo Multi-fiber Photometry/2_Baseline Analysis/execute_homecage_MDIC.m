%% Execute batch process for the homecage data folder    
    clc

%% load data and input variables
    Data = dir('*.mat'); % extract the names of all mat files
    path_data = pwd; % get current folder path
       
    for i = 1:length(Data)
        file = load([path_data,'/',Data(i).name],'-mat');
        IC_ratio = file.IC_ratio;
        MD_ratio = file.MD_ratio;
        name = Data(i).name (1:end-4);   % name of the dataset
        
 %% set parameters for analysis
        fs = 10;
        
        % threshold further multiply by SD/  test sd=2, 2.5, 3     
        sd2 = 2; 
        sd25 = 2.5;    
        sd3 = 3;
        
        % set output directory
%         output_dir_2= ('D:\disc1_photometry_data\disc1_multi-fiber\Revision data\NewSD_analysis\MDIC\MDIC_3wpi_homecage\SD_Output\2SDprocessed');
%         output_dir_25= ('D:\disc1_photometry_data\disc1_multi-fiber\Revision data\NewSD_analysis\MDIC\MDIC_3wpi_homecage\SD_Output\25SDprocessed');
%         output_dir_3= ('D:\disc1_photometry_data\disc1_multi-fiber\Revision data\NewSD_analysis\MDIC\MDIC_3wpi_homecage\SD_Output\3SDprocessed');

        output_dir_2= ('D:\disc1_photometry_data\disc1_multi-fiber\Revision data\NewSD_analysis\MDIC\MDIC_6wpi_homecage\SD_Output\2SDprocessed');
        output_dir_25= ('D:\disc1_photometry_data\disc1_multi-fiber\Revision data\NewSD_analysis\MDIC\MDIC_6wpi_homecage\SD_Output\25SDprocessed');
        output_dir_3= ('D:\disc1_photometry_data\disc1_multi-fiber\Revision data\NewSD_analysis\MDIC\MDIC_6wpi_homecage\SD_Output\3SDprocessed');
 
        Rep_threshold_homecage_MDIC(IC_ratio, MD_ratio, fs, sd2, name, output_dir_2)
        Rep_threshold_homecage_MDIC(IC_ratio, MD_ratio, fs, sd25, name, output_dir_25)
        Rep_threshold_homecage_MDIC(IC_ratio, MD_ratio, fs, sd3, name, output_dir_3)
        
      
    end
    
    %% output variables
        Pool_output_MDIC(output_dir_2)
        Pool_output_MDIC(output_dir_25)
        Pool_output_MDIC(output_dir_3)
    