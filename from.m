function[] = from(package_name,varargin)
% from -- A Pythonic import statement implemented in Matlab
%
% [] = from(package_name, {'import', name1, name2, ...})
% [] = from(package_name, {'import', proper_name, 'as', preferred_name})
%
% from package_name import name1 name2 name3 ...
% from package_name import *
% from package_name import proper_name as preferred_name
%
%     Adds the function/modules specified in the varargin cell array to the
%     caller workspace. It uses the super-ugly, poor-form assignin
%     function.
%
%     If called from the command line or a top-level script, it imports
%     FunctionTree objects; otherwise simple function handles are imported. This
%     is done for speed concerns. No need to plow through FunctionTree.subsref
%     when not needed.
%
%     If name1 == '*', imports ALL the fields of package_name into the
%     caller workspace. Clearly you should be careful with this.
%
%     This function does not work correctly for one case: 1.) You want to import
%     a function called 'as'
%
%     Examples: (just like Python)
%
%       from speclab.orthopoly import jacobi
%       from speclab.orthopoly import jacobi as jac
%       from speclab.orthopoly import *
%
%     NB: Matlab does some `smart' optimization, and part of this is occasional
%     `freezing' of workspaces inside functions (i.e. static). However, since
%     this function uses the assignin function, Matlab doesn't realize that
%     you're trying to create a variable name with a call to this function.
%     Therefore, you'll try to run that function and sometimes Matlab will yell
%     at you about static workspaces. One easy way to clear this up is to just
%     preallocate the variables (e.g. as empty arrays). Another longer but more
%     efficient option is to use the command sequence:
%
%     persistent gq
%     if isempty(gq)
%       from speclab.orthopoly.jacobi.quad import gauss_quadrature as gq
%     end
%     
%     The persistent statement announces the function name to Matlab, and the if
%     clause saves lots of computing time if you run the function many times.

persistent packages
if isempty(packages)
  packages = FunctionTree.instance(0);
  packages = packages.packages;
end

if not(isa(package_name, 'char'))
  error('All inputs to this function must be strings');
end

stack_length = length(dbstack(1));
% Below or equal to stack_cutoff, the whole class instance is imported,
% otherwise only the handle is imported.
stack_cutoff = 1;

if nargin==1
  error(['What should I import from "' package_name '"?']);
end

% varargin{1} should always be 'import'
if not(strcmpi(varargin{1}, 'import'))
  error(['Unrecognized command ' varargin{1}]);
end

if nargin==2
  % WTF? Why are you running 'from package import'?
  error(['You didn''t tell me what to import from ' package_name]);
end

dissection = namestring_dissect(package_name);
try
  %thispack = packages.(package_name);
  thispack = getfield(packages, dissection{:});
catch
  errmsg = ['Cannot find package named "', package_name ...
  '". Did you copy the package directory to a location parallel to setuplab?'];
  error(errmsg)
end

if nargin==3  % We're only importing one `thing'. That `thing' may be *
  if varargin{2}=='*'; 
    names = fieldnames(thispack);
  else
    names = varargin(2);
  end
elseif (nargin==5) && strcmp(varargin{3}, 'as');
  % Only import one thing
  names = varargin(2);
else % This must just be a long list of stuff to import 
  names = varargin(2:end);
end

% Now unless we're importing 'as' stuff, we just have to assignin('caller')
if (nargin==5) && strcmp(varargin{3}, 'as');
  try
    node = getfield(thispack, names{1});
  catch
    str1 = 'Cannot find package/module/function "';
    str2 = '" in package "';
    error([str1 names{1} str2 package_name, '"']);
  end
  assignin('caller', varargin{4}, node);
else
  % We just have to loop over everything
  for q = 1:length(names)
    try
      node = getfield(thispack, names{q});

      if strcmp(class(node), 'FunctionNode') & stack_length>stack_cutoff
        node = node.handle;
      end

      nodes{q} = node;
    catch
      str1 = 'Cannot find package/module/function "';
      str2 = '" in package "';
      error([str1 names{q} str2 package_name '"']);
    end
  end
  for q = 1:length(names)
    assignin('caller', names{q}, nodes{q});
  end
end

end

% Nested function
function[names] = namestring_dissect(name)
% namestring_dissect -- dissects 'name.strings' into {'name', 'strings'}
%
% names = namestring_dissect(name)
% 
%     Performs the operation:
%        'name.string.example' --->  {'name', 'string', 'example'}
%
%     The input name is a single string, the output names is a cell array with
%     length equal to the (number of periods ('.') found in name) + 1.

periods = strfind(name, '.');
N = length(periods);
names = cell([N+1 1]);

if N==0
  names = {name};
  return;
end

names{1} = name(1:(periods(1)-1));

if N>1
  for q = 2:N
    names{q} = name((periods(q-1)+1):(periods(q)-1));
  end
end

names{N+1} = name(periods(N)+1:end);
end
