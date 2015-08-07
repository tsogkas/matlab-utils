function I = patches2im(patches, imSize, arg)
% PATCHES2IM Stich together patches extracted from an image in a single
% canvas.
%
%   I = PATCHES2IM(patches,imSize,arg) patches is a HxWxKxN array or a cell 
%   array of patches, extracted from an image (K >= 1) and imSize are the 
%   dimensions of the original image. Patches are usually extracted using 
%   IM2PATCHES and PATCHES2IM stiches them together on a single canvas. The 
%   third input argument has a different use depending on the input type.
%   If patches is a cell array, then arg is a Nx4 matrix containing the
%   coordinates of the bounding boxes of each patch. If patches is a
%   numerical array, arg is the stride used to extract the patches with
%   IM2PATCHES in the first place. 
%   By default, stride = [size(patches,1),size(patches,2)] is used. In this
%   case, the original image can be reconstructed exactly (
% 
%   NOTE: Stride affects the overlap between neighboring patches and,  
%   subsequently, the size of the output canvas, since it depends on the 
%   number of patches covering the vertical and horizontal sides of the 
%   original image. If stride == patch size, we can reconstruct the
%   original image exactly ('distinct' mode in IM2COL and COL2IM).
% 
% See also: IM2PATCHES, IM2COL, COL2IM
% 
% Stavros Tsogkas, <stavros.tsogkas@ecp.fr>
% Last update: August 2015 

if iscell(patches) 
    warning('This part of the function has not been tested')
    narginchk(3,'You have to provide the matrix with the bounding box coordinates.');
    bb = arg;
    assert(ismatrix(bb) && size(bb,2) == 4, ['Boxes should be a Nx4 matrix'... 
        'containing the [xmin,ymin,xmax,ymax] coordinates of the patches'' bounding boxes'])
    bb(:,1) = max(1,bb(:,1));
    bb(:,2) = max(1,bb(:,2));
    bb(:,3) = min(imSize(2),bb(:,3));
    bb(:,4) = min(imSize(1),bb(:,4));
    I = zeros(imSize,'like',patches{1});
    for yy=1:size(bb,1)
        I(bb(yy,2):bb(yy,4),bb(yy,1):bb(yy,3),:) = patches{yy};
    end    
elseif isnumeric(patches) && ndims(patches) == 4
    [patchHeight,patchWidth,nChannels,nPatches] = size(patches);    
    if nargin < 3                   % Identical strides for X and Y axis.
        strideX = patchWidth;       % Default is equivalent to 'distinct' 
        strideY = patchHeight;      % option for Matlab's im2col.
    else
        stride = arg;
        if isscalar(stride)
            strideY = stride;
            strideX = stride;
        elseif numel(stride) == 2       % Different strides for X and Y axis.
            strideY = stride(1);
            strideX = stride(2);
        else
            error('Stride can be either a scalar or a [strideX, strideY] vector.')
        end
    end
    hout = imSize(1) - mod(imSize(1)-patchHeight,strideY) + strideY*(strideY > 1);
    wout = imSize(2) - mod(imSize(2)-patchWidth, strideX) + strideX*(strideX > 1);
    nPatchesX = fix((hout-patchHeight)/strideY) + 1;
    nPatchesY = fix((wout-patchWidth) /strideX) + 1;
    assert(nPatchesX*nPatchesY == nPatches, 'Total number of patches does not match')
    I = zeros(nPatchesY*patchHeight, nPatchesX*patchWidth, nChannels, 'like',patches);
    for xx=1:nPatchesX
        for yy=1:nPatchesY
            I((1:patchHeight)+(yy-1)*patchHeight, ...
               (1:patchWidth) +(xx-1)*patchWidth,:) = patches(:,:,:,yy+nPatchesY*(xx-1));
        end
    end
    % If stride is equal to the patch size, then we can reconstruct the
    % original image exactly ('distinct' mode in im2col, col2im)
    if strideY == patchHeight && strideX == patchWidth
        I = I(1:imSize(1),1:imSize(2),:);
    end
else
    error('patches must be a cell array or a HxWxKxN array (K >= 1)')
end