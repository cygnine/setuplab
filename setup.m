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

if nargin==0
  %parent_package_directory = '..';
  parent_package_directory = mfilename('fullpath');
  [parent_package_directory, garbage, garbage, garbage] = fileparts(parent_package_directory);
  temp_ind = strfind(parent_package_directory, filesep);
  parent_package_directory = parent_package_directory(1:temp_ind(end));
else
  parent_package_directory = varargin{1};
end

[pathstr, garbage, garbage, garbage] = fileparts(mfilename('fullpath'));
addpath(fullfile(pathstr, 'global_temp'));  % Temporary setuplab stuff

global packages
packages = initialize_packages();

names = find_modules(parent_package_directory);
presdir = pwd;
cd(parent_package_directory);

addpath(fullfile(pathstr, 'global'));  % All the Python magic

% Add setuplab first so FunctionNode is available
flags = strcmpi('setuplab', names);
if any(flags)
  q = find(flags);
  %packages.setuplab = matlab_import(names{q});
  packages = add_module(packages, names(q));
  %packages.setuplab = matlab_import(names{q});
  names(q) = [];
  fprintf('Found setuplab\n');
else
  rmpath(fullfile(pathstr, 'global_temp'));
  rmpath(fullfile(pathstr, 'global'));
  error('You must have setuplab files available...they are required for all packages');
end

for q = 1:length(names)
  fprintf(['  Found ' names{q} '\n']);
  %packages.(names{q}) = matlab_import(names{q});
  packages = add_module(packages, names(q));
end

%%%%% For legacy code:
global handles
handles = extract_handles(packages);

fprintf('Setup completed successfully\n');

cd(presdir);

rmpath(fullfile(pathstr, 'global_temp'));  % Temporary setuplab stuff

warning('on', 'MATLAB:dispatcher:nameConflict');
