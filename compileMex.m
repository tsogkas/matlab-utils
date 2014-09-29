% COMPILEMEX Build MEX source code for a .cc/.cpp/.c file or all files in a
% given folder
%
%   compileMex(fileName,optimize,verbose)
%
% INPUT:
%   fileName:   build a specific source file or all files in a directory
%   optimize:   compile with optimizations (default: on)
%   verbose:    verbose output (default: off)
% 
% Stavros Tsogkas <stavros.tsogkas@ecp.fr>
% Last update: March 2014


function compileMex(fileName, optimize, verbose)

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
    mexcmd = [mexcmd ' -outdir ' fileparts(fileName)];
    eval([mexcmd ' ' fileName]);
end
