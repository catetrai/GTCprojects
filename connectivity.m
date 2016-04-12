function [M,W] = connectivity(varargin)
% Conncectivity function
% Creates the initial electiode grid of the size n and corresponding number
% of connectivity matrices. 
% Input:
%           1) Gridsize - size of the grid (NxN), default - 13
%           2) Weightsize - size of the connectivity matrix. Has to be odd. 
%              default - 13
%           3) Number of descendants. default - 1.
%               Given as a power of the vector norm;
%               1-for one; 1.3 - for two; 1.6 - for three; 2.2 - for five
%           4) Scale of the Gaussian(sigma). default - 1.
%           5) Plot model of weights - 1or 0; default - 0.
%           6) Plot full set of weights - 1 or 0; default - 0. (Not
%           recommended)
%
% 
% Output: 
%           M - Electrode grid
%           W - 3D Matrix of connectivity
%
% Example: 
% [M,W] = connectivity(10,10,1,1);


if length(varargin) < 6
    plot1 = 0;
    if  length(varargin) <5;
        plot2 = 0;
        if  length(varargin) < 4;
            scale = 1;
             if  length(varargin)<3;
                 descendants = 1;
                     if  length(varargin)<2
                        weightsize = 13;
                         if isempty(varargin)
                     gridsize = 13;
                         end
                     end
             end
        end
    end
else 
   
    gridsize = varargin{1};
    weightsize =varargin{2};
    descendants = varargin{3};
    scale = varargin{4}; 
    plot1 = varargin{5};
    plot2 = varargin{6};
    
end

if mod(weightsize,2) ==0
    error('Weight Matrix has to be odd')
end


M = zeros(gridsize); % Electrode Grid HAS TO BE ODD
x= linspace(-3,3,weightsize);

  
% Gaussian Matrix of Weights; A model for convolution
G = exp(-((meshgrid(x).^2+meshgrid(x).^2')/scale));
% Setting the connection to itself to 0
G(ceil(size(G,1)/2),ceil(size(G,2)/2))=0; 
% Normalizig the model
n= reshape(G,length(G)^2,1);
n = n/norm(n,descendants);
G = reshape(n,length(G),length(G));
% Preallocation of the weights matrix
W = zeros(gridsize,gridsize,[gridsize*gridsize]);

% Convolution
% Creating the weight matrix for each electrode in the gridl
i = 1;
for c =1:length(M);
    for r=1:length(M);
        M = zeros(gridsize);
        M(c,r)=1;
        i=find(M);
        W(:,:,i) =conv2(M,G,'same');
        % Check for the number of descendants for the border electrodes
        if sum(sum(W(:,:,i))) < 1;
            n= reshape(W(:,:,i),length(W(:,:,i))^2,1);
            n = n/norm(n,descendants);
            W(:,:,i) = reshape(n,length(W(:,:,i)),length(W(:,:,i)));
         end
    end
end

switch plot1
    case 1
        figure;
        imagesc(G);
    case 0 
end

switch plot2
    case 1
        figure;
       for i=1:gridsize^2;
    subplot(gridsize,gridsize,i);
    imagesc(W(:,:,i));
end
    case 0 
end
        