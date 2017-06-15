function b = border(I, R)
% BORDER returns a logical mask corresponding to the input frame.
% 
%   B = BORDER(I,R) If I is a 2D image (matrix), returns a 2D logical mask
%   that is true in a R-wide frame at the image border. If I is a 3D array,
%   the mask returned is also 3D. If R is not provided, a 1-pixel wide
%   border mask is returned.
% 
% Stavros Tsogkas, <tsogkas@cs.toronto.edu>
% Last update: June 2017

if isscalar(I)
    error('Input must be an array or a vector of dimensions')
elseif isvector(I)
    sz = I;
else
    sz = size(I);
end
if nargin < 2, R = 1; end
rows = sz(1);
cols = sz(2);
rest = prod(sz(3:end));
b = false(rows,cols,rest);
b(1:R,:,:) = true;
b(:,1:R,:) = true;
b((end-R+1):end,:,:) = true;
b(:,(end-R+1):end,:) = true;
b = reshape(b,sz);
    