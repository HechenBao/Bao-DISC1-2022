function [] = Pool_output_CA(path) % batch process function
% get subfolders for batch process
    Data = dir(fullfile(path,'*.mat')); % extract the names of all mat files
    
  for i = 1:length(Data)
        file = load([path,'/',Data(i).name],'-mat');
        Output_CA1_sum(i,:) = file.Output_CA1_sum;
        Output_CA3_sum(i,:) = file.Output_CA3_sum;
        header_CA1 = file.header_CA1_sum;
        header_CA3 = file.header_CA3_sum;
  end
            
    Output_CA1_sum = [header_CA1; num2cell(Output_CA1_sum)];
    Output_CA3_sum = [header_CA3; num2cell(Output_CA3_sum)];
    
save(fullfile(path,'Sum_Output','output_CA1.mat'),'Output_CA1_sum')
save(fullfile(path,'Sum_Output','output_CA3.mat'),'Output_CA3_sum')
