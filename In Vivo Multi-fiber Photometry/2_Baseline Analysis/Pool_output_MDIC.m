function [] = Pool_output_MDIC(path) % batch process function
% get subfolders for batch process
    Data = dir(fullfile(path,'*.mat')); % extract the names of all mat files
    
  for i = 1:length(Data)
        file = load([path,'/',Data(i).name],'-mat');
        Output_IC_sum(i,:) = file.Output_IC_sum;
        Output_MD_sum(i,:) = file.Output_MD_sum;
        header_IC = file.header_IC_sum;
        header_MD = file.header_MD_sum;
  end
            
    Output_IC_sum = [header_IC; num2cell(Output_IC_sum)];
    Output_MD_sum = [header_MD; num2cell(Output_MD_sum)];
    
save(fullfile(path,'Sum_Output','output_IC.mat'),'Output_IC_sum')
save(fullfile(path,'Sum_Output','output_MD.mat'),'Output_MD_sum')
