function [separable,h,g] = isfilterseparable(f)
% ISFILTERSEPARABLE Determine if 2D filter is separable and optionally
%   split it into two 1D filters. The code used here is the same code used
%   in FILTER2 and IMFILTER.
% 
%   [separable,h,g] = ISFILTERSEPARABLE(f)
% 
% See also: svd, rank, filter2, imfilter.
% 
% Stavros Tsogkas, <tsogkas@cs.toronto.edu>
% Last update: June 2017 

assert(ismatrix(f), 'Only 2D filters are supported')
[u,s,v] = svd(double(f),'econ'); % Check rank (separability) of filter
separable = s(2,2) <= length(f)*eps(s(1,1)); %only need to check if rank > 1
h = []; g = [];
if nargout > 1 && separable
    h = u(:,1) * sqrt(s(1,1));
    g = v(:,1)'* sqrt(s(1,1));
end
