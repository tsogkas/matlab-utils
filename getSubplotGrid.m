% GETSUBPLOTGRID  Find the optimal number of rows and columns for a square
% subplot grid.
%
%   [nrows, ncols] = GETSUBPLOTGRID(n)
%
% Stavros Tsogkas, <stavros.tsogkas@ecp.fr>
% Last update: October 2014


function [nrows, ncols] = getSubplotGrid(n)

sqRoot = round(sqrt(n)); % initial estimation of grid size
product = [sqRoot^2, sqRoot*(sqRoot-1), sqRoot*(sqRoot+1), (sqRoot+1)*(sqRoot-1)];
product(product < n) = inf;
d = n-product;
[~,ind] = min(abs(d));
switch ind
    case 1
        ncols = sqRoot;
        nrows = sqRoot;
    case 2
        ncols = sqRoot;
        nrows = sqRoot-1;
    case 3
        ncols = sqRoot+1;
        nrows = sqRoot;
    case 4
        ncols = sqRoot+1;
        nrows = sqRoot-1;
end
assert(nrows*ncols >= n, 'Not enough grid elements')