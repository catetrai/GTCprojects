function avalanches(mode,varargin)
% ***** function avalanches(mode,varargin) *****
% bla bla

% % --- define subfunction sigma_i ----------------- %
% function varargout = sigma_i
% % ** function sigma_i
% %    R = sigma_i(N) returns a value of sigma(i), that is the
% %    number of descendants activated by ancestor i. The value
% %    is randomly extracted from a Poisson distribution with
% %    lambda=1.
% varargout{1} = poissrnd(1);
% end


if strcmp(mode,'slow')
    % --- set parameters of the model
    totalTime=100;   % total number of time steps
    timeStepDuration=0.05;
    probSpark=0.3;
    %refrac=5;      % refractoriness
    % --- create empty 8x8 matrix
    mat=zeros(8);   % USE LOGICALS!!!
   
    
    figure;
    h = imagesc(0);
    set(gca,'XLabel',[],'XTick',[],'YTick',[])
    axis([0.3 8.7 0.3 8.7])
    axis square
    colormap('gray')
    

    for t=1:totalTime
        
        coord=find(mat==1);
        sigma_i=poissrnd(1);
        j=1;
        
        % if grid is empty (no ancestors), with a certain
        % probability of spark pick a location at random
        if isempty(coord)
            if rand<=probSpark
                coord = randi(64);
                mat(coord)=1;
            else
            end
        else
            if sigma_i==0
               mat(coord)=0;
            else
                while j<=sigma_i
                    j=j+1;
                    prev_mat = mat;
                    mat = spread(mat,coord);
                    while mat==prev_mat
                        mat = spread(mat,coord);
                    end
                end
            end
%         elseif length(coord)>1
%             for i=1:length(coord)
%                 while j<=sigma_i
%                     j=j+1;
%                     prev_mat = mat;
%                     mat = spread(mat,coord(i));
%                     while mat==prev_mat
%                         mat = spread(mat,coord(i));
%                     end
%                 end
%             end
        end
        
        set(h,'CData',mat);
        title(['t = ',num2str(t)])
       
        drawnow
        pause(timeStepDuration)
    end
    close
    
elseif strcmp(mode,'fast')
    
else
    error('Input argument ''mode'' must be either ''slow'' or ''fast''')
end







end


% for j = 

% sigma = 1;

% if arr==zeros(8)
%             if rand(1)>=pBlank
%                 arr(coord,coord)=1;
%             end