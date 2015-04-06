function res = isinparfor()
% ISINPARFOR Checks if current function is executed inside a parfor loop

res = ~isempty(getCurrentTask());

