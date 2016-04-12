function varargout = spread(matrix,coord)
% ** function new_array = spread(matrix,coord)

    
topBorder = length(matrix)+1:length(matrix):numel(matrix)-2*length(matrix)+1;
bottomBorder = 2*length(matrix):length(matrix):numel(matrix)-length(matrix);
leftBorder = 2:length(matrix)-1;
rightBorder = numel(matrix)-length(matrix)+2:numel(matrix)-1;
topleftCorner = 1;
bottomleftCorner = length(matrix);
toprightCorner = numel(matrix)-length(matrix)+1;
bottomrightCorner = numel(matrix);

if ismember(coord,topBorder)
    direction = randi([2,4]);
elseif ismember(coord,bottomBorder)
    nd = [1 3 4];
    direction = nd(randi(3));
elseif ismember(coord,leftBorder)
    nl = [1 2 4];
    direction = nl(randi(3));
elseif ismember(coord,rightBorder)
    direction = randi(3);
elseif coord==topleftCorner
    nul = [2 4];
    direction = nul(randi(2));
elseif coord==bottomleftCorner
    ndl = [1 4];
    direction = ndl(randi(2));
elseif coord==toprightCorner
    direction = randi([2,3]);
elseif coord==bottomrightCorner
    ndr = [1 3];
    direction = ndr(randi(2));
else
    direction = randi(4);
end
     
switch direction
    case 1  % up
        newcoord = coord-1;
    case 2  % down
        newcoord = coord+1;
    case 3  % left
        newcoord = coord-8;
    case 4  % right
        newcoord = coord+8;
end

matrix(newcoord) = 1;
% a burst cannot occur at in the same location twice in a row
matrix(coord) = 0;
varargout{1} = matrix;
end