function [S_sorted,F_sorted] = Sort(S, f)
%SORT  evaluates the objective function f at each vertex of the simplex, 
%   sorts the function values in ascending order, 
%   and returns the corresponding reordered simplex points.
%   Input: S (simplex), f (ojective function)
%   Output: S sorted, F sorted

n = size(S, 2);                     % The columns of S are the points of the simplex
F = zeros(1, n);                    % F is the vector that stores the function values

for i = 1:n
    F(i) = f(S(:, i));              % Evaluate f for each column of S
end

[F_sorted, ind] = sort(F);          % Sort by ascending order of f(x)
S_sorted = S(:, ind);               % Sort S according to the order of F
end

