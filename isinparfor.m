function res = isinparfor()
% ISINPARFOR Checks if current function is executed inside a parfor loop

warning('This function has not been tested')
res = ~isempty(getCurrentTask());

