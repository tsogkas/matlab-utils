function h = plotCircles(c,r,Marker,LineWidth,MarkerSize)
% PLOTCIRCLES  Plot circles on an image.
%   UPDATE: It seems that the functionality of this function can be
%   achieved with the built-in MATLAB function VISCIRCLES.
% 
%
%   PLOTCIRCLES(c,r)  plots a circle with center (c(1),c(2)) and radius r.
%   If c is a Nx2 matrix and r a Nx1 vector, this function plots N circles,
%   where the i-th circle has center (c(i,1),c(i,2)) and radius r(i).
%
%   PLOTCIRCLES(c,r,Marker)  set color and marker used to plot the circles.
%   Marker can be one of the standard colors used in LineSpec for function
%   plot (default: 'r').
%
%   PLOTCIRCLES(c,r,Color,LineWidth)  sets the width of the line used to
%   plot the circles (default: 1).
%
%   PLOTCIRCLES(c,r,Color,LineWidth,MarkerSize) also sets the size of the
%   marker used (default: 1).
%
%   h = PLOTCIRCLES(c,r)  returns the plot handles. This is useful for
%   deleting the circles that were drawn, using the DELETE function.
%
%   See also: cylinder, plot, delete, viscircles
%
%   Stavros Tsogkas, <tsogkas@cs.toronto.edu>
%   Last update: October 2016

if nargin < 5, MarkerSize = 1; end
if nargin < 4, LineWidth  = 1; end
if nargin < 3, Marker = 'r';   end

[x,y,~] = cylinder(r); h = []; 
if ~isempty(x) && ~isempty(y) && ~isempty(c)
    x = bsxfun(@plus, x, c(:,1)); 
    y = bsxfun(@plus, y, c(:,2));
    hold on; 
    for i=1:size(x,1)
        ch = plot(x(i,:), y(i,:), Marker,'LineWidth',LineWidth,'MarkerSize',MarkerSize); 
        h = [h, ch];
    end
end