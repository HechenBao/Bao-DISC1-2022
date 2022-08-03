%% for hab
data = [];
data = [zscore_ct_Old_CA1;zscore_ct_Novel_CA1];
save('comb_ct_hab_CA1.mat','data')

data = [];
data = [zscore_ct_Old_CA3;zscore_ct_Novel_CA3];
save('comb_ct_hab_CA3.mat','data')

data = [];
data = [zscore_disc1_Old_CA1;zscore_disc1_Novel_CA1];
save('comb_disc1_hab_CA1.mat','data')

data = [];
data = [zscore_disc1_Old_CA3;zscore_disc1_Novel_CA3];
save('comb_disc1_hab_CA3.mat','data')

clear
%% for test
data = [];
data = [zscore_ct_Old_CA1;zscore_ct_Novel_CA1];
save('comb_ct_test_CA1.mat','data')

data = [];
data = [zscore_ct_Old_CA3;zscore_ct_Novel_CA3];
save('comb_ct_test_CA3.mat','data')

data = [];
data = [zscore_disc1_Old_CA1;zscore_disc1_Novel_CA1];
save('comb_disc1_test_CA1.mat','data')

data = [];
data = [zscore_disc1_Old_CA3;zscore_disc1_Novel_CA3];
save('comb_disc1_test_CA3.mat','data')

clear
%% for hab random
data = [];
data = [ct_hab_zscore_rand_CA1];
save('rand_ct_hab_CA1.mat','data')

data = [];
data = [ct_hab_zscore_rand_CA3];
save('rand_ct_hab_CA3.mat','data')

data = [];
data = [disc1_hab_zscore_rand_CA1];
save('rand_disc1_hab_CA1.mat','data')

data = [];
data = [disc1_hab_zscore_rand_CA3];
save('rand_disc1_hab_CA3.mat','data')

clear
%% for test random
data = [];
data = [ct_test_zscore_rand_CA1];
save('rand_ct_test_CA1.mat','data')

data = [];
data = [ct_test_zscore_rand_CA3];
save('rand_ct_test_CA3.mat','data')

data = [];
data = [disc1_test_zscore_rand_CA1];
save('rand_disc1_test_CA1.mat','data')

data = [];
data = [disc1_test_zscore_rand_CA3];
save('rand_disc1_test_CA3.mat','data')

clear
