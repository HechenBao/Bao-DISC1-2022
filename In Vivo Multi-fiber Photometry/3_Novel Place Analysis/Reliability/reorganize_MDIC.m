%% for hab
data = [];
data = [zscore_ct_Old_IC;zscore_ct_Novel_IC];
save('comb_ct_hab_IC.mat','data')

data = [];
data = [zscore_ct_Old_MD;zscore_ct_Novel_MD];
save('comb_ct_hab_MD.mat','data')

data = [];
data = [zscore_disc1_Old_IC;zscore_disc1_Novel_IC];
save('comb_disc1_hab_IC.mat','data')

data = [];
data = [zscore_disc1_Old_MD;zscore_disc1_Novel_MD];
save('comb_disc1_hab_MD.mat','data')

clear
%% for test
data = [];
data = [zscore_ct_Old_IC;zscore_ct_Novel_IC];
save('comb_ct_test_IC.mat','data')

data = [];
data = [zscore_ct_Old_MD;zscore_ct_Novel_MD];
save('comb_ct_test_MD.mat','data')

data = [];
data = [zscore_disc1_Old_IC;zscore_disc1_Novel_IC];
save('comb_disc1_test_IC.mat','data')

data = [];
data = [zscore_disc1_Old_MD;zscore_disc1_Novel_MD];
save('comb_disc1_test_MD.mat','data')

clear
%% for hab random
data = [];
data = [ct_hab_zscore_rand_IC];
save('rand_ct_hab_IC.mat','data')

data = [];
data = [ct_hab_zscore_rand_MD];
save('rand_ct_hab_MD.mat','data')

data = [];
data = [disc1_hab_zscore_rand_IC];
save('rand_disc1_hab_IC.mat','data')

data = [];
data = [disc1_hab_zscore_rand_MD];
save('rand_disc1_hab_MD.mat','data')

clear
%% for test random
data = [];
data = [ct_test_zscore_rand_IC];
save('rand_ct_test_IC.mat','data')

data = [];
data = [ct_test_zscore_rand_MD];
save('rand_ct_test_MD.mat','data')

data = [];
data = [disc1_test_zscore_rand_IC];
save('rand_disc1_test_IC.mat','data')

data = [];
data = [disc1_test_zscore_rand_MD];
save('rand_disc1_test_MD.mat','data')

clear
