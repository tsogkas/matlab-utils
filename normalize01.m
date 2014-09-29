% NORMALIZE01 Normalize vector or matrix in [0,1]
%   out = NORMALIZE01(in)
%   out = NORMALIZE01(in,dim) normalizes input array over given dimension
% 
% Stavros Tsogkas <stavros.tsogkas@ecp.fr>
% Last update: March 2014


function out = normalize01(in, dim)

if nargin<2
    mn = min(in(:));
    mx = max(in(:));
    if abs(mn - mx) < 1e-6
        out = in-mn+0.5; 
    else
        out = (in-mn) / (mx-mn);
    end
else
    warning('This option has not been tested!')
    assert(dim <= 2,'Selected dimension is not currently supported. Dim can be either 1 or 2')
    mn = min(in,[],dim);
    mx = max(in,[],dim);
    coeff = mx-mn; 
    ind = abs(coeff) < 1e-6; 
    coeff(ind) = 1;
    out = bsxfun(@rdivide,bsxfun(@minus,in,mn), coeff);
    if dim == 1
        out(:,ind) = 0.5;
    elseif dim == 2
        out(ind,:) = 0.5;
    end
end
