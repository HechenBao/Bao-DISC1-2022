% event related change
% pre 0.5 sec, post 1 sec
%%    Parameter 1
%     x = data(:,(11:26));    % pre [-2,-0.5]
%     y = data(:,(26:41));    % event [-0.5,1]
%     z = data(:,(41:56));    %post [1, 2.5]]

diff_pair_zscore_ct_Old_DG=[mean(zscore_ct_Old_DG(:,11:26),2),mean(zscore_ct_Old_DG(:,26:41),2)];
diff_pair_zscore_ct_Novel_DG=[mean(zscore_ct_Novel_DG(:,11:26),2),mean(zscore_ct_Novel_DG(:,26:41),2)];
diff_pair_zscore_ct_Old_CA3=[mean(zscore_ct_Old_CA3(:,11:26),2),mean(zscore_ct_Old_CA3(:,26:41),2)];
diff_pair_zscore_ct_Novel_CA3=[mean(zscore_ct_Novel_CA3(:,11:26),2),mean(zscore_ct_Novel_CA3(:,26:41),2)];

diff_pair_zscore_disc1_Old_DG=[mean(zscore_disc1_Old_DG(:,11:26),2),mean(zscore_disc1_Old_DG(:,26:41),2)];
diff_pair_zscore_disc1_Novel_DG=[mean(zscore_disc1_Novel_DG(:,11:26),2),mean(zscore_disc1_Novel_DG(:,26:41),2)];
diff_pair_zscore_disc1_Old_CA3=[mean(zscore_disc1_Old_CA3(:,11:26),2),mean(zscore_disc1_Old_CA3(:,26:41),2)];
diff_pair_zscore_disc1_Novel_CA3=[mean(zscore_disc1_Novel_CA3(:,11:26),2),mean(zscore_disc1_Novel_CA3(:,26:41),2)];
