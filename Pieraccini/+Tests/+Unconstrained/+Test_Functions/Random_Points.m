function X = Random_Points(x0)
%RANDOM_POINTS generates 10 randomic starting points around x0
%   Input: a starting point x0
%   Output: a vector X containing 10 starting points generated around x0.
%   X=[x01 x02 ... x010] (column vectors)

rng(318121);

n = length(x0);
X = zeros(n, 10);

for j = 1:10
    X(:,j) = x0 + (2*rand(n,1) - 1);         % uniformly distributed in [x0-1, x0+1]
end

end

