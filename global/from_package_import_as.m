function[varargout] = from_package_import_as(package_name,varargin)
% from_package_import_as -- Pythonic "from ___ import ___ as" statement in Matlab
%
% [varname1, varname2, ...] = from_package_import_as(package_name, {name1, name2, ...})
%
%     Wordy copy of from_as.

if nargin==1
  error('You must provide at least two inputs');
elseif nargin==2
  if varargin{1}=='*'
    error('"from ___ import * as" is not a statement that makes sense to me');
  end
end

from_package_import(package_name,varargin{:});
varargout = cell([nargin 1]);
for q = 1:(nargin-1)
  varargout{q} = eval(varargin{q});  % Laziness breeds ugliness
end
