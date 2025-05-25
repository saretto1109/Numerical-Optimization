function output = Shrink(S_sorted,p_s)
%SHRINK Summary of this function goes here
%   Detailed explanation goes here

x_1=S_sorted(:,1);
[n,dim]=size(S_sorted);
output= zeros(n, dim);
output(:,1)= x_1;
for i=2:dim
    output(:,i) = x_1 + p_s*(S_sorted(:,i) - x_1);
end
end

