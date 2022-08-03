%% for hab
data = [];
data = [zscore_AM3_Old_IC;zscore_AM3_Novel_IC];
save('comb_AM3_hab_IC.mat','data')

data = [];
data = [zscore_AM3_Old_MD;zscore_AM3_Novel_MD];
save('comb_AM3_hab_MD.mat','data')

data = [];
data = [zscore_M3_Old_IC;zscore_M3_Novel_IC];
save('comb_M3_hab_IC.mat','data')

data = [];
data = [zscore_M3_Old_MD;zscore_M3_Novel_MD];
save('comb_M3_hab_MD.mat','data')

clear
%% for test
data = [];
data = [zscore_AM3_Old_IC;zscore_AM3_Novel_IC];
save('comb_AM3_test_IC.mat','data')

data = [];
data = [zscore_AM3_Old_MD;zscore_AM3_Novel_MD];
save('comb_AM3_test_MD.mat','data')

data = [];
data = [zscore_M3_Old_IC;zscore_M3_Novel_IC];
save('comb_M3_test_IC.mat','data')

data = [];
data = [zscore_M3_Old_MD;zscore_M3_Novel_MD];
save('comb_M3_test_MD.mat','data')

clear
%% for hab random
data = [];
data = [AM3_hab_zscore_rand_IC];
save('rand_AM3_hab_IC.mat','data')

data = [];
data = [AM3_hab_zscore_rand_MD];
save('rand_AM3_hab_MD.mat','data')

data = [];
data = [M3_hab_zscore_rand_IC];
save('rand_M3_hab_IC.mat','data')

data = [];
data = [M3_hab_zscore_rand_MD];
save('rand_M3_hab_MD.mat','data')

clear
%% for test random
data = [];
data = [AM3_test_zscore_rand_IC];
save('rand_AM3_test_IC.mat','data')

data = [];
data = [AM3_test_zscore_rand_MD];
save('rand_AM3_test_MD.mat','data')

data = [];
data = [M3_test_zscore_rand_IC];
save('rand_M3_test_IC.mat','data')

data = [];
data = [M3_test_zscore_rand_MD];
save('rand_M3_test_MD.mat','data')

clear
