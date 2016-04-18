function [b] = extractFeatures(w)
% Extract features for spike sorting.
%   b = extractFeatures(w) extracts features for spike sorting from the
%   waveforms in w, which is a 3d array of size length(window) x #spikes x
%   #channels. The output b is a matrix of size #spikes x #features.
%
%   This implementation does PCA on the waveforms of each channel
%   separately and uses the first three principal components. Thus, we get
%   a total of 12 features.
nChannels = size(w,3);

%PCA



for i =1:4
    [~,score(:,:,i),latent(:,:,i)] = pca(w(:,:,i)');
end


b = [score(:,1:3,1) score(:,1:3,2) score(:,1:3,3) score(:,1:3,4)];
disp('Variance')
disp('Channel 1. PC1 PC2 PC3')
disp(num2str(latent(1:3,1,1)./sum(latent(:,:,1))))
disp('Channel 2. PC1 PC2 PC3')
disp(num2str(latent(1:3,1,2)./sum(latent(:,:,2))))
disp('Channel 3. PC1 PC2 PC3')
disp(num2str(latent(1:3,1,3)./sum(latent(:,:,3))))
disp('Channel 4. PC1 PC2 PC3')
disp(num2str(latent(1:3,1,4)./sum(latent(:,:,4))))
  %[coef1, score1,latent1] = pca(w(:,[~isnan(w(1,:,1))],1)');
  %[coef2, score2,latent2] = pca(w(:,[~isnan(w(1,:,2))],2)');
  %[coef3, score3,latent3] = pca(w(:,[~isnan(w(1,:,3))],3)');
  %[coef4, score4,latent4] = pca(w(:,[~isnan(w(1,:,4))],4)');

% Take 1st 3 components into 
%b(:,:) =[coef1(:,1:3) coef2(:,1:3) coef3(:,1:3) coef4(:,1:3)];
%score{:,:}= {score1(1:3,:) score2(1:3,:) score3(1:3,:) score4(1:3,:)};
%latent(:,:)= [latent1(1:3) latent2(1:3) latent3(1:3) latent4(1:3)];
%amp = [score1(:,1:3) score2(:,1:3) score3(:,1:3)  score4(:,1:3)];

