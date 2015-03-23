function p = softmax(x)
%SOFTMAX Softmax function that avoids overflow.
% 
%   P = SOFTMAX(X), X can be a vector, a matrix, or a MxNxK array. If X is
%   a matrix, SOFTMAX calculates the softmax along the first dimension
%   (matrix columns). If X is a MxNxK array, it calculates the softmax
%   along the third dimension.
% 
% See also: exp, bsxfun
% 
% Stavros Tsogkas, <stavros.tsogkas@centralesupelec.fr>
% Last update: March 2015 

if isvector(x) 
    expx = exp(x-max(x));
    p = expx ./ sum(expx);
elseif ismatrix(x)
    expx = exp(bsxfun(@minus, x, max(x,[],1)));
    p = bsxfun(@rdivide, expx, sum(expx,1));
elseif size(x,3) > 1
    expx = exp(bsxfun(@minus, x, max(x,[],3)));
    p = bsxfun(@rdivide, expx, sum(expx,3));
else
    error('Input must be either a vector, a matrix, or a MxNxK array')
end


