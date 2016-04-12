function dude = avalanches(grid,iter)
n = grid;
A = zeros(n);
W = zeros(n,n,n*n);
for i = 1:n*n
    W(:,:,i) = abs(randn(n))/(n*n*0.7979);
end
Meta_Array = zeros(n,2);
for i = 1:iter
    if i > 1
        Meta_Array(i-1,1) = size_time;
        Meta_Array(i-1,2) = size_neurons;
    end
    size_time = 0;
    size_neurons = 1;
    A(3,3) = 1;
    while any(any(A))==1        
        size_time = size_time + 1;
        active_neurons=find(A==1)';
        Next_Gen = sum(W(:,:,active_neurons),3);
        A = Next_Gen > rand(n);        
        A(active_neurons) = 0;
        size_neurons = size_neurons + sum(sum(A));
        
    end
end
dude = Meta_Array;
end


