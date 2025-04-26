function is_acceptable = Acceptable_Diameter(S, tol)
% ACCEPTABLE_DIAMETER returns true if the maximum diameter of the simplex is below the tolerance threshold.
%   Input: the simplex S, a tolerance threshold tol
%   Output: true if the diameter of the simplex is below the threshold

D = pdist(S);          
diam = max(D);
is_acceptable= diam < tol;
end

