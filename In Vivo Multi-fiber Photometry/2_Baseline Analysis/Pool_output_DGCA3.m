function [] = Pool_output_DGCA3(path) % batch process function
% get subfolders for batch process
    Data = dir(fullfile(path,'*.mat')); % extract the names of all mat files
    
  for i = 1:length(Data)
        file = load([path,'/',Data(i).name],'-mat');
        Output_DG_sum(i,:) = file.Output_DG_sum;
        Output_CA3_sum(i,:) = file.Output_CA3_sum;
        header_DG = file.header_DG_sum;
        header_CA3 = file.header_CA3_sum;
  end
            
    Output_DG_sum = [header_DG; num2cell(Output_DG_sum)];
    Output_CA3_sum = [header_CA3; num2cell(Output_CA3_sum)];
    
save(fullfile(path,'Sum_Output','output_DG.mat'),'Output_DG_sum')
save(fullfile(path,'Sum_Output','output_CA3.mat'),'Output_CA3_sum')
