function name = machineName()
[~, name] = system('hostname');
name = name(1:end-1);