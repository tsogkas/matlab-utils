% Extracts bounding box coordinates from a single object binary mask
% 
%   bbox = mask2bbox(mask)
% 
% Stavros Tsogkas, December 2012
% <stavros.tsogkas@ecp.fr>

function bbox = mask2bbox(mask)

[y,x] = find(mask);
bbox = [min(x) min(y) max(x) max(y)];
