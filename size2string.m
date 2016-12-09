function [str, sizeInBytes] = size2string(n,dtype)
%  SIZE2STRING prints the size in RAM in human-readably format.
% 
%   s = size2string(n,dtype) where n is the number of elements and type is
%   the data type ('double','single','int32', etc).
% 
%   Stavros Tsogkas <tsogkas@cs.toronto.edu>
%   Last update: November 2016

if isscalar(n) 
    if nargin < 2, dtype = 'double'; end
elseif isnumeric(n) || islogical(n)
    dtype = class(n); % we must get class before turning n into #elements!
    n = numel(n); 
else error('size2string only supports scalars or arrays as input')
end


switch  dtype
    case {'double','uint64','int64'}
        sizeOfElementInBytes = 8;
    case {'single','uint32','int32'}
        sizeOfElementInBytes = 4;
    case {'uint16','int16'}
        sizeOfElementInBytes = 2;
    case {'uint8','int8','char'}
        sizeOfElementInBytes = 1;
    case {'logical'}
        sizeOfElementInBytes = 1/8;
    otherwise, error('Data type not supported')
end

sizeInBytes = sizeOfElementInBytes * n;

KB = 1024;
MB = 1024^2;
GB = 1024^3;
if sizeInBytes < KB 
    str = [num2str(sizeInBytes) ' B'];
elseif sizeInBytes < MB
    str = [num2str(sizeInBytes/KB) ' KB'];
elseif sizeInBytes < GB
    str = [num2str(sizeInBytes/MB) ' MB'];
else
    str = [num2str(sizeInBytes/GB) ' GB'];
end
