%% for hab
data = [];
data = [zscore_veh_Old_IC;zscore_veh_Novel_IC];
save('comb_veh_hab_IC.mat','data')

data = [];
data = [zscore_veh_Old_MD;zscore_veh_Novel_MD];
save('comb_veh_hab_MD.mat','data')

data = [];
data = [zscore_CNO_Old_IC;zscore_CNO_Novel_IC];
save('comb_CNO_hab_IC.mat','data')

data = [];
data = [zscore_CNO_Old_MD;zscore_CNO_Novel_MD];
save('comb_CNO_hab_MD.mat','data')

clear
%% for test
data = [];
data = [zscore_veh_Old_IC;zscore_veh_Novel_IC];
save('comb_veh_test_IC.mat','data')

data = [];
data = [zscore_veh_Old_MD;zscore_veh_Novel_MD];
save('comb_veh_test_MD.mat','data')

data = [];
data = [zscore_CNO_Old_IC;zscore_CNO_Novel_IC];
save('comb_CNO_test_IC.mat','data')

data = [];
data = [zscore_CNO_Old_MD;zscore_CNO_Novel_MD];
save('comb_CNO_test_MD.mat','data')

clear
%% for hab random
data = [];
data = [veh_hab_zscore_rand_IC];
save('rand_veh_hab_IC.mat','data')

data = [];
data = [veh_hab_zscore_rand_MD];
save('rand_veh_hab_MD.mat','data')

data = [];
data = [CNO_hab_zscore_rand_IC];
save('rand_CNO_hab_IC.mat','data')

data = [];
data = [CNO_hab_zscore_rand_MD];
save('rand_CNO_hab_MD.mat','data')

clear
%% for test random
data = [];
data = [veh_test_zscore_rand_IC];
save('rand_veh_test_IC.mat','data')

data = [];
data = [veh_test_zscore_rand_MD];
save('rand_veh_test_MD.mat','data')

data = [];
data = [CNO_test_zscore_rand_IC];
save('rand_CNO_test_IC.mat','data')

data = [];
data = [CNO_test_zscore_rand_MD];
save('rand_CNO_test_MD.mat','data')

clear
