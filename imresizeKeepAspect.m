% imresizeKeepAspect Imresize image preserving the original aspect ratio.
%   TODO: ADD TO UTILS
%   
%   im = imresizeKeepAspect(im, minSize) resizes im so that its minimum 
%   dimensions are [minSize(1), minSize(2)]. minSize can also be a scalar,
%   denoting the minimum size for both height and width.
% 
%   im = imresizeKeepAspect(im, minSize, method)  resizes using specified
%   method, which can be one of 'nearest','bilinear','bicubic' 
%   (default: 'bilinear')
% 
%   See also: imresize
%   
%   Stavros Tsogkas, <stavros.tsogkas@ecp.fr>
%   Last update: November 2014
 

function im = imresizeKeepAspect(im, minSize, method)
    if nargin < 3, method = 'bilinear'; end
    if isscalar(minSize), minSize = [minSize, minSize]; end

    if size(im,1) < minSize(1) 
        aspect = size(im,2)/size(im,1);
        im = imresize(im, [minSize(1),round(minSize(1)*aspect)], method);
    end
    if size(im,2) < minSize(2)
        aspect = size(im,1)/size(im,2);
        im = imresize(im, [round(minSize(2)*aspect),minSize(2)], method);
    end
end

