% BBOX2MASK Creates binary mask based on a boundary box
%   
%   mask = BBOX2MASK(bbox,imSize)
%   bbox: [xmin ymin xmax ymax]
% 
% Stavros Tsogkas <stavros.tsogkas@ecp.fr>
% Last update: August 2013


function mask = bbox2mask(bbox,imSize)

mask = false(imSize(1),imSize(2));
mask(bbox(2):bbox(4), bbox(1):bbox(3)) = true;

