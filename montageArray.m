% MONTAGEARRAY  Simple wrapper for montage that facilitates function call
% when the input is a MxNxK array
%
%   montageArray(images)  when images is a MxNxK array, first reshapes
%   images to MxNx1xK and then calls MATLAB montage function with the jet
%   colormap.
% 
%   Stavros Tsogkas, <stavros.tsogkas@ecp.fr>
%   Last update: November 2014


function montageArray(images)
   sz = size(images);
   assert(length(sz)==3,'Input array is not 3D');
   montage(reshape(images,sz(1),sz(2),1,sz(3)),jet)
end

