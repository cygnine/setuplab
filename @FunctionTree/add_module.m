function[packages] = add_module(self, packages,  module_list, varargin)
% add_module -- Adds modules specified by module_list
%
% package = add_module(self, package, module_list, [[module_names={}]])
%
%     Given a cell array of character strings 'module_list', this function scans
%     the current directory (pwd) for subdirectories with those names. The input
%     'packages' should be a struct. The fields of 'packages' are set to the
%     subdirectory names in module_list, unless the optional module_names, a
%     cell array of the same size as module_list, is given. 

presdir = pwd;

if length(varargin)==1
  module_names = varargin{1};
elseif length(varargin)==0
  module_names = cell([length(module_list) 1]);
else
  error('Illegal number of inputs');
end

package_fields = fieldnames(packages);

for q = 1:length(module_list)
  module_dir = module_list{q};
  if isempty(module_names{q})
    module_name = module_dir;
  else
    module_name = module_names{q};
  end

  % Return empty list if module_dir doesn't exist
  try
    cd(module_dir)
  catch
    handles = [];
    warning(['Directory ' module_dir ' not found.']);
    continue
  end

  if any(strcmp(module_name, package_fields));
    warning(['Module ' module_dir ' in ' presdir ' is being overwritten']);
  end

  packages = setfield(packages, module_name, struct());
  %handles = struct();

  % if it's a module:
  if exist('init__.m', 'file')
    %packages = setfield(packages, module_name, init__());
    %info = setfield(packages, module_name, init__());
    info = PackageInfo(init__());
    if info.recurse_files
      packages = setfield(packages, module_name, ...
                 recurse_files(self, pwd, info.module_list));
    end
    pwd_addpath(self, info.addpaths{:});
  else
    packages = setfield(packages, module_name, recurse_files(self,pwd));
  end

  % Return to previous directory
  cd(presdir);

end
