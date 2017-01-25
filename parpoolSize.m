function n = parpoolSize()
% PARPOOLOPEN Returns the number of parpool workers if parpool is open.
% 
%   See also: parpoolClose, parpoolOpen, parpool
%
%   Stavros Tsogkas, <tsogkas@cs.toronto.edu>
%   Last update: January 2017

poolobj = gcp('nocreate');
if isempty(poolobj)
    n = 0;
else
    n = poolobj.NumWorkers;
end
