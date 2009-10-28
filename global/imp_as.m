function[varargout] = import_as(varargin)
% import_as -- Pythonic "import ____ as" statement in Matlab
%
% [varname1, varname2, ...] = import_as(package_name1, package_name2, ...)
%
%     Outputs the packages/modules/files specified by package_name1,
%     package_name2, etc.

global packages;
varargout = cell([nargin 1]);

for q = 1:nargin
  import_package(varargin{q});
  varargout{q} = eval(varargin{q}); % Laziness breeds ugliness
end
