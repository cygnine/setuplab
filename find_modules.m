function[modules] = find_modules(varargin)
% find_modules -- returns string names for subdirectories that are modules
%
% modules = find_modules({parent_directory=pwd})
%
%     Returns a cell array of string names for subdirectories of
%     parent_directory that are modules (i.e. subdirectories that contain an
%     init__.m file). If parent_directory is not given, it is assumed to be pwd.

if nargin==0
  parent_directory = pwd;
else
  parent_directory = varargin{1};
end

all_files = dir(parent_directory);
modules = {};

exceptions = {'.', '..'};

for n = 1:length(all_files);
  % If this is a subdirectory (that's not "." or "..")
  if all_files(n).isdir & not(any(strcmpi(all_files(n).name, exceptions)))
    % If this subdirectory has an "init__.m" file
    if exist(fullfile(parent_directory, all_files(n).name, 'init__.m'));
      modules{end+1} = all_files(n).name;
    end
  end
end
