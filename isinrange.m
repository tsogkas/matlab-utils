function y = isinrange(x,interval,dim)
% ISINRANGE Checks if the elements of an array fall within a certain range.
% 
%   y = ISINRANGE(x,interval) returns true if all the elements of x fall
%   within [a,b], where a = interval(1) and b = interval(2). 
% 
%   y = ISINRANGE(x,interval,dim) works across the given dimension dim.
% 
% See also: min, max
% 
% Stavros Tsogkas, <stavros.tsogkas@ecp.fr>
% Last update: August 2015 

assert(numel(interval)==2, 'interval should be a two-element vector')
if nargin < 3
    x = x(:); 
    y = min(x) >= interval(1) & max(x) <= interval(2);
else
    assert(dim<=ndims(x), 'Invalid dimension')
    y = min(x,[],dim) >= interval(1) & max(x,[],dim) <= interval(2);
end