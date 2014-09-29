% CROPIMAGEBOX  Return rectangular part of input image
% 
%   out = cropImageBox(in,bbox)
%   
% INPUT:
%   bbox: [xmin,ymin,xmax,ymax]
% 
% Stavros Tsogkas, January 2013
% <stavros.tsogkas@ecp.fr>

function out = cropImageBox(in,bbox)

out = squeeze(in(bbox(2):bbox(4), bbox(1):bbox(3), :));
