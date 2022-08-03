%v_ct=1:1:size(zscore_ct_DG,1);
%C_ct=nchoosek(v_ct,3);

for k=1:50
    r = randperm(size(zscore_ct_DG,1));
    r = r(1:round(size(zscore_ct_DG,1).*0.75));
for i=1:size(r,2)
    rand_ct_DG(i,:) = zscore_ct_DG(r(i),:);
    rand_ct_CA3(i,:) = zscore_ct_CA3(r(i),:);
end
    mean_rand_ct_DG(k,:)=mean(rand_ct_DG,1);
    mean_rand_ct_CA3(k,:)=mean(rand_ct_CA3,1);
    
    lags=[-4:0.1:4]';
    
    R_xcorr_ct(k,:)=xcorr(mean_rand_ct_DG(k,11:51),mean_rand_ct_CA3(k,11:51),'coeff');
    [R_ct(k,:),P_ct(k,:)]=corr(mean_rand_ct_DG(k,11:51)',mean_rand_ct_CA3(k,11:51)');
    [Peak_ct(k,:),MaxInd_ct(k,:)]= max(abs(R_xcorr_ct(k,:)));
end

for k=1:50
    r = randperm(size(zscore_disc1_DG,1));
    r = r(1:round(size(zscore_disc1_DG,1).*0.75));
for i=1:size(r,2)
    rand_disc1_DG(i,:) = zscore_disc1_DG(r(i),:);
    rand_disc1_CA3(i,:) = zscore_disc1_CA3(r(i),:);
end
    mean_rand_disc1_DG(k,:)=mean(rand_disc1_DG,1);
    mean_rand_disc1_CA3(k,:)=mean(rand_disc1_CA3,1);
    
    lags=[-4:0.1:4]';
    
    R_xcorr_disc1(k,:)=xcorr(mean_rand_disc1_DG(k,11:51),mean_rand_disc1_CA3(k,11:51),'coeff');
    [R_disc1(k,:),P_disc1(k,:)]=corr(mean_rand_disc1_DG(k,11:51)',mean_rand_disc1_CA3(k,11:51)');
    [Peak_disc1(k,:),MaxInd_disc1(k,:)]= max(abs(R_xcorr_disc1(k,:)));
end

%% output
output_mean_ct=[mean(mean_rand_ct_DG,1);mean(mean_rand_ct_CA3,1)];
output_mean_disc1=[mean(mean_rand_disc1_DG,1);mean(mean_rand_disc1_CA3,1)];

output_xcorr_ct=mean(R_xcorr_ct,1);
output_xcorr_disc1=mean(R_xcorr_disc1,1);

% figure;
% plot(output_mean_ct(1,:),'mag')
% hold on
% plot(output_mean_ct(2,:),'black')
% 
% figure;
% plot(output_mean_disc1(1,:),'mag')
% hold on
% plot(output_mean_disc1(2,:),'black')
% 
% 
% figure;
% plot(lags,output_xcorr_ct,'r')
% hold on
% plot(lags,output_xcorr_disc1,'b')

lags=[-4:0.1:4]';
figure;
h_peakInd_ct=histogram(lags(MaxInd_ct),'BinEdges',lags,'FaceColor','m');
hold on
h_peakInd_disc1=histogram(lags(MaxInd_disc1),'BinEdges',lags,'FaceColor','g');

figure;
correlation=[-1:0.1:1]';
h_peakInd_ct=histogram(R_ct,'BinEdges',correlation,'FaceColor','m');
hold on
h_peakInd_disc1=histogram(R_disc1,'BinEdges',correlation,'FaceColor','g');


%% export plot
figure;
x0=0;
y0=0;
width=1000;
height=1000;
set(gcf,'position',[x0,y0,width,height])

subplot(2,2,1)
pcolor(lags,[1:1:50],R_xcorr_ct)
shading flat;
caxis([-1 1])
xlim([-4 4])
xticks([-4:1:4])
yticks([0:25:50])
xlabel('Lags (sec)','FontSize',15,'FontWeight','bold')
ylabel('Shuffled trial combinations','FontSize',15,'FontWeight','bold')
title('Control xcorr')
set(gca, 'FontName', 'Arial','Fontsize',20,'linewidth',2)
%c = colorbar;
%c.Label.String = 'Normalized cross correlation coefficient';

subplot(2,2,2)
pcolor(lags,[1:1:50],R_xcorr_disc1)
shading flat;
caxis([-1 1])
xlim([-4 4])
xticks([-4:1:4])
yticks([0:25:50])
xlabel('Lags (sec)','FontSize',15,'FontWeight','bold')
%ylabel('Shuffled trial combinations','FontSize',15,'FontWeight','bold')
title('DISC1 xcorr')
set(gca, 'FontName', 'Arial','Fontsize',20,'linewidth',2)
%c = colorbar;
%c.Label.String = 'Normalized cross correlation coefficient';

subplot(2,2,3)
correlation=[-1:0.1:1]';
h_peakInd_ct=histogram(R_ct,'BinEdges',correlation,...
    'FaceColor','m','FaceAlpha',0.5,'EdgeColor','none');
hold on
h_peakInd_disc1=histogram(R_disc1,'BinEdges',correlation,...
    'FaceColor','g','FaceAlpha',0.5,'EdgeColor','none');
hold on
box off
xlim([-1 1])
xlabel('Correlation','FontSize',15,'FontWeight','bold')
ylabel('Probability','FontSize',15,'FontWeight','bold')
%title('Correlation coefficient at lag=0')
set(gca, 'FontName', 'Arial','Fontsize',20,'linewidth',2)

subplot(2,2,4)
h_peakInd_ct=histogram(lags(MaxInd_ct),'BinEdges',lags,...
    'FaceColor','m','FaceAlpha',0.5,'EdgeColor','none');
hold on
h_peakInd_disc1=histogram(lags(MaxInd_disc1),'BinEdges',lags,...
    'FaceColor','g','FaceAlpha',0.5,'EdgeColor','none');
hold on
box off
xlim([-4 4])
xlabel('Lags (sec)','FontSize',15,'FontWeight','bold')
ylabel('Probability','FontSize',15,'FontWeight','bold')
%title('Peak correlation coefficient')
set(gca, 'FontName', 'Arial','Fontsize',20,'linewidth',2)

saveas(gcf,'CA3DG-fam.tiff')
%saveas(gcf,'CA3DG-test.tiff')

figure;
caxis([-1 1])
c = colorbar;
c.Label.String = 'Normalized cross correlation coefficient';
set(gca, 'FontName', 'Arial','Fontsize',15)
saveas(gcf,'cs.tiff')

%%
%% export 3 subplots
figure;
x0=0;
y0=0;
width=300;
height=1500;
set(gcf,'position',[x0,y0,width,height])

subplot(3,1,1)
pcolor(lags,[1:1:50],R_xcorr_ct)
shading flat;
caxis([-1 1])
xlim([-4 4])
xticks([-4:2:4])
yticks([0:25:50])
%xlabel('Lags (sec)','FontSize',15,'FontWeight','bold')
%ylabel('Shuffled trial combinations','FontSize',15,'FontWeight','bold')
title('Control xcorr')
set(gca, 'FontName', 'Arial','Fontsize',20,'linewidth',2)
%c = colorbar;
%c.Label.String = 'Normalized cross correlation coefficient';

subplot(3,1,2)
pcolor(lags,[1:1:50],R_xcorr_disc1)
shading flat;
caxis([-1 1])
xlim([-4 4])
xticks([-4:2:4])
yticks([0:25:50])
%xlabel('Lags (sec)','FontSize',15,'FontWeight','bold')
%ylabel('Shuffled trial combinations','FontSize',15,'FontWeight','bold')
title('DISC1 xcorr')
set(gca, 'FontName', 'Arial','Fontsize',20,'linewidth',2)
%c = colorbar;
%c.Label.String = 'Normalized cross correlation coefficient';

subplot(3,1,3)
h_peakInd_ct=histogram(lags(MaxInd_ct),'Normalization','probability','BinEdges',lags,...
    'FaceColor','m','FaceAlpha',0.5,'EdgeColor','none');
hold on
h_peakInd_disc1=histogram(lags(MaxInd_disc1),'Normalization','probability','BinEdges',lags,...
    'FaceColor','g','FaceAlpha',0.5,'EdgeColor','none');
hold on
box off
xlim([-4 4])
xlabel('Lags (sec)','FontSize',15,'FontWeight','bold')
ylabel('Probability','FontSize',15,'FontWeight','bold')
%title('Peak correlation coefficient')
set(gca, 'FontName', 'Arial','Fontsize',20,'linewidth',2)

%saveas(gcf,'CA3DG-fam.tiff')
saveas(gcf,'CA3DG-test.tiff')

figure;
caxis([-1 1])
c = colorbar;
c.Label.String = 'Normalized cross correlation coefficient';
set(gca, 'FontName', 'Arial','Fontsize',15)
saveas(gcf,'cs.tiff')