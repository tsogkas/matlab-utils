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
sizea = size(A); 
sizeb = size(B); 
assert(sizea(2) == sizeb(1), 'Width of array A does not match height of array B')

% TODO: replace for loops with reshaping and matrix products    
% TODO: rename from mult3D to mtimes3D or similar    
if ismatrix(A) && ismatrix(B)
    C  = A * B;
elseif ismatrix(A)
    if sumThirdDimension
        C = A * B(:,:,1);
        for i=2:sizeb(3)
            C = C + A * B(:,:,i);
        end
    else
        C = zeros(sizea(1),sizeb(2),sizeb(3));
        for i=1:sizeb(3)
            C(:,:,i) = A * B(:,:,i);
        end
    end
elseif ismatrix(B)
    if sumThirdDimension
        C = A(:,:,1) * B;
        for i=2:sizea(3)
            C = C + A(:,:,i) * B;
        end
    else
        C = zeros(sizea(1),sizeb(2),sizea(3));
        for i=1:sizea(3)
            C(:,:,i) = A(:,:,i) * B;
        end
    end
else
    assert(sizea(3) == sizeb(3), 'Arrays must have the same number of channels')
    if sumThirdDimension
        C = A(:,:,1) * B(:,:,1);
        for i=2:sizea(3)
            C = C + A(:,:,i) * B(:,:,i);
        end
        % According to some crude tests, this is potentially ~80% faster
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
