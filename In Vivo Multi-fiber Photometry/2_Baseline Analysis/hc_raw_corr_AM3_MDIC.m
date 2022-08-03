%MD-IC
[R_IC_MD(1,1),P_IC_MD(1,1)]=corr(AM3_A1_all(:,1),AM3_A1_all(:,2));
[R_IC_MD(2,1),P_IC_MD(2,1)]=corr(AM3_A2_all(:,1),AM3_A2_all(:,2));
[R_IC_MD(3,1),P_IC_MD(3,1)]=corr(AM3_A3_all(:,1),AM3_A3_all(:,2));

[R_IC_MD(4,1),P_IC_MD(4,1)]=corr(AM3_B1_all(:,1),AM3_B1_all(:,2));
[R_IC_MD(5,1),P_IC_MD(5,1)]=corr(AM3_B2_all(:,1),AM3_B2_all(:,2));
[R_IC_MD(6,1),P_IC_MD(6,1)]=corr(AM3_B3_all(:,1),AM3_B3_all(:,2));

[R_IC_MD(7,1),P_IC_MD(7,1)]=corr(AM3_C1_all(:,1),AM3_C1_all(:,2));
[R_IC_MD(8,1),P_IC_MD(8,1)]=corr(AM3_C2_all(:,1),AM3_C2_all(:,2));
[R_IC_MD(9,1),P_IC_MD(9,1)]=corr(AM3_C3_all(:,1),AM3_C3_all(:,2));
[R_IC_MD(10,1),P_IC_MD(10,1)]=corr(AM3_C4_all(:,1),AM3_C4_all(:,2));
[R_IC_MD(11,1),P_IC_MD(11,1)]=corr(AM3_C5_all(:,1),AM3_C5_all(:,2));

[R_IC_MD(12,1),P_IC_MD(12,1)]=corr(AM3_D1_all(:,1),AM3_D1_all(:,2));
[R_IC_MD(13,1),P_IC_MD(13,1)]=corr(AM3_D2_all(:,1),AM3_D2_all(:,2));
[R_IC_MD(14,1),P_IC_MD(14,1)]=corr(AM3_D3_all(:,1),AM3_D3_all(:,2));
[R_IC_MD(15,1),P_IC_MD(15,1)]=corr(AM3_D4_all(:,1),AM3_D4_all(:,2));
[R_IC_MD(16,1),P_IC_MD(16,1)]=corr(AM3_D5_all(:,1),AM3_D5_all(:,2));

%% xcorr
R_xcorr(1,:)=xcorr(MD_ratio(1,:),IC_ratio(1,:),'coeff');


