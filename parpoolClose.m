% PARPOOLCLOSE Closes parpool workers
%
%   PARPOOLCLOSE()
%
%   See also: parpoolOpen, parpool
%
%   Stavros Tsogkas, <tsogkas@cs.toronto.ed>
%   Last update: January 2016

function parpoolClose(), delete(gcp('nocreate'));

