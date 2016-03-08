
function out = cropImageBox(in,bbox)
% CROPIMAGEBOX  Return rectangular part of input image.
% 
%   out = CROPIMAGEBOX(in,bbox) bbox is 4-element vector: [xmin,ymin,xmax,ymax]
% 
% Stavros Tsogkas, <stavros.tsogkas@centralesupelec.fr>
% Last update:  October 2015
% 
out = in(bbox(2):bbox(4), bbox(1):bbox(3), :);
