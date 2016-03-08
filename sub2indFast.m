function ind = sub2indFast(sz,x,y,z)
% SUB2INDFAST  Fast version of Matlab's sub2ind without checks. Supports
% 2D matrices and 3D arrays.
%   
%   ind = SUB2INDFAST(sz,x,y,z) sz is a 2-element vector with the matrix 
%   dimensions ([height,width]). x,y,z are the x,y,z coordinates (z is 
%   optional).
% 
% See also: sub2ind
% 
% Stavros Tsogkas, <stavros.tsogkas@ecp.fr>
% Last update: August 2015 

ind = y + sz(1)*(x-1);
if nargin > 3
    ind = ind + sz(1)*sz(2)*(z-1);
end