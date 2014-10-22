% NORMALIZE01 Normalize data vector or matrix in [0,1].
%   Vectors are normalized using the formula: (x -min(x))/(max(x) -
%   min(x)), so that each element of x is in the range [0,1].
%   Matrices of feature vectors are considered to be in the form NxD, where 
%   N is the number of data vectors and D is the dimensionality of each
%   vector.
% 
%   out = NORMALIZE01(data)
% 
%   [out, nc] = NORMALIZE01(data) also returns a struct with max(data) and
%   min(data).
%
% Stavros Tsogkas, <stavros.tsogkas@ecp.fr>
% Last update: October 2014


function [out, nc] = normalize01(data)

if isvector(data)
    nc.min = min(data(:));
    nc.max = max(data(:));
    if abs(nc.max - nc.min) < 1e-6
        warning('max(in) - min(in) is very close to zero!')
        out = data-nc.min+0.5;
    else
        out = (data-nc.min) / (nc.max - nc.min);
    end
elseif ismatrix(data)
    out = bsxfun(@rdivide, data, sqrt(sum(data.^2, 2)));
else
    error('Data should be in a vector or matrix form')
end
