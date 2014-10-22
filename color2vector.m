% COLOR2VECTOR Turns string input into corresponding rgb color vector (supports basic
% colors).
% 
%   v = COLOR2VECTOR(color)
%   color: 'r'/'red' --> [1 0 0]
%          'b'/'blue'--> [0 1 0] etc...
% 
% Stavros Tsogkas, <stavros.tsogkas@ecp.fr>
% Last update: October 2014

function v = color2vector(color)

assert(ischar(color),'input must be a string or a single char');
switch color
    case {'r','red'}
        v = [1 0 0];
    case {'b','blue'}
        v = [0 0 1];
    case {'g','green'}
        v = [0 1 0];
    case {'y','yellow'}
        v = [1 1 0];
    case {'m','magenta'}
        v = [1 0 1];
    case {'c','cyan'}
        v = [0 1 1];
    case {'w','white'}
        v = [1 1 1];
    case {'k','black'}
        v = [0 0 0];
    case {'n','navy'}
        v = [0 0 .5];
    case {'ol','olive'}
        v = [.5 .5 0];
    case {'o','orange'}
        v = [1 .647 0];
    case {'maroon'}
        v = [.5 0 0];
    case {'p','purple'}
        v = [.5 0 .5];
    case {'s','silver'}
        v = [.75 .75 .75];
    case {'l','gold'}
        v = [1 .843 0];
    otherwise
        error(['Color not supported. Valid colors are: red, blue, green, ',...
            'yellow, magenta, cyan, white, black, navy, olive, orange, ',...
            'maroon, purple, silver, gold.'])
end