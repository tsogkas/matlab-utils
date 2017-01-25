function parpoolOpen(n)
% PARPOOLOPEN Checks if parpool is already open before activating it.
%   By default, PARPOOLOPEN restricts the number of workers to the
%   number of available cpu cores.
%
%   PARPOOLOPEN()   opens parpool with #workers equal to the #cores.
%   PARPOOLOPEN(n)  opens parpool with n workers.
%
%   See also: parpoolClose, parpool
%
%   Stavros Tsogkas, <tsogkas@cs.toronto.edu>
%   Last update: January 2017


nCores = feature('numcores');  % some undocumented secret sauce ;)

% We add the case where n < 0, to handle the case where the user must pass
% an input argument but still wants to be able to fall back to the default 
% choice (using #workers = #cores)
if nargin == 0 || n > nCores || n < 0,
    warning(['Number of workers requested was not specified or exceeds the '...
             'number of available cores. Will open matlabpool with '...
             '#workers = #cores (%d)'], nCores)
    n = nCores; 
end

% Get number of active workers, if any
poolobj = gcp('nocreate');
if isempty(poolobj)
    poolsize = 0;
else
    poolsize = poolobj.NumWorkers;
end

if n > 1 && poolsize ~= n
    try
        if poolsize > 0  % close parpool if already open
            delete(poolobj);
        end
        parpool('local',n);
    catch
        warning('Could not open parpool with %d workers.', n)
    end
end

