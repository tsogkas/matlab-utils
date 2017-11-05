function parsave(matfilePath, varargin)
% PARSAVE Save variables in a mat-file inside a parfor loop.
% 
%   PARSAVE(matfilePath, varargin) saves an arbitrary number of input
%   variables in matfilePath. Note that, contrary to the built-in SAVE
%   function, the user must provide the actual variables as inputs, rather
%   than strings corresponding to their names.
% 
% 
%   See also SAVE, INPUTNAME.
% 
% Stavros Tsogkas, <tsogkas@cs.toronto.edu>
% Last update: November 2017

for i=1:numel(varargin)
    s.(inputname(i+1)) = varargin{i};
end
save(matfilePath, '-struct', 's')