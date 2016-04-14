function [W] = connectivity(varargin)
% Conncectivity function
% Creates the initial electiode grid of the size n and corresponding number
% of connectivity matrices. 
% Input:
%           1) Gridsize - size of the grid (NxN), default - 13
%           2) Weightsize - size of the connectivity matrix. Has to be odd. 
%              default - 13
%           3) Number of descendants. default - 1.
%           4) Shape of the connections. 1- Gaussian, 2- Bowl Shape, 
%               3- random field. 
%           4) Spread of the Gaussian(sigma). default - 1.
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

if length(varargin)<7;
    plot1 = 0;
    if length(varargin) < 6
    plot2 = 0;
        if  length(varargin) <5;
        scale = 1;
            if  length(varargin) < 4;
                Connectivity = 1;
                if  length(varargin)<3;
                 descendants = 1;
                     if  length(varargin)<2
                        weightsize = 27;
                         if isempty(varargin)
                     gridsize = 13;
                         end
                     end
             end
        end
    end
end
else 
    
    gridsize = varargin{1};
    weightsize =varargin{2};
    descendants = varargin{3};
    connectivity = varargin{4};
    scale = varargin{5}; 
    plot1 = varargin{6};
    plot2 = varargin{7};
    
end


if mod(weightsize,2) ==0
    error('Weight Matrix has to be odd')
end


M = zeros(gridsize); % Electrode Grid HAS TO BE ODD

% Preallocation of the weights matrix
W = zeros(gridsize,gridsize,[gridsize*gridsize]);


switch connectivity
    % Normal Gaussian
    case 1
        
x= linspace(-3,3,weightsize);
% Gaussian Matrix of Weights; A model for convolution
G = exp(-((meshgrid(x).^2+meshgrid(x).^2')/scale));
% Setting the connection to itself to 0
G(ceil(size(G,1)/2),ceil(size(G,2)/2))=0; 

W= convW(M,W,G,descendants,gridsize);

    % Bowl-shape
    case 2
        
x= linspace(-3,3,weightsize);
% Gaussian Matrix of Weights; A model for convolution
G = 1-exp(-((meshgrid(x).^2+meshgrid(x).^2')/scale));
% Setting the connection to itself to 0
G(ceil(size(G,1)/2),ceil(size(G,2)/2))=0; 
W= convW(M,W,G,descendants,gridsize);

    % Random
    case 3
    for i = 1:size(W,3)
    W(:,:,i) = abs(randn(gridsize));
    W(:,:,i)=(W(:,:,i)/ sum(sum(W(:,:,i)))).*descendants;
    end
        
end


switch plot1
    case 1
        figure;
        imagesc(W(:,:,ceil(length(W)/2)));
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
        




function W = convW(M,W,G,descendants,gridsize);
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
        % Normalize the W to sum up to descendants number
        if sum(sum(W(:,:,i))) ~ descendants;
            W(:,:,i) = (W(:,:,i)./sum(sum(W(:,:,i)))).*descendants;
         end
    end
end