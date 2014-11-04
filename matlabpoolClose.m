% MATLABPOOLCLOSE Closes matlabpool and throws a warning in case of failure.
% 
%   Stavros Tsogkas, <stavros.tsogkas@ecp.fr>
%   Last update: November 2014


function matlabpoolClose()
    if matlabpool('size')
        try
            matlabpool('close');
        catch
            warning('Could not close matlabpool');
        end
    end
end

