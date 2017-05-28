% DRAWBOXES(boxes) Draw bounding boxes on an image.
% 
%   lh = DRAWBOXES(boxes) draws red bounding boxes of equal intensity,
%       returning the line handles (useful for clearing boxes from the image).
% 
%   lh = DRAWBOXES(boxes,'PropertyName',PropertyValue)
% 
%   Valid property names:
%   'color':    changes the color used for plotting. color can be a 3x1 
%               rgb vector or a color name string (default: [1 0 0] - 'red').
% 
%   'scores':   draws bounding boxes of varying intensity depending on score 
%               values. Scores can either be a positive scalar or a signed 
%               vector, in which case it is normalized in [0,1] (default: 1).
% 
%   'lineWidth': changes the line width for the box sides (default: 3)
% 
%   See also color2vector
% 
%   Stavros Tsogkas, <tsogkas@cs.toronto.edu>
%   Last update: May 2017

function lh = drawBoxes(boxes,varargin)

defaultArgs = {'color','r','lineWidth',3,'scores',1};
vmap      = parseVarargin(defaultArgs,varargin);
scores    = vmap('scores');
color     = vmap('color');
lineWidth = vmap('lineWidth');

if isscalar(scores) % Score weights for each bounding box
    assert(scores>=0, 'For a scalar input, scores must be positive')
    normScores = min(1, scores(ones(size(boxes,1),1)));
else
    normScores = normalize01(scores);
end
if ischar(color)  % If color is a string or char, turn it into an rgb vector.
    color = color2vector(color);
end

lh    = [];
for i = 1:size(boxes,1)
    xmin = boxes(i,1);
    ymin = boxes(i,2);
    xmax = boxes(i,3);
    ymax = boxes(i,4);    
    X = [xmin xmin; xmax xmax; xmin xmax; xmin xmax]';
    Y = [ymin ymax; ymin ymax; ymin ymin; ymax ymax]';
    h = line(X,Y,'Color',color*normScores(i),'Linewidth',lineWidth);
    lh = [lh; h];
end
