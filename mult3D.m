function C = mult3D(A,B,sumThirdDimension)
% MULT3D Multiply 3D arrays and (optionally) sum over the third dimension.
%  
%   C = MULT3D(A,B), where A is a MxNxL array and B is a NxKxL array, 
%   creates a new MxKxL array C, whose i-th channel is the matrix product 
%   between the i-th channel of A and B. If B is a NxK matrix, then C's 
%   i-th channel is the matrix product of the i-th channel of A with B.
% 
%   C = MULT3D(A,B,sumThirdDimension), if sumThirdDimension is true, then
%   C is a MxK matrix that stores the sum of matrix products over the third
%   dimension (essentially C = sum(mult3D(A,B,false),3) - but without
%   creating an intermediate MxKxL array to store the result)
% 
% See also: mtimes
% 
% Stavros Tsogkas, <stavros.tsogkas@centralesupelec.fr>
% Last update: March 2015 

if nargin < 3, sumThirdDimension = false; end
assert(ndims(A) <= 3 && ndims(B) <= 3, 'Only matrices or 3D arrays supported')
sizea = size(A); if numel(sizea) == 2, sizea(3) = 1; end
sizeb = size(B); if numel(sizeb) == 2, sizeb(3) = 1; end
assert(sizea(2) == sizeb(1), 'Width of array A does not match height of array B')

% TODO: replace for loops with reshaping and matrix products    
% TODO: rename from mult3D to mtimes3D or similar    
if sizea(3) == sizeb(3)     % MxNxL * NxKxL (3D * 3D)
    if sizeb(3) == 1        % trivial case - matrix product
        C  = A * B;
    else
        if sumThirdDimension
            C = zeros(sizea(1),sizeb(2));
            for i=1:sizea(3)
                C = C + A(:,:,i) * B(:,:,i);
            end
%             tmp = mat2cell(B, sizeb(1),sizeb(2),ones(sizeb(3),1));
%             B = cat(1, tmp{:});
%             A = reshape(A, sizea(1),sizea(2)*sizea(3));
%             C = A * B;
        else
            C = zeros(sizea(1),sizeb(2),sizea(3));
            for i=1:sizea(3)
                C(:,:,i) = A(:,:,i) * B(:,:,i);
            end
        end
    end
else
    if sizeb(3) == 1       % MxNxL * NxK  (3D * 2D)
        if sumThirdDimension
            C = zeros(sizea(1),sizeb(2));
            for i=1:sizea(3)
                C = C + A(:,:,i) * B;
            end
        else
            C = zeros(sizea(1),sizeb(2),sizea(3));
            for i=1:sizea(3)
                C(:,:,i) = A(:,:,i) * B;
            end
        end
    elseif sizea(3) == 1    % MxN * NxKxL  (2D * 3D)
        if sumThirdDimension
            C = zeros(sizea(1),sizeb(2));
            for i=1:sizeb(3)
                C = C + A * B(:,:,i);
            end
        else
            C = zeros(sizea(1),sizeb(2),sizeb(3));
            for i=1:sizea(3)
                C(:,:,i) = A * B(:,:,i);
            end
        end        
    else
        error('Inputs must be either matrices or arrays with the same number of channels')
    end
end
