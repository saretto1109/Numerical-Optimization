function output = Reflection_Expansion(centroid, p, x_worst)
%REFLECTION_EXPANSION returns the reflected/exandend point, according to
%the parameter p (p=1 --> reflection, p=2 --> expansion)
%   Input: the centroid, the parameter of scale, the worst point of the simplex
%   Output: the reflected point (x_r) or the expandend point (x_e)

output= centroid + p*(centroid - x_worst);           
end

