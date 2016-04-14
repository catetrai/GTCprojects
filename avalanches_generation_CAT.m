function sizes = avalanches_generation_CAT(grid,iter)

n = grid;
A = zeros(n);
W = zeros(n,n,n*n);

for i = 1:n*n
    W(:,:,i) = abs(randn(n))/(n*n*0.7979);
end

Meta_Array = zeros(n,1);
for i = 1:iter
    if i > 1
        Meta_Array(i-1) = size_neurons;
    end
    size_neurons = 1;
    A(randi(n)) = 1;
    while any(any(A))==1        
        active_neurons = find(A==1)';
        Next_Gen = sum(W(:,:,active_neurons),3);
        A = Next_Gen > rand(n); 
        A(active_neurons) = 0;  % substitute this with refractoriness!    
        size_neurons = size_neurons + sum(sum(A));
    end
end
sizes = Meta_Array;
end