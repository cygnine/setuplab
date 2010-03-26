function[] = deprecation_check(package_name)
% deprecation_check -- Checks if input package name is deprecated
%
% [] = deprecation_check(package_name)
%
%     Checks the string input package_name against the globally defined
%     deprecation list in packages.deprecation_list__. Issues a warning message
%     if a match is found.

global packages

temp = warning('query', 'backtrace');
warning off backtrace
for q = 1:length(packages.deprecation_list__)
  if strfind(package_name, packages.deprecation_list__{q})
    warning(['The package ' packages.deprecation_list__{q} ' is deprecated and will likely be removed soon.']);
    break
  end
end

% Matlab's backtrace/verbose toggling for the "warning" command is
% super-awkward, so this crappy way of coding things is necessary.
if strcmpi(temp.state, 'on')
  warning on backtrace
end
