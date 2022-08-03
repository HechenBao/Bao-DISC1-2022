% event related change
% pre 0.5 sec, post 1 sec
%%    Parameter 1
%     x = data(:,(11:26));    % pre [-2,-0.5]
%     y = data(:,(26:41));    % event [-0.5,1]
%     z = data(:,(41:56));    %post [1, 2.5]]

diff_pair_zscore_ct_Old_CA1=[mean(zscore_ct_Old_CA1(:,26:30),2),mean(zscore_ct_Old_CA1(:,31:41),2)];
diff_pair_zscore_ct_Novel_CA1=[mean(zscore_ct_Novel_CA1(:,26:30),2),mean(zscore_ct_Novel_CA1(:,31:41),2)];
diff_pair_zscore_ct_Old_CA3=[mean(zscore_ct_Old_CA3(:,26:30),2),mean(zscore_ct_Old_CA3(:,31:41),2)];
diff_pair_zscore_ct_Novel_CA3=[mean(zscore_ct_Novel_CA3(:,26:30),2),mean(zscore_ct_Novel_CA3(:,31:41),2)];

diff_pair_zscore_disc1_Old_CA1=[mean(zscore_disc1_Old_CA1(:,26:30),2),mean(zscore_disc1_Old_CA1(:,31:41),2)];
diff_pair_zscore_disc1_Novel_CA1=[mean(zscore_disc1_Novel_CA1(:,26:30),2),mean(zscore_disc1_Novel_CA1(:,31:41),2)];
diff_pair_zscore_disc1_Old_CA3=[mean(zscore_disc1_Old_CA3(:,26:30),2),mean(zscore_disc1_Old_CA3(:,31:41),2)];
diff_pair_zscore_disc1_Novel_CA3=[mean(zscore_disc1_Novel_CA3(:,26:30),2),mean(zscore_disc1_Novel_CA3(:,31:41),2)];

