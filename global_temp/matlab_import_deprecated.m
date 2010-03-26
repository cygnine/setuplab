function[handles] = matlab_import(module_dir);
% matlab_import -- imports 'modules' from subdirectories
%
%     Simulates Python's "import" function. Used to import modules in the global
%     path spec module_dir. Imports them as a structure of FunctionNode's.
%
%     module_dir is a string with the global name of a directory, or the name of
%     a subdirectory local to pwd.
%
%     A `module' is a subdirectory with an init__.m file. 

presdir = pwd;

% Return empty list if module_dir doesn't exist
try
  cd(module_dir)
catch
  handles = [];
  warning(['Directory ' module_dir ' not found.']);
  return;
end

handles = struct();

% if it's a module:
if exist('init__.m', 'file')
  handles = init__();
else
  handles = recurse_files(pwd);
end
handles.warning__ = 'This is a deprecated package/module';

% Return to previous directory
cd(presdir);
