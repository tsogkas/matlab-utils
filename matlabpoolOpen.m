function matlabpoolOpen(n)
% MATLABPOOLOPEN Checks if matlabpool is already open before activating it.
%   By default, MATLABPOOLOPEN restricts the number of workers to the
%   number of available cpu cores.
%
%   MATLABPOOLOPEN()   opens matlabpool with #workers equal to the #cores.
%   MATLABPOOLOPEN(n)  opens matlabpool with n workers.
%
%   See also: matlabpoolClose, matlabpool
%
%   Stavros Tsogkas, <stavros.tsogkas@ecp.fr>
%   Last update: November 2014


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
if n > 1 && matlabpool('size') ~= n
    try
        if matlabpool('size') > 0  % close matlabpool if already open
            matlabpool('close');
        end
        matlabpool('open',n);
    catch
        warning('Could not open matlabpool.')
    end
end

