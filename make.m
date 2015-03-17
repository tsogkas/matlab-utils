function make(target,debug)
% MAKE Simulates make functionality and facilitates mex-file compilation.
%
%   MAKE('all') builds the default 

narginchk(0,2);
if nargin < 1, target = 'all'; end
if nargin < 2
    debug = false;
else
    debug = (islogical(debug) && debug) || ...
             ismember(debug, {'debug','Debug','DEBUG','-d','-D'});
end

% Flags
verbose  = 0;
warnings = 0;

% Source files to be compiled and build directory
sourceDir = 'src';  
buildDir  = 'build'; 
sourceFiles = readSourceFiles(sourceDir);
sourceFiles = ['examples/dense_inference_mex.cpp', 'examples/common.cpp',...
    'examples/ppm.cpp', sourceFiles];

% Include directories and Link libraries
INCLUDEDIRS   = {'include','external','examples','/usr/local/eigen',...
    '/usr/local/lbfgs/include'};
LINKLIBS      = {'/usr/local/lbfgs/lib -llbfgs'};

% Optimization and other flags
CXXOPTIMFLAGS = ' CXXOPTIMFLAGS="-O3 -DNDEBUG -fopenmp"';
LDOPTIMFLAGS  = ' LDOPTIMFLAGS="-O3 -fopenmp"';
CXXFLAGS      = ' CXXFLAGS="\$CXXFLAGS -Wall"';
LDFLAGS       = ' LDFLAGS="\$LDFLAGS -Wall"';

switch target
    case 'all'
        % Build mex command
        mexcmd = 'mex';
        if debug
            mexcmd = [mexcmd ' -g'];
        else
            mexcmd = [mexcmd ' -O' CXXOPTIMFLAGS LDOPTIMFLAGS];
        end
        if verbose,  mexcmd = [mexcmd ' -v']; end
        if warnings, mexcmd = [mexcmd CXXFLAGS LDFLAGS]; end
        if isdir(buildDir), mexcmd = [mexcmd ' -outdir ' buildDir]; end
        mexcmd = [mexcmd ' -largeArrayDims'];
        mexcmd = addIncludeDirs(mexcmd, INCLUDEDIRS);
        mexcmd = addLinkLibs(mexcmd, LINKLIBS);
        mexcmd = addSourceFiles(mexcmd, sourceFiles);
        disp(['Creating ' buildDir 'directory']); mkdir(buildDir);
        disp(['Executing: ' mexcmd]); eval(mexcmd);
    case 'clean'
        deleteMexFiles(buildDir, sourceFiles)
    otherwise
        error('Invalid make target')
end


function mexcmd = addIncludeDirs(mexcmd, INCLUDEDIRS)
for i=1:numel(INCLUDEDIRS)
    mexcmd = [mexcmd ' -I' INCLUDEDIRS{i}];
end

function mexcmd = addLinkLibs(mexcmd, LINKLIBS)
for i=1:numel(LINKLIBS)
    mexcmd = [mexcmd ' -L' LINKLIBS{i}];
end

function mexcmd = addSourceFiles(mexcmd, sourceFiles)
%TODO: check if file exists already and if it has been changed 
for i=1:numel(sourceFiles)
    mexcmd = [mexcmd ' ' sourceFiles{i}];
end

function deleteMexFiles(buildDir, sourceFiles)
for i=1:numel(sourceFiles)
    [~,name] = fileparts(sourceFiles{i});
    mexFile  = [name mexext];
    delete(fullfile(buildDir, mexFile));
end

function sourceFiles = readSourceFiles(sourceDir)
sourceFiles = [dir([sourceDir '/*.cpp']); 
               dir([sourceDir '/*.cc']);
               dir([sourceDir '/*.c'])];
sourceFiles = {sourceFiles(:).name}; 
for i=1:numel(sourceFiles)
    sourceFiles{i} = fullfile(sourceDir, sourceFiles{i});
end
