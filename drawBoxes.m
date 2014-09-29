% DRAWBOXES Draw bounding boxes on an image.
% 
%   lh = DRAWBOXES(boxes) draws red bounding boxes of equal intensity,
%   returning the line handles (useful for clearing boxes from the image).
% 
%   lh = DRAWBOXES(boxes,scores) draws red bounding boxes of varying
%   intensity depending on score values. Scores can either be a positive 
%   scalar or a signed vector, in which case it is normalized in the [0,1] 
%   range (default: 1).
% 
%   lh = DRAWBOXES(boxes,scores,baseColor) changes the color used for
%   plotting. baseColor is a 3x1 vector containing the rgb representation of
%   the color (default: [1 0 0] - red).
% 
%   lh = DRAWBOXES(boxes,scores,baseColor,lineWidth) uses a different line
%   width for the box sides (default: 3).
% 
% Stavros Tsogkas, March 2013
% <stavros.tsogkas@ecp.fr>

function lh = drawBoxes(boxes,scores,baseColor,lineWidth)

if nargin < 2, scores    = [];      end 
if nargin < 3, baseColor = [1 0 0]; end % red color as default
if nargin < 4, lineWidth = 3;       end

if isempty(scores)
    normScores = ones(size(boxes,1),1);
elseif isscalar(scores)
    assert(scores>=0,'For a scalar input, scores must be positive')
    normScores = min(1, scores(ones(size(boxes,1),1)));
else
    normScores = (scores - min(scores)) / (max(scores)-min(scores));
end
lh    = [];
for i = 1:size(boxes,1)
    xmin = boxes(i,1);
    ymin = boxes(i,2);
    xmax = boxes(i,3);
    ymax = boxes(i,4);    
    color = baseColor*normScores(i);
    X = [xmin xmin; xmax xmax; xmin xmax; xmin xmax]';
    Y = [ymin ymax; ymin ymax; ymin ymin; ymax ymax]';
    h = line(X,Y,'Color',color,'Linewidth',lineWidth);
    lh = [lh; h];
end
