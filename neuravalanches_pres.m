%% Slow mode
avalanches('slow')

%%
mat=zeros(8);
mat(20)=1;
coord=find(mat==1);
matflip=mat+1;
matflip(coord)=0;

C = zeros(size(mat));

% one matrix for one coord
[row,col]=find(matflip);







%% Fast mode
avalanches('fast')