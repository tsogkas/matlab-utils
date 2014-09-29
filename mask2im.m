% Set image values to zero, except the part specified by the input mask.
% Result is the same type of input image (rgb or gray).
% 
%   out = mask2im(im,mask)
% 
%   im: input image
%   mask: pixels outside mask are set to zero
% 
%   Stavros Tsogkas, February 2012
%   <stavros.tsogkas@ecp.fr>

function out = mask2im(im,mask)

assert(ndims(im)<=3,'Input image must be rgb (3 channels) or gray (1 channel)');
assert(islogical(mask),'Input mask must be logical type');

numberOfChannels = size(im,3);
out = im;

for i=1:numberOfChannels
    tmp = im(:,:,i);
    tmp(~mask) = 0;
    out(:,:,i) = tmp;
end