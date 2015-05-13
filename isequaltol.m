function res = isequaltol(a,b,tol)
% ISEQUALTOL Test approximate equality (using Frobenius norm)
%
% See also: norm
%
% Stavros Tsogkas, <stavros.tsogkas@ecp.fr>
% Last update: March 2015 

% TODO: add norm choice through and additional argument
if nargin < 3, tol = 1e-5; end
res = norm(a(:)-b(:),'fro') < tol;
