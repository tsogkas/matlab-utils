function montageArray(images,cmap)
% MONTAGEARRAY  Simple wrapper for montage that facilitates function call
% when the input is a MxNxK array
%
%   MONTAGEARRAY(images)  reshapes images from a MxNxK to a MxNx1xK array
%   and then calls MATLAB montage function.
% 
%   MONTAGEARRAY(images,cmap)  plots images using the desired colormap
%   (cmap must be a valid colormap).
%
%   Stavros Tsogkas, <stavros.tsogkas@ecp.fr>
%   Last update: August 2015

sz = size(images);
assert(length(sz)==3,'Input array is not 3D');
if nargin > 1
    montage(reshape(images,sz(1),sz(2),1,sz(3)),cmap)
else
    montage(reshape(images,sz(1),sz(2),1,sz(3)))
end


