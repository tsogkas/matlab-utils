% GETFILTERSUPPORT Find filter support and crop its rectangular bounding box
% 
%   [cropped, support] = GETFILTERSUPPORT(f)
% 
% Stavros Tsogkas <stavros.tsogkas@ecp.fr>
% Last update: October 2013

function [cropped, support] = getFilterSupport(f)

srows = zeros(size(f,1),1);
scols = zeros(1,size(f,2));
for i = 1:size(f,3);
    srows  = srows | sum(f(:,:,i),2);
    scols  = scols | sum(f(:,:,i),1);
end
support = false(size(f,1),size(f,2));
support(srows>0, scols>0) = true;
cropped = squeeze(f(srows>0,scols>0,:));


