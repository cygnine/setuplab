function[] = add_to_deprecation_list(varargin)
% add_to_deprecation_list -- Adds to global deprecation list
%
% [] = add_to_deprecation_list(str1, str2, ...)
%
%     The global variables 'packages' has a field named "deprecation_list__"
%     that is a cell array of deprecated packages names, which are strings. This
%     function adds str1, str2, etc. to this list. 

global packages

for q = 1:nargin
  packages.deprecation_list__{end+1} = varargin{q};
end


