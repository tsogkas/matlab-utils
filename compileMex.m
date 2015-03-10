function compileMex(fileName, optimize, verbose)
% COMPILEMEX Build MEX source code for a .cc/.cpp/.c file or all files in a
% given folder
%
%   compileMex(fileName,optimize,verbose)
%
% INPUT:
%   fileName:   build a specific source file or all files in a directory
%   optimize:   compile with optimizations (default: true)
%   verbose:    verbose output (default: false)
% 
% Stavros Tsogkas <stavros.tsogkas@ecp.fr>
% Last update: March 2014


if nargin < 2, optimize = true;  end
if nargin < 3, verbose  = false; end

% Start building the mex command
mexcmd = 'mex ';

% Add verbosity if requested
if verbose, mexcmd = [mexcmd ' -v']; end

% Add optimizations if requested
if optimize
    mexcmd = [mexcmd ' -O'];
    mexcmd = [mexcmd ' CXXOPTIMFLAGS="-O3 -DNDEBUG -fopenmp"'];
    mexcmd = [mexcmd ' LDOPTIMFLAGS="-O3 -fopenmp"'];
else
    mexcmd = [mexcmd ' -g'];
end

% Turn all warnings on
mexcmd = [mexcmd ' CXXFLAGS="\$CXXFLAGS -Wall"'];
mexcmd = [mexcmd ' LDFLAGS="\$LDFLAGS -Wall"'];

if isdir(fileName)
    mexcmd = [mexcmd ' -outdir ' fileName];
    sourceFiles = [dir(fullfile(fileName,'*.cpp')); ... % include all c/c++ 
                   dir(fullfile(fileName,'*.cc')); ...  % source files
                   dir(fullfile(fileName,'*.c'))];
    for i=1:length(sourceFiles)
        eval([mexcmd ' ' fullfile(fileName,sourceFiles(i).name)]);
    end
else
    outdir = fileparts(fileName);
    % we handle the case where function is called as compileMex('file.cpp')
    % and not compileMex('./file.cpp');
    if isempty(outdir), outdir = '.'; end 
    mexcmd = [mexcmd ' -outdir ' outdir];
    eval([mexcmd ' ' fileName]);
end
