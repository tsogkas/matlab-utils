function progress(msg, iter, nIter, ticStart, dispStep)
% PROGRESS  Display progress of a loop
%   Before entering the loop, perform a "tic" operation and pass its value
%   to progress as an input. This will help estimate the time spent so far
%   and the time spent per loop iteration, without using global variables.
%   The progress function call should be placed at the end of the loop
%   iteration. 
% 
%   PROGRESS(msg, iter, nIter, ticStart, dispStep)
% 
% INPUT:
%   msg:  message to display
%   iter: current iteration of the loop
%   nIter:total number of loop iterations
%   ticStart: 
%   
%   EXAMPLE:
%   --------------------------------------
%   ticStart = tic; 
%   for i=1:nIter
%       .
%       .
%       .
%       progress(msg, i, nIter, ticStart)
%   end
% 
% See also: tic, toc
% 
% Stavros Tsogkas, <stavros.tsogkas@centralesupelec.fr>
% Last update: May 2016 

    if nargin < 5, dispStep = 0; end   % display progress (approximately)
    timeElapsed = toc(ticStart);       % every dispStep seconds
    timePerIter = timeElapsed / iter;
    timeLeft    = (nIter - iter) * timePerIter;
        
    if dispStep < 0  % Print at each iteration without additional info
        disp([msg, sprintf('Iteration %d/%d.',iter,nIter)]);
    elseif dispStep == 0 % Print at each iteration with ETR
        msg = [msg, sprintf('Iteration %d/%d (%.1f%%). ETR: ', iter, nIter, 100*iter/nIter)];
        disp(addTimeLeft(msg,timeLeft));
    elseif iter == nIter
        fprintf('Done! '); toc(ticStart); return       
    elseif (mod((iter-1)*timePerIter, dispStep) - mod(iter*timePerIter, dispStep)) > 0
        msg = [msg, sprintf(' %.1f%%. ETR: ', 100*iter/nIter)];
        disp(addTimeLeft(msg,timeLeft)); % Print percentage completed and ETR
    end
end
    
    
function msg = addTimeLeft(msg, timeLeft) 
    if timeLeft / 3600 > 1
        msg = [msg, sprintf('%.1f h',   timeLeft / 3600)];
    elseif timeLeft / 60 > 1
        msg = [msg, sprintf('%.1f min', timeLeft / 60)];
    else
        msg = [msg, sprintf('%.1f sec', timeLeft)];
    end
end
