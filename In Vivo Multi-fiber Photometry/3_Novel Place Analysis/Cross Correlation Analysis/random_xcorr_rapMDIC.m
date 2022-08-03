%v_veh=1:1:size(zscore_veh_IC,1);
%C_veh=nchoosek(v_veh,3);

for k=1:50
    r = randperm(size(zscore_veh_IC,1));
    r = r(1:round(size(zscore_veh_IC,1).*0.75));
for i=1:size(r,2)
    rand_veh_IC(i,:) = zscore_veh_IC(r(i),:);
    rand_veh_MD(i,:) = zscore_veh_MD(r(i),:);
end
    mean_rand_veh_IC(k,:)=mean(rand_veh_IC,1);
    mean_rand_veh_MD(k,:)=mean(rand_veh_MD,1);
    
    lags=[-4:0.1:4]';
    
    R_xcorr_veh(k,:)=xcorr(mean_rand_veh_MD(k,11:51),mean_rand_veh_IC(k,11:51),'coeff');
    [R_veh(k,:),P_veh(k,:)]=corr(mean_rand_veh_MD(k,11:51)',mean_rand_veh_IC(k,11:51)');
    [Peak_veh(k,:),MaxInd_veh(k,:)]= max(abs(R_xcorr_veh(k,:)));
end

for k=1:50
    r = randperm(size(zscore_rap_IC,1));
    r = r(1:round(size(zscore_rap_IC,1).*0.75));
for i=1:size(r,2)
    rand_rap_IC(i,:) = zscore_rap_IC(r(i),:);
    rand_rap_MD(i,:) = zscore_rap_MD(r(i),:);
end
    mean_rand_rap_IC(k,:)=mean(rand_rap_IC,1);
    mean_rand_rap_MD(k,:)=mean(rand_rap_MD,1);
    
    lags=[-4:0.1:4]';
    
    R_xcorr_rap(k,:)=xcorr(mean_rand_rap_MD(k,11:51),mean_rand_rap_IC(k,11:51),'coeff');
    [R_rap(k,:),P_rap(k,:)]=corr(mean_rand_rap_MD(k,11:51)',mean_rand_rap_IC(k,11:51)');
    [Peak_rap(k,:),MaxInd_rap(k,:)]= max(abs(R_xcorr_rap(k,:)));
end

%% output
output_mean_veh=[mean(mean_rand_veh_IC,1);mean(mean_rand_veh_MD,1)];
output_mean_rap=[mean(mean_rand_rap_IC,1);mean(mean_rand_rap_MD,1)];

output_xcorr_veh=mean(R_xcorr_veh,1);
output_xcorr_rap=mean(R_xcorr_rap,1);

% figure;
% plot(output_mean_veh(1,:),'mag')
% hold on
% plot(output_mean_veh(2,:),'black')
% 
% figure;
% plot(output_mean_rap(1,:),'mag')
% hold on
% plot(output_mean_rap(2,:),'black')
% 
% 
% figure;
% plot(lags,output_xcorr_veh,'r')
% hold on
% plot(lags,output_xcorr_rap,'b')

lags=[-4:0.1:4]';
figure;
h_peakInd_veh=histogram(lags(MaxInd_veh),'BinEdges',lags,'FaceColor','m');
hold on
h_peakInd_rap=histogram(lags(MaxInd_rap),'BinEdges',lags,'FaceColor','g');

figure;
correlation=[-1:0.1:1]';
h_peakInd_veh=histogram(R_veh,'BinEdges',correlation,'FaceColor','m');
hold on
h_peakInd_rap=histogram(R_rap,'BinEdges',correlation,'FaceColor','g');


%% export plot
figure;
x0=0;
y0=0;
width=1000;
height=1000;
set(gcf,'position',[x0,y0,width,height])

subplot(2,2,1)
pcolor(lags,[1:1:50],R_xcorr_veh)
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
pcolor(lags,[1:1:50],R_xcorr_rap)
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
h_peakInd_veh=histogram(R_veh,'BinEdges',correlation,...
    'FaceColor','m','FaceAlpha',0.5,'EdgeColor','none');
hold on
h_peakInd_rap=histogram(R_rap,'BinEdges',correlation,...
    'FaceColor','g','FaceAlpha',0.5,'EdgeColor','none');
hold on
box off
xlim([-1 1])
xlabel('Correlation','FontSize',15,'FontWeight','bold')
ylabel('Probability','FontSize',15,'FontWeight','bold')
%title('Correlation coefficient at lag=0')
set(gca, 'FontName', 'Arial','Fontsize',20,'linewidth',2)

subplot(2,2,4)
h_peakInd_veh=histogram(lags(MaxInd_veh),'BinEdges',lags,...
    'FaceColor','m','FaceAlpha',0.5,'EdgeColor','none');
hold on
h_peakInd_rap=histogram(lags(MaxInd_rap),'BinEdges',lags,...
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
pcolor(lags,[1:1:50],R_xcorr_veh)
shading flat;
caxis([-1 1])
xlim([-4 4])
xticks([-4:2:4])
yticks([0:25:50])
%xlabel('Lags (sec)','FontSize',15,'FontWeight','bold')
%ylabel('Shuffled trial combinations','FontSize',15,'FontWeight','bold')
title('DISC1+Veh xcorr')
set(gca, 'FontName', 'Arial','Fontsize',20,'linewidth',2)
%c = colorbar;
%c.Label.String = 'Normalized cross correlation coefficient';

subplot(3,1,2)
pcolor(lags,[1:1:50],R_xcorr_rap)
shading flat;
caxis([-1 1])
xlim([-4 4])
xticks([-4:2:4])
yticks([0:25:50])
%xlabel('Lags (sec)','FontSize',15,'FontWeight','bold')
%ylabel('Shuffled trial combinations','FontSize',15,'FontWeight','bold')
title('DISC1+Rap xcorr')
set(gca, 'FontName', 'Arial','Fontsize',20,'linewidth',2)
%c = colorbar;
%c.Label.String = 'Normalized cross correlation coefficient';

subplot(3,1,3)
h_peakInd_veh=histogram(lags(MaxInd_veh),'Normalization','probability','BinEdges',lags,...
    'FaceColor','m','FaceAlpha',0.5,'EdgeColor','none');
hold on
h_peakInd_rap=histogram(lags(MaxInd_rap),'Normalization','probability','BinEdges',lags,...
    'FaceColor','g','FaceAlpha',0.5,'EdgeColor','none');
hold on
box off
xlim([-4 4])
xlabel('Lags (sec)','FontSize',15,'FontWeight','bold')
ylabel('Probability','FontSize',15,'FontWeight','bold')
%title('Peak correlation coefficient')
set(gca, 'FontName', 'Arial','Fontsize',20,'linewidth',2)

%saveas(gcf,'rap MDIC-fam.tiff')
saveas(gcf,'rap MDIC-test.tiff')

figure;
caxis([-1 1])
c = colorbar;
c.Label.String = 'Normalized cross correlation coefficient';
set(gca, 'FontName', 'Arial','Fontsize',15)
saveas(gcf,'cs.tiff')