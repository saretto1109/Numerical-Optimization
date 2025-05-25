function centroid = Centroid(S_sorted)
%CENTROID computes the centroid of the first n points of an ordered simplex.
%   Input: S, already sorted
%   Output: x= (1\n) *(\sum_{i=1}^n x_i)

centroid= mean(S_sorted(:, 1:end-1), 2);    %Compute the mean of the first n (of n+1) points 
end

