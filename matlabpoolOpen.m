% MATLABPOOLOPEN Checks if matlabpool is already open before activating it.
% 
%   MATLABPOOLOPEN()   opens matlabpool with 4 workers.
%   MATLABPOOLOPEN(n)  opens matlabpool with n workers.
% 
%   See also: matlabpoolClose, matlabpool
%
%   Stavros Tsogkas, <stavros.tsogkas@ecp.fr>
%   Last update: November 2014


function matlabpoolOpen(n)
    if nargin == 0, n = 4; end
    if matlabpool('size') ~= n
        try
            if matlabpool('size') > 0  % close matlabpool if already open
                matlabpool('close');
            end
            matlabpool('open',n);
        catch
            warning('Could not open matlabpool.')
        end
    end    
end

