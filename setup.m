function[] = setup(varargin)
% [] = SETUP({parent_package_directory=./..})
%     Creates a global variable 'packages' that is used by various modules.
%
%     parent_package_directory is the parent directory containing all the
%     packages/modules. If not given, the packages are assumed to be in a
%     directory parallel to these setup tools.

clear global packages;
clear all
restoredefaultpath

warning('off', 'MATLAB:dispatcher:nameConflict');
fprintf('     ----------------------------------------------------------------------     \n')
fprintf('                           Warning from setuplab:                               \n')
fprintf(['        The following builtin MATLAB function is unavailable: import\n', ...
         '        Use instead builtin(''import'', str1, str2, ...).\n']);
fprintf('     ----------------------------------------------------------------------     \n')

if nargin==0
  parent_package_directory = '..';
else
  parent_package_directory = varargin{1};
end

[pathstr, garbage, garbage, garbage] = fileparts(mfilename('fullpath'));
addpath(fullfile(pathstr, 'global_temp'));  % Temporary setuplab stuff

global packages

names = find_modules(parent_package_directory);
presdir = pwd;
cd(parent_package_directory);

addpath(fullfile(pathstr, 'global'));  % All the Python magic

% Add setuplab first so FunctionNode is available
flags = strcmpi('setuplab', names);
if any(flags)
  q = find(flags);
  packages.setuplab = matlab_import(names{q});
  names(q) = [];
  fprintf('Found setuplab\n');
else
  rmpath(pwd);
  error('You must have setuplab installed...it is required for all packages');
end

for q = 1:length(names)
  fprintf(['  Found ' names{q} '\n']);
  packages.(names{q}) = matlab_import(names{q});
end

fprintf('Setup completed successfully\n');

cd(presdir);

rmpath(fullfile(pathstr, 'global_temp'));  % Temporary setuplab stuff

warning('on', 'MATLAB:dispatcher:nameConflict');
