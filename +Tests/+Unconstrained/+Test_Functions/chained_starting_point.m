function x0 = chained_starting_point(n)
%STARTING_POINT builds a starting point vector of dimension n
%   Input: the dimension n of the starting point
%   Output: the starting point built as defined in V897-03-2.pdf Problem 1
%   \bar{x}(i)=-1.2 if mod(i,2)=1,  \bar{x}(i)=1.0 if mod(i,2)=0

x0 = zeros(n,1);

for i = 1:n
    if mod(i,2) == 1
        x0(i) = -1.2;
    else
        x0(i) = 1.0;
    end
end

end

