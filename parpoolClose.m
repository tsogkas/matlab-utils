% PARPOOLCLOSE Closes parpool workers
%
%   PARPOOLCLOSE()
%
%   See also: parpoolOpen, parpool
%
%   Stavros Tsogkas, <tsogkas@cs.toronto.ed>
%   Last update: January 2017

function parpoolClose(), delete(gcp('nocreate'));

