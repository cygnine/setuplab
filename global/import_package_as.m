function[varargout] = import_package_as(varargin)
% import_package_as -- Pythonic "import ____ as" statement in Matlab
%
% [varname1, varname2, ...] = import_package_as(package_name1, package_name2, ...)
%
%     Wordy copy of imp_as.

global packages;
varargout = cell([nargin 1]);

for q = 1:nargin
  import_package(varargin{q});
  varargout{q} = eval(varargin{q}); % Laziness breeds ugliness
end
