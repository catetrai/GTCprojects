function w = extractWaveforms(x,s,fs)
% Extract spike waveforms.
%   w = extractWaveforms(x, s) extracts the waveforms at times s (given in
%   samples) from the filtered signal x using a fixed window around the
%   times of the spikes. The return value w is a 3d array of size
%   length(window) x #spikes x #channels.

% 1ms window into samples
t = 0.0005*fs;
nChannels = size(x,2);


for i =1:nChannels
   for n=1:length(s)
        % Extraction :)
w(:,n,i) = x([s(n)-t]:[s(n)+t-1],i);

    end
end



