function out = imresizeCrisp(in, scale, compare)
% IMRESIZECRISP Resize input image without blurring.
%   IMRESIZECRISP works in a similar way as Matlab's imresize function
%   with the 'nearest' method, but without "erasing" pixels when
%   downsampling a very sparse input, such as boundary maps. Pixel
%   coordinates in the input space are mapped to coordinates in the
%   output image. The value of a pixel in the output image is the
%   maximum of the values of all points in the original image that are
%   mapped to it.
%
%   out = IMRESIZECRISP(in,scale) where scale is a scalar resizes an image
%   so that size(output) = scale*size(input). If scale > 1, then
%   IMRESIZECRISP calls MATLAB's imresize function with the 'nearest'
%   method to upsample the image. If scale < 1, the image is downsampled.
%
%   out = IMRESIZECRISP(in, [H,W]), resizes the input image so that the
%   output is HxW.
%
%   NOTE: This function only works for inputs with non-negative values.
%
%   When the input is a HxWxC array, IMRESIZECRISP is applied to all
%   channels.
% 
% TODO: Replace for-loop
%
% Stavros Tsogkas, <tsogkas@cs.toronto.edu>
% Last update: February 2017


% Parse arguments and compute output dimensions
if nargin < 3, compare = false; end
if isscalar(scale)  % scaling factor
    if scale == 1
        out = in;
        return
    elseif scale > 1
        out = imresize(in,scale,'nearest');
        return
    else
        [Hin,Win,Cin] = size(in);
        scaleHor = scale;
        scaleVer = scale;
        Hout     = round(Hin*scaleVer);
        Wout     = round(Win*scaleHor);
        Cout     = Cin;
    end
elseif numel(scale) == 2 % resize to [H,W]
    if scale(1) == size(in,1) && scale(2) == size(in,2)
        out = in;
        return
    elseif scale(1) > size(in,1) && scale(2) > size(in,2)
        out = imresize(in,scale,'nearest');
        return
    else
        % We use two separate resizing steps because we may have
        % upsampling in one dimension and downsampling in the other.
        if scale(1) > size(in,1)
            in = imresize(in,[scale(1), size(in,2)],'nearest');
        end
        if scale(2) > size(in,2)
            in = imresize(in,[size(in,1), scale(2)],'nearest');
        end
        [Hin,Win,Cin] = size(in);
        Hout     = scale(1);
        Wout     = scale(2);
        Cout     = Cin;
        scaleHor = Wout / Win;
        scaleVer = Hout / Hin;
    end
else
    error('scale must be a scalar or a [height, width] vector')
end


out = zeros(Hout,Wout,Cout,class(in));
for c=1:Cout
    % Get coordinates of nonzero and nonnegative
    inc  = in(:,:,c);
    inds = find(inc > 0);
    vals = inc(inds);

    % Map to new coordinates. In the case of downsampling, multiple input
    % coordinates may be mapped to the same output coordinates.
    [yout,xout]= ind2sub([Hin,Win],inds);
    yout = ceil(yout*scaleVer);
    xout = ceil(xout*scaleHor);
    % Remove indices that fall outside of the image
    offLimits = xout > Wout | yout > Hout | xout < 1 | yout < 1;
    xout(offLimits) = [];
    yout(offLimits) = [];
    vals(offLimits) = [];

    % We sort all values first to later obtain more easily the max among
    % possibly multiple values corresponding to the same output point.
    [vals, indSort] = sort(vals,'descend');
    xout = xout(indSort); yout = yout(indSort);

    % unique() returns indexes IA which point to the first occurence of
    % each element. If vals is sorted, that index corresponds to the
    % maximum value for that pixel by default.
    [uniqueInds,IA] = unique(sub2ind([Hout,Wout],yout,xout));

    % Fill output values
    out(uniqueInds+(c-1)*Hout*Wout) = vals(IA);
end

% Compare results
if compare
    figure;
    subplot(131); imshow(in); title('Input');
    subplot(132); imshow(imresize(in,scale,'nearest')); title('Nearest-neighbor');
    subplot(133); imshow(out); title('Crisp');
end



% OLD VERSION =============================================================
%     inMax = imdilate(inMax, strel('rectangle',round([1/scaleVer,1/scaleHor])));
%     ...
%     ...
%     if 0
%         out(indsNew) = vals;
%     else
%         [uniqueInds,IA] = unique(indsNew);
%         for i=1:numel(uniqueInds)
%             out(uniqueInds(i)) = max(vals(indsNew == uniqueInds(i)));
%         end
%         disp([num2str(numel(uniqueInds)) ' unique inds'])
%     end