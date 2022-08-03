%v_M3=1:1:size(zscore_M3_IC,1);
%C_M3=nchoosek(v_M3,3);

for k=1:50
    r = randperm(size(zscore_M3_IC,1));
    r = r(1:round(size(zscore_M3_IC,1).*0.75));
for i=1:size(r,2)
    rand_M3_IC(i,:) = zscore_M3_IC(r(i),:);
    rand_M3_MD(i,:) = zscore_M3_MD(r(i),:);
end
    mean_rand_M3_IC(k,:)=mean(rand_M3_IC,1);
    mean_rand_M3_MD(k,:)=mean(rand_M3_MD,1);
    
    lags=[-4:0.1:4]';
    
    R_xcorr_M3(k,:)=xcorr(mean_rand_M3_MD(k,11:51),mean_rand_M3_IC(k,11:51),'coeff');
    [R_M3(k,:),P_M3(k,:)]=corr(mean_rand_M3_MD(k,11:51)',mean_rand_M3_IC(k,11:51)');
    [Peak_M3(k,:),MaxInd_M3(k,:)]= max(abs(R_xcorr_M3(k,:)));
end

for k=1:50
    r = randperm(size(zscore_AM3_IC,1));
    r = r(1:round(size(zscore_AM3_IC,1).*0.75));
for i=1:size(r,2)
    rand_AM3_IC(i,:) = zscore_AM3_IC(r(i),:);
    rand_AM3_MD(i,:) = zscore_AM3_MD(r(i),:);
end
    mean_rand_AM3_IC(k,:)=mean(rand_AM3_IC,1);
    mean_rand_AM3_MD(k,:)=mean(rand_AM3_MD,1);
    
    lags=[-4:0.1:4]';
    
    R_xcorr_AM3(k,:)=xcorr(mean_rand_AM3_MD(k,11:51),mean_rand_AM3_IC(k,11:51),'coeff');
    [R_AM3(k,:),P_AM3(k,:)]=corr(mean_rand_AM3_MD(k,11:51)',mean_rand_AM3_IC(k,11:51)');
    [Peak_AM3(k,:),MaxInd_AM3(k,:)]= max(abs(R_xcorr_AM3(k,:)));
end

%% output
output_mean_M3=[mean(mean_rand_M3_IC,1);mean(mean_rand_M3_MD,1)];
output_mean_AM3=[mean(mean_rand_AM3_IC,1);mean(mean_rand_AM3_MD,1)];

output_xcorr_M3=mean(R_xcorr_M3,1);
output_xcorr_AM3=mean(R_xcorr_AM3,1);

% figure;
% plot(output_mean_M3(1,:),'mag')
% hold on
% plot(output_mean_M3(2,:),'black')
% 
% figure;
% plot(output_mean_AM3(1,:),'mag')
% hold on
% plot(output_mean_AM3(2,:),'black')
% 
% 
% figure;
% plot(lags,output_xcorr_M3,'r')
% hold on
% plot(lags,output_xcorr_AM3,'b')

lags=[-4:0.1:4]';
figure;
h_peakInd_M3=histogram(lags(MaxInd_M3),'BinEdges',lags,'FaceColor','m');
hold on
h_peakInd_AM3=histogram(lags(MaxInd_AM3),'BinEdges',lags,'FaceColor','g');

figure;
correlation=[-1:0.1:1]';
h_peakInd_M3=histogram(R_M3,'BinEdges',correlation,'FaceColor','m');
hold on
h_peakInd_AM3=histogram(R_AM3,'BinEdges',correlation,'FaceColor','g');


%% export plot
figure;
x0=0;
y0=0;
width=1000;
height=1000;
set(gcf,'position',[x0,y0,width,height])

subplot(2,2,1)
pcolor(lags,[1:1:50],R_xcorr_M3)
shading flat;
caxis([-1 1])
xlim([-4 4])
xticks([-4:1:4])
yticks([0:25:50])
xlabel('Lags (sec)','FontSize',15,'FontWeight','bold')
ylabel('Shuffled trial combinations','FontSize',15,'FontWeight','bold')
title('DISC1+Veh xcorr')
set(gca, 'FontName', 'Arial','Fontsize',20,'linewidth',2)
%c = colorbar;
%c.Label.String = 'Normalized cross correlation coefficient';

subplot(2,2,2)
pcolor(lags,[1:1:50],R_xcorr_AM3)
shading flat;
caxis([-1 1])
xlim([-4 4])
xticks([-4:1:4])
yticks([0:25:50])
xlabel('Lags (sec)','FontSize',15,'FontWeight','bold')
%ylabel('Shuffled trial combinations','FontSize',15,'FontWeight','bold')
title('DISC1+Rap xcorr')
set(gca, 'FontName', 'Arial','Fontsize',20,'linewidth',2)
%c = colorbar;
%c.Label.String = 'Normalized cross correlation coefficient';

subplot(2,2,3)
correlation=[-1:0.1:1]';
h_peakInd_M3=histogram(R_M3,'BinEdges',correlation,...
    'FaceColor','m','FaceAlpha',0.5,'EdgeColor','none');
hold on
h_peakInd_AM3=histogram(R_AM3,'BinEdges',correlation,...
    'FaceColor','g','FaceAlpha',0.5,'EdgeColor','none');
hold on
box off
xlim([-1 1])
xlabel('Correlation','FontSize',15,'FontWeight','bold')
ylabel('Probability','FontSize',15,'FontWeight','bold')
%title('Correlation coefficient at lag=0')
set(gca, 'FontName', 'Arial','Fontsize',20,'linewidth',2)

subplot(2,2,4)
h_peakInd_M3=histogram(lags(MaxInd_M3),'BinEdges',lags,...
    'FaceColor','m','FaceAlpha',0.5,'EdgeColor','none');
hold on
h_peakInd_AM3=histogram(lags(MaxInd_AM3),'BinEdges',lags,...
    'FaceColor','g','FaceAlpha',0.5,'EdgeColor','none');
hold on
box off
xlim([-4 4])
xlabel('Lags (sec)','FontSize',15,'FontWeight','bold')
ylabel('Probability','FontSize',15,'FontWeight','bold')
%title('Peak correlation coefficient')
set(gca, 'FontName', 'Arial','Fontsize',20,'linewidth',2)

saveas(gcf,'MDIC-fam.tiff')
%saveas(gcf,'MDIC-test.tiff')

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
pcolor(lags,[1:1:50],R_xcorr_M3)
shading flat;
caxis([-1 1])
xlim([-4 4])
xticks([-4:2:4])
yticks([0:25:50])
%xlabel('Lags (sec)','FontSize',15,'FontWeight','bold')
%ylabel('Shuffled trial combinations','FontSize',15,'FontWeight','bold')
title('M3+CNO xcorr')
set(gca, 'FontName', 'Arial','Fontsize',20,'linewidth',2)
%c = colorbar;
%c.Label.String = 'Normalized cross correlation coefficient';

subplot(3,1,2)
pcolor(lags,[1:1:50],R_xcorr_AM3)
shading flat;
caxis([-1 1])
xlim([-4 4])
xticks([-4:2:4])
yticks([0:25:50])
%xlabel('Lags (sec)','FontSize',15,'FontWeight','bold')
%ylabel('Shuffled trial combinations','FontSize',15,'FontWeight','bold')
title('AM3+CNO xcorr')
set(gca, 'FontName', 'Arial','Fontsize',20,'linewidth',2)
%c = colorbar;
%c.Label.String = 'Normalized cross correlation coefficient';

subplot(3,1,3)
h_peakInd_M3=histogram(lags(MaxInd_M3),'Normalization','probability','BinEdges',lags,...
    'FaceColor','m','FaceAlpha',0.5,'EdgeColor','none');
hold on
h_peakInd_AM3=histogram(lags(MaxInd_AM3),'Normalization','probability','BinEdges',lags,...
    'FaceColor','g','FaceAlpha',0.5,'EdgeColor','none');
hold on
box off
xlim([-4 4])
xlabel('Lags (sec)','FontSize',15,'FontWeight','bold')
ylabel('Probability','FontSize',15,'FontWeight','bold')
%title('Peak correlation coefficient')
set(gca, 'FontName', 'Arial','Fontsize',20,'linewidth',2)

%saveas(gcf,'AM3 MDIC-fam.tiff')
saveas(gcf,'AM3 MDIC-test.tiff')

figure;
caxis([-1 1])
c = colorbar;
c.Label.String = 'Normalized cross correlation coefficient';
set(gca, 'FontName', 'Arial','Fontsize',15)
saveas(gcf,'cs.tiff')