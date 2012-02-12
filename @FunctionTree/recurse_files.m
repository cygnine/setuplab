function[handles] = recurse_files(self, varargin);
% recurse_files -- creates FunctionNode structure from m-files
%
%     Traverses all m-files in the global directory string varargin{1} and
%     returns a structure with FunctionNode vertices for them. If varargin{1} is
%     empty, uses pwd.

presdir = pwd;

if nargin==1
  pwdir = pwd;
  module_list = {};
  module_names = cell([length(module_list) 1]);
elseif nargin==2
  pwdir = varargin{1};
  module_list = {};
  module_names = cell([length(module_list) 1]);
elseif nargin==3
  pwdir = varargin{1};
  module_list = varargin{2};
  module_names = cell([length(module_list) 1]);
elseif nargin==4
  pwdir = varargin{1};
  module_list = varargin{2};
  module_names = varargin{3};
end

% Return empty list if subdir doesn't exist
try
  %cd(pwdir)
catch
  handles = [];
  warning(['Directory ' pwdir ' not found.']);
  return;
end

handles = struct();

% Don't add these to the file list
exceptions = {'handles__', 'init__'};

% Recurse all m-files in this directory
mfile_list = dir(fullfile(pwdir,'*.m'));
for n = 1:length(mfile_list)
  mfile_name = mfile_list(n).name(1:end-2);
  if not(any(strcmpi(mfile_name, exceptions)))
    handles = setfield(handles, mfile_name, ...
       FunctionNode(str2func(mfile_name), mfile_name, pwd));
  end
end

handles = add_module(self, handles, module_list, module_names);

% Return to original path
%cd(presdir);
