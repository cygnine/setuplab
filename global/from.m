function[] = from(package_name,varargin)
% [] = from(package_name, {name1, name2, ...})
%
%     Adds the function/modules specified in the varargin cell array to the
%     caller workspace. This function imports pure function handles, not
%     FunctionNode classes. However, it uses the super-ugly, poor-form assignin
%     function.
%
%     If varargin is empty, calls get_package(package).
%
%     If varargin{1} == '*', imports ALL the fields of package_name into the
%     caller workspace. Clearly you should be careful with this.
%
%     This function does not work correctly for two cases: 1.) You want to
%     import a function called 'import' 2.) You want to import a function called
%     'as'
%
%     The first case makes sense; you shouldn't be naming functions `import'
%     anyway since that's a Matlab built-in. The second case is used to make
%     things Pythonic; just don't name functions 'as.m', mkay?
%
%     If the node you're trying to import is a FunctionNode object, then only
%     the handle is returned. This is done for speed on your end in case you are
%     going to evaluate the FunctionNode a bunch of times.
%
%     Examples: (just like Python)
%
%       from speclab.orthopoly1d import jacobi
%       from speclab.orthopoly1d import jacobi as jac
%       from speclab.orthopoly1d import *
%
%     NB: Matlab does some `smart' optimization, and part of this is occasional
%     `freezing' of workspaces inside functions (i.e. static). However, since
%     this function uses the assignin function, Matlab doesn't realize that
%     you're trying to create a variable name with a call to this function.
%     Therefore, you'll try to run that function and sometimes Matlab will yell
%     at you about static workspaces. One easy way to clear this up is to use
%     the command sequence:
%
%     persistent gq
%     if isempty(gq)
%       from speclab.orthopoly1d.jacobi.quad import gauss_quadrature as gq
%     end
%     
%     The persistent statement announces the function name to Matlab, and the if
%     clause saves lots of computing time if you run the function many times.
%     (This function, 'from', is relatively slow, especially if you run it a lot
%     of times.)

import_package('labtools');
namestring = labtools.namestring_dissect;
global packages;

stack_length = length(dbstack(1));

if nargin==1
  import_package(package_name);
  varvalue = eval(package_name);    % uuuuuuugly

  package_name = namestring(package_name);

  for qq = length(package_name):-1:2
    varvalue = struct(package_name{qq}, varvalue);
  end
  varname = package_name{1};
  assignin('caller', varname, varvalue);   
  return
end

% Old 'from shapelab *' syntax
%
%if nargin==2
%  if varargin{1}=='*';
%    names = namestring(package_name);
%    temp = packages;
%    for q = 1:length(names)
%      temp = getfield(temp, names{q});
%    end
%    names = fieldnames(temp);
%    for q=1:length(names);
%      value = getfield(temp,names{q});
%      if strcmp(class(value), 'FunctionNode');
%        value = value.handle;
%      end
%      assignin('caller', names{q}, value);
%    end
%
%    return
%  end
%end

names = namestring(package_name);
temp = packages;
for q = 1:length(names)
  %temp = getfield(temp, names{q});
  temp = temp.(names{q});
end

% varargin{1} should always be 'import'
if not(strcmpi(varargin{1}, 'import'))
  error(['Unrecognized command ' varargin{1}]);
end

if nargin==2
  % WTF? Why are you running 'from package import'?
  error(['You didn''t tell me what to import from ' package_name]);
end

if nargin==3
  % We're only importing one `thing'. That `thing' may be *

  if varargin{2}=='*';
    names = namestring(package_name);
    temp = packages;
    for q = 1:length(names)
      temp = getfield(temp, names{q});
    end
    names = fieldnames(temp);
    for q=1:length(names);
      value = getfield(temp,names{q});
      if strcmp(class(value), 'FunctionNode') & stack_length>0
        value = value.handle;
      end
      assignin('caller', names{q}, value);
    end

  else
    try
      %node = getfield(temp, varargin{q});
      node = temp.(varargin{2});
      if strcmp(class(node), 'FunctionNode') & stack_length>0
        node = node.handle;
      end
    catch
      str1 = 'Cannot find package/module/function ';
      str2 = ' in package ';
      error([str1 varargin{2} str2 package_name]);
    end
    assignin('caller', varargin{2}, node);

  end

  return
end

% Now if there's an 'as', then nargin==5
flags = strcmpi('as', varargin(3:end));
if any(flags)
  if not(flags(1))
    error('You can''t use ''as'' when importing more than one thing');
  elseif nargin~=5
    error('You can''t assign to multiple names with ''as''');
  else  % finally, we're in business

    try
      node = temp.(varargin{2});
      if strcmp(class(node), 'FunctionNode') & stack_length>0
        node = node.handle;
      end
    catch
      str1 = 'Cannot find package/module/function ';
      str2 = ' in package ';
      error([str1 varargin{2} str2 package_name]);
    end
    assignin('caller', varargin{4}, node);

  end

else  % there's no 'as', just import whatever people tell us to
  for q = 2:length(varargin)
    try
      node = getfield(temp, varargin{q});
      if strcmp(class(node), 'FunctionNode') & stack_length>0
        node = node.handle;
      end
    catch
      str1 = 'Cannot find package/module/function ';
      str2 = ' in package ';
      error([str1 varargin{q} str2 package_name]);
    end
    assignin('caller', varargin{q}, node);
  end
end
