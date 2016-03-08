function [rows,cols] = ind2subFast(sz, ind)
% IND2SUBFAST  Fast version of Matlab's ind2ub without checks. Only
% supports 2D matrices for now.
%   
%   [rows,cols] = IND2SUBFAST(sz,ind) sz is a 2-element vector with the
%   matrix dimensions ([height,width]). ind are the linear indices
% 
% See also: ind2sub
% 
% Stavros Tsogkas, <stavros.tsogkas@ecp.fr>
% Last update: August 2015 

rows = rem(ind-1,sz(1)) + 1;
cols = (ind-rows)/sz(1) + 1;