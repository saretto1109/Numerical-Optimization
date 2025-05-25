function S= Generate_simplex(x0)
%GENERATE_SIMPLEX 
%   Detailed explanation goes here

delta= 0.2; 
n = length(x0);
S = zeros(n, n+1);
S(:,1) = x0;

for i = 1:n
    x=x0;
    if x(i) ~= 0
        x(i) = x(i) * (1 + delta);    
    else
        x(i) = 0.00025;               %small fixed value
    end
    S(:, i+1) = x;
end   
end

