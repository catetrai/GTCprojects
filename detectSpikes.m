function [s, t] = detectSpikes(x, Fs);
% Detect spikes.
%   [s, t] = detectSpikes(x, Fs) detects spikes in x, where Fs the sampling
%   rate (in Hz). The outputs s and t are column vectors of spike times in
%   samples and ms, respectively. By convention the time of the zeroth
%   sample is 0 ms. x(:,3)


% Function from the lecture
sigma = median(abs(x)/0.6745);


loc = {};

for i=1:4;
 [~,loc{i}(:,1)] = findpeaks(-x(:,i),'MinPeakHeight',5*sigma(i));
end

s = [ loc{1}(:,1);loc{2}(:,1);loc{3}(:,1);loc{4}(:,1)];
s = unique(s);
% Comment: Since we are detecting the peaks our waveforms have to be aligned;
 
s = s(logical([1 ; (diff(s)>15)]));
 
% Alternative way - Faster, but dirtier. 
%It usually misses some spikes on the edges. 
%m=find(x<=-5*sigma);
%s = m(logical([0 ; (diff(m)>30)]));

t = s./(Fs/1000);

