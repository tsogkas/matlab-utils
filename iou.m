% IOU Calculate intersection over union similarity measure of two binary
% masks. The two masks should have the same dimensions.
%
%   d = iou(mask1,mask2)
%
% Stavros Tsogkas, January 2012
% <stavros.tsogkas@ecp.fr>

function d = iou(mask1,mask2)

if ismatrix(mask1) && ismatrix(mask2) % input is binary masks
    assert(isequal(size(mask1),size(mask2)),'Masks must have the same dimensions')
    u = nnz(mask1 | mask2);
    if u > 0
        d = nnz(mask1 & mask2) / u;
    else
        d = 0;
    end
elseif length(mask1) == 4 && length(mask2) == 4 % input is bounding boxes
    bi = [max(mask1(1), mask2(1)); max(mask1(2), mask2(2));...
          min(mask1(3), mask2(3)); min(mask1(4), mask2(4))];
    iw = bi(3)-bi(1)+1;
    ih = bi(4)-bi(2)+1;
    if iw>0 && ih>0
        % compute overlap as area of intersection / area of union
        ua=(mask1(3)-mask1(1)+1)*(mask1(4)-mask1(2)+1)+...
            (mask2(3)-mask2(1)+1)*(mask2(4)-mask2(2)+1)-...
            iw*ih;
        d=iw*ih/ua;
    else
        d = 0;
    end
else
    error('Input must be two logical masks or two bounding box coordinates')
end
