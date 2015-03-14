function res = isintegern(x)
% ISINTEGERN Checks if input is integer (no decimal part).
%   This function is different than the built-in Matlab function ISINTEGER,
%   that checks if the inpup is of an integer class (int, uint).
% 
% See also: isinteger
% 
% Stavros Tsogkas, <stavros.tsogkas@centralesupelec.fr>
% Last update: March 2015 

res = ~mod(x,1);


