function output= In_Contraction(centroid, p_c, x_worst)
%IN_CONTRACTION returns the inner contraction of the point x_worst, with parameter p
%   Input: the centroid, the parameter p and the worst point x_worst
%   Output: the inner contraction x_inc

output= centroid - p_c*(centroid - x_worst);
end

