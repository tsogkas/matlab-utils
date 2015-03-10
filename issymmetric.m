function res = issymmetric(A)
% ISSYMMETRIC Check if input matrix is symmetric (returns true or false).
% 
% Stavros Tsogkas, <stavros.tsogkas@centralesupelec.fr>
% Last update: March 2015 

assert(ismatrix(A), 'A is not a matrix');
res = isequal(A, A');
