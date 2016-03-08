function vmap = parseVarargin(args, validArgs, defaultValues)
% parseVarargin Get argument names and corresponding values when using
%   a variable number of input arguments (vargargin).
%
%   vmap = parseVarargin(args, validArgs, defaultValues)
%
%   INPUT:
%   args:      cell array with argument names and values (result of varargin)
%   validArgs: cell array with valid argument names
%
%   Example:
%   f = createCircle(varargin)
%       validArgs = {'radius','center'};
%       defaultValues = {10,[42,42]};
%       vmap = parseVarargin(varargin,validArgs,defaultValues);
%       ...   
%       ...   % The value used for radius will be vmap('radius') and the 
%       ...   % value used for center will be vmap('center').
%   end
%   
%   args can also be a struct, in which case validArgs must also be be a
%   struct. Args will hold the default options and the validArgs the new
%   values.
%
%   Stavros Tsogkas, <stavros.tsogkas@ecp.fr>
%   Last update: Mars 2016

if iscell(args)  % copy from varargin
    assert(iscell(validArgs) && iscell(defaultValues), ...
        'validArgs and defaultValues must be cell arrays');
    vmap = containers.Map(validArgs,defaultValues);
    if ~isempty(args)
        nArgs = length(args);
        assert(mod(nArgs,2) == 0, 'An even number of arguments is required (key/val pairs)')
        argNames = args(1:2:end);
        argVals  = args(2:2:end);
        for i=1:nArgs/2
            try
                assert(any(strcmp(argNames{i}, validArgs)))
                vmap(argNames{i}) = argVals{i};
            catch
                celldisp(validArgs,'Valid argument ');
                error(['''' argNames{i} ''' is an invalid argument name.'])
            end
        end
    end
elseif isstruct(args) % copy from struct
    % args will be the struct holding the default values and the second
    % argument (validArgs) will be the struct holding the new values
    assert(isstruct(validArgs), 'Both input arguments should be struct')
    opts = args;
    newOpts = validArgs;
    names = fieldnames(newOpts);
    for i=1:numel(names)
        opts.(names{i}) = newOpts.(names{i});
    end
    vmap = opts;
end