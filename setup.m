function[] = setup(varargin)
% [] = SETUP({parent_package_directory=./..})
%     Creates a global variable 'packages' that is used by various modules.
%
%     parent_package_directory is the parent directory containing all the
%     packages/modules. If not given, the packages are assumed to be in a
%     directory parallel to these setup tools.

if nargin==0
  parent_package_directory = '..';
else
  parent_package_directory = varargin{1};
end

% Temporarily add pwd to the path (for utility files)
addpath(pwd);

global packages

names = find_modules(parent_package_directory);

% Need labtools to continue
flags = strcmpi('labtools', names);
if any(flags)
  q = find(flags);
  packages.labtools = matlab_import(names{q});
  names(q) = [];
  fprintf('Found labtools\n');
else
  rmpath(pwd);
  Error('You must have labtools installed...it is required for all packages');
end

for q = 1:length(names)
  fprintf(['  Found ' names{q} '\n']);
  packages.(names{q}) = matlab_import(names{q});
end

fprintf('Setup completed successfully\n');

rmpath(pwd);
