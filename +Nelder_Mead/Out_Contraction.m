function output = Out_Contraction(centroid,p_c, x_r)
%OUT_CONTRACTION returns the outer contraction of the point x_r, with
%parameter p_c
%   Input: the centroid, the parameter of scale, the reflected point x_r
%   Output: the outer contraction x_outc

output= centroid + p_c*(x_r - centroid);
end

