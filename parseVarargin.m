function vmap = parseVarargin(defaultArgs, args)
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
%   Stavros Tsogkas, <tsogkas@cs.toronto.edu>
%   Last update: January 2017


% Get default arguments and values
[dargs,dvals] = getKeyValPairs(defaultArgs);
vmap = containers.Map(dargs,dvals);

% Get input arguments and values
[iargs,ivals] = getKeyValPairs(args);

% Replace default values with user input
for i=1:numel(iargs)
    if vmap.isKey(iargs{i})
        vmap(iargs{i}) = ivals{i};
    else
        celldisp(vmap.keys, 'Valid argument ');
        error(['''' iargs{i} ''' is an invalid argument name.'])
    end
end

% Return the key/val pairs in the requested form

function [keys,vals] = getKeyValPairs(args)
if iscell(args)
    assert(mod(numel(args),2)==0, ...
        'Odd length: input should be a list of key/val pairs')
    keys = args(1:2:end-1);
    vals = args(2:2:end);
elseif isstruct(args)
    keys = fieldnames(args); % returns cell array
    vals = struct2cell(args);
else error('Input should be a cell array or a struct')
end



% function vmap = parseVarargin(args, validArgs, defaultValues)
% % parseVarargin Get argument names and corresponding values when using
% %   a variable number of input arguments (vargargin).
% %
% %   vmap = parseVarargin(args, validArgs, defaultValues)
% %
% %   INPUT:
% %   args:      cell array with argument names and values (result of varargin)
% %   validArgs: cell array with valid argument names
% %
% %   Example:
% %   f = createCircle(varargin)
% %       validArgs = {'radius','center'};
% %       defaultValues = {10,[42,42]};
% %       vmap = parseVarargin(varargin,validArgs,defaultValues);
% %       ...   
% %       ...   % The value used for radius will be vmap('radius') and the 
% %       ...   % value used for center will be vmap('center').
% %   end
% %   
% %   args can also be a struct, in which case validArgs must also be be a
% %   struct. Args will hold the default options and the validArgs the new
% %   values.
% %
% %   Stavros Tsogkas, <stavros.tsogkas@ecp.fr>
% %   Last update: Mars 2016
% 
% if iscell(args)  % copy from varargin
%     assert(iscell(validArgs) && iscell(defaultValues), ...
%         'validArgs and defaultValues must be cell arrays');
%     vmap = containers.Map(validArgs,defaultValues);
%     if ~isempty(args)
%         nArgs = length(args);
%         assert(mod(nArgs,2) == 0, 'An even number of arguments is required (key/val pairs)')
%         argNames = args(1:2:end);
%         argVals  = args(2:2:end);
%         for i=1:nArgs/2
%             try
%                 assert(any(strcmp(argNames{i}, validArgs)))
%                 vmap(argNames{i}) = argVals{i};
%             catch
%                 celldisp(validArgs,'Valid argument ');
%                 error(['''' argNames{i} ''' is an invalid argument name.'])
%             end
%         end
%     end
% elseif isstruct(args) % copy from struct
%     % args will be the struct holding the default values and the second
%     % argument (validArgs) will be the struct holding the new values
%     assert(isstruct(validArgs), 'Both input arguments should be struct')
%     opts = args;
%     newOpts = validArgs;
%     names = fieldnames(newOpts);
%     for i=1:numel(names)
%         opts.(names{i}) = newOpts.(names{i});
%     end
%     vmap = opts;
% end