function dude = avalanche_generation(W,grid,iter)
n = grid;
A = zeros(n);
rfr = 3;% Refractory period(in generation)
Meta_Array = zeros(n,1);

active_neurons = cell(size(W,3),iter); % Initiate a counter
g =rfr+1;
for i = 1:iter
     if i > 1
        Meta_Array(i-1,1) = size_neurons;
    end
    
    size_neurons = 1;
    A(randi(n),randi(n)) = 1;
    
    while any(any(A))==1     
        
        active_neurons{g}=find(A==1)';
        Next_Gen = sum(W(:,:,active_neurons{g}),3);
        A = Next_Gen > rand(n);  
        % Refractory neurons
        A([active_neurons{g-rfr:g}]) = 0;
        
        size_neurons = size_neurons + sum(sum(A));

        if g>10000;
           % Break if avalanche lasts forever
           %(N of descentants if more than 1)
            break 
        end
        g = g+1;
    end
end
dude = Meta_Array;
end
