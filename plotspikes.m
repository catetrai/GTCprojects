function plotspikes(y,S,nsigma,samplingRate,t1,t2)

% plotspikes function
% Input: 
%   y - data (nx4 matrix)
%   s - indices of the spikes;
%   nsigma - The threshold (n of the threshold), that was used for detection (e.g. 3,5)
%   samplingRate - 
%   t1 -t2 - time interval in samples (e.g, t1=980000;t2 = 1000000;)
%
%

sigma = median(abs(y)/0.6745);
t = [1:length(y)]./samplingRate; % The time line for x values
tm = NaN(length(y),1);
tm(S,1)=-10*sigma(1);%y(S,1);

thr = NaN(length(y),4);
n=nsigma;
thr(:,1) = n*sigma(1);
thr(:,2) = n*sigma(2);
thr(:,3) = n*sigma(3);
thr(:,4) = n*sigma(4);

% Plot Identified Spikes
%Data
figure('Position', [100, 100, 1049, 1049]); 
box off

h1=plot(t(t1:t2),y(t1:t2,1),'k-',t(t1:t2),y(t1:t2,2)-200,'k-',...
    t(t1:t2),y(t1:t2,3)-400,'k-'...
    , t(t1:t2),y(t1:t2,4)-600,'k-'); hold on; 
%set(gca,'YLim',[0 -600])
set(gca,'YTick',[-600 -400 -200 0])
set(gca,'YTickLabel',{'Channel 4','Channel 3','Channel 2','Channel 1'},'FontSize',20)
xlabel('Time (s)')


%Pointers
h = plot(t(t1:t2),tm(t1:t2,1)-sigma(1),'r.',...
    t(t1:t2),tm(t1:t2,1)-sigma(2)-200,'r.',...
    t(t1:t2),tm(t1:t2,1)-sigma(3)-400,...
    'r.',t(t1:t2),tm(t1:t2,1)-sigma(4)-600,'r.');
set(h,'MarkerSize',6,'MarkerFace','auto')


% Threshold
 plot(t((t1:t2)),-thr(t1:t2,1),'r--');
 plot(t((t1:t2)),-thr(t1:t2,2)-200,'r--');
 plot(t((t1:t2)),-thr(t1:t2,3)-400,'r--');
 plot(t((t1:t2)),-thr(t1:t2,4)-600,'r--');
 
 title('Detected Spikes: threshold -  $3\  \sigma$','Interpreter','LaTeX')
 