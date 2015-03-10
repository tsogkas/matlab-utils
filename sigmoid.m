function y = sigmoid(x)
% SIGMOID Sigmoid function
%  y = SIGMOID(x) returns y = 1 ./ (1 + EXP(x)).
%
%  Useful properties of the sigmoid function are:
%
%  -  1 - SIGMOID(X) = SIGMOID(-x)
%  -  Centered sigmoid: 2 * SIGMOID(x) - 1 ;
%  -  SIGMOID(x) = (EXP(x/2) - EXP(x/2)) / (EXP(x/2) + EXP(x/2))
% 
%  See also: exp
%
% Documentation taken from VLFeat function VL_SIGMOID.

y = 1 ./ (1 + exp(-x)) ;
