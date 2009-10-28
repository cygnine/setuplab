function[] = from_package_import(package_name,varargin)
% [] = from_package_import(package_name, {name1, name2, ...})
%
%     Wordy copy of from.

import_package('labtools');
global packages;

if nargin==1
  import_package(package_name);
  varvalue = eval(package_name);    % uuuuuuugly

  package_name = labtools.namestring_dissect(package_name);

  for qq = length(package_name):-1:2
    varvalue = struct(package_name{qq}, varvalue);
  end
  varname = package_name{1};
  assignin('caller', varname, varvalue);   
  return
end

if nargin==2
  if varargin{1}=='*';
    names = labtools.namestring_dissect(package_name);
    temp = packages;
    for q = 1:length(names)
      temp = getfield(temp, names{q});
    end
    names = fieldnames(temp);
    for q=1:length(names);
      value = getfield(temp,names{q});
      if strcmp(class(value), 'FunctionNode');
        value = value.handle;
      end
      assignin('caller', names{q}, value);
    end

    return
  end
end

names = labtools.namestring_dissect(package_name);
temp = packages;
for q = 1:length(names)
  temp = getfield(temp, names{q});
end

for q = 1:length(varargin)
  try
    node = getfield(temp, varargin{q});
    if strcmp(class(node), 'FunctionNode');
      node = node.handle;
    end
    assignin('caller', varargin{q}, node);
  catch
    str1 = 'Cannot find package/module/function ';
    str2 = ' in package ';
    error([str1 varargin{q} str2 package_name]);
  end
end
