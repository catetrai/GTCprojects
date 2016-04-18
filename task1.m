

% prepare data
load NDA_rawdata
x  = gain * double(x);

% run code
y = filterSignal(x,samplingRate);
[s, t] = detectSpikes(y, samplingRate);
w = extractWaveforms(y,s,samplingRate);
b = extractFeatures(w);

% plot figures
%% Plot filtered signal
%1
plot(x(1:10000,1));hold on; plot(y(1:10000,1),'MarkerSize',4); legend original filter
%2 

t1=980000;t2 = 1000000;
plotspikes(y,s,3,samplingRate,t1,t2)
% 3


%% Plot first 100 detected spikes
%
%h1=plot(w(:,1:100,1),'k-');

figure;
% Plot max 100 spikes;
%Find large spikes;

for i=1:size(w,2)
    a(i,1)=i;
    a(i,2)= min(w(:,i,1));
end

B = sortrows(a,[2]);
%B(isnan(B(:,2)),:)=[];
%
h2= plot([1:30],w(:,B(end-10:end,1),1),'k-',[1:30],w(:,B(1:100,1),1),'r-'); 
title('Extracted Spikes','FontSize',18)
xlabel('Time','FontSize',18);ylabel(['Voltage ' ,'(\mu','V)'],'Interpreter','tex', 'FontSize',18);
set(gca,'XTick',[0  10 15 20 30  ])
set(gca,'XTickLabel',{'-15 ','-10','0','10','15'});

box off


%% PCA Scatter
subplot(3,2,1);
plot(b(:,1),b(:,2),'.','MarkerSize',0.001); title('PC1');
xlabel('Channel 1'); ylabel('Channel2')
subplot(3,2,3);
plot(b(:,1),b(:,3),'.','MarkerSize',0.001);title('PC1')
xlabel('Channel 1'); ylabel('Channel 3')
subplot(3,2,5);
plot(b(:,1),b(:,4),'.','MarkerSize',0.001);title('PC1');
xlabel('Channel 1'); ylabel('Channel 4')
subplot(3,2,2);
plot(b(:,2),b(:,3),'.','MarkerSize',0.001);title('PC1');
xlabel('Channel 2'); ylabel('Channel 3')
subplot(3,2,4);
plot(b(:,2),b(:,4),'.','MarkerSize',0.001);title('PC1');
xlabel('Channel 2'); ylabel('Channel 4')
subplot(3,2,6);
plot(b(:,4),b(:,3),'.','MarkerSize',0.001);title('PC1');
xlabel('Channel 4'); ylabel('Channel 3');




