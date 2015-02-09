function out = resizeCrisp(in, scale, threshold, visualize)
    % RESIZECRISP Resize input image without blurring. 
    %   RESIZECRISP works the same way as Matlab's imresize function but
    %   without smearing and blurring its values because of interpolation
    %   when downsampling.Pixel coordinates in the input image are mapped 
    %   to coordinates in the output image. The value of a pixel in the 
    %   output image is the maximum of the values of all points in the 
    %   original image that are mapped to the same point in the output. 
    %   
    %   This function can be particularly useful when we want to resize
    %   thin structures, like boundary maps.
    %   RESIZECRISP only works for grayscale images at the moment when
    %   downsampling.
    %
    %   out = RESIZECRISP(in,scale) where scale is a scalar resizes an image
    %   so that size(output) = scale*size(input). If scale > 1, then
    %   RESIZECRISP calls MATLAB's imresize function to upsample the image.
    %   If scale < 1, the image is downsampled.
    %
    %   out = RESIZECRISP(in, [h,w]), resizes the input image in, so that
    %   to dimensions [h,w].
    
    if nargin < 3, threshold = 0.1; end
    if nargin < 4, visualize = false; end
    
    if isscalar(scale)  % scaling factor
        if scale == 1   
            out = in;
            return
        elseif scale > 1
            out = imresize(in,scale,'bilinear');
            return
        end
        [h,w,~]  = size(in);
        scaleHor = scale;
        scaleVer = scale;
        hnew     = round(h*scaleVer);
        wnew     = round(w*scaleHor);
    elseif numel(scale) == 2
        if scale(1) > size(in,1)
            in = imresize(in,[scale(1), size(in,2)],'bilinear');
        end
        if scale(2) > size(in,2)
            in = imresize(in,[size(in,1), scale(2)],'bilinear');
        end
        [h,w,~]  = size(in);
        hnew     = scale(1);
        wnew     = scale(2);        
        scaleHor = wnew / w;
        scaleVer = hnew / h;
    else
        error('scale must be a scalar or a [height, width] vector')
    end
    
    
    
    % Original coordinates of thresholded image
    inThresh = in; inThresh(inThresh <= threshold) = 0;
    inMax = inThresh;
    [y,x] = find(inMax > threshold);
    inds  = sub2ind([h,w],y,x);
    vals  = inMax(inds);
    
    
    % Map to new coordinates
    ynew = ceil(y*scaleVer);
    xnew = ceil(x*scaleHor);
    offLimits = xnew > wnew | ynew > hnew | xnew < 1 | ynew < 1;
    xnew(offLimits) = [];   % remove indices that fall outside of the image
    ynew(offLimits) = [];
    vals(offLimits) = [];
    
    % We sort all values first to automatically obtain the max value
    % for each mapped point later: 'unique' returns indexes IA which point 
    % to the first occurence of each element. If vals is sorted, that index
    % corresponds to the maximum value for that pixel by default.
    [vals, indSort] = sort(vals,'descend');
    xnew = xnew(indSort); ynew = ynew(indSort);
    indsNew = sub2ind([hnew,wnew],ynew,xnew);
    
    % Fill in values in resized output
    out = zeros(hnew,wnew);
    [uniqueInds,IA] = unique(indsNew);
    out(uniqueInds) = vals(IA);
    
    % Visualize results
    if visualize
        figure;
        subplot(221); imshow(in); title('original');
        subplot(222); imshow(inThresh); title('thresholded'); 
        subplot(223); imshow(inMax); title('maximum');
        subplot(224); imshow(out); title('output'); 
    end
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