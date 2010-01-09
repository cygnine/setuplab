function[] = matport(varargin)
% matport -- Pythonic import of packages in Matlab
%
% [] = matport(package_name1, package_name2, ...)
%
%     Adds all the packages specified to the caller's workspace named with the
%     name of the package.
%
%     Examples:
%        matport speclab
%        matport speclab.orthopoly1d
%        matport speclab.orthopoly1d.jacobi as jac

global packages;
dissect = packages.labtools.namestring_dissect;
construct = packages.labtools.namestring_construct;

flags = strcmpi('as', varargin(:));

if any(flags)
  if not(flags(2))
    error('Illegal use of ''as''');
  else  % we're in business
    if nargin>3
      error('Cannot import multiples items or use multiple names with ''as''');
    end

    package_name = dissect(varargin{1});
    temp = packages;

    for qq = 1:length(package_name)
      try
        temp = getfield(temp, package_name{qq});
      catch
        str1 = 'Cannot find package/module/function ';
        if length(qq)==1
          all_str = [str1 package_name{1}];
        else
          str2 = ' in package ';
          str3 = construct('packages', package_name{1:qq-1});
          all_str = [str1 package_name{qq} str2 str3];
        end
        error(all_str);
      end
    end

    assignin('caller', varargin{3}, temp);
  end
else
  for q = 1:length(varargin)
    package_name = dissect(varargin{q});
    temp = packages;

    for qq = 1:length(package_name)
      try
        temp = getfield(temp, package_name{qq});
      catch
        str1 = 'Cannot find package/module/function ';
        if length(qq)==1
          all_str = [str1 package_name{1}];
        else
          str2 = ' in package ';
          str3 = construct('packages', package_name{1:qq-1});
          all_str = [str1 package_name{qq} str2 str3];
        end
        error(all_str);
      end
    end

    % Only import that node on the tree, not the rest of the tree
    varvalue = temp;
    for qq = length(package_name):-1:2
      varvalue = struct(package_name{qq}, varvalue);
    end

    varname = package_name{1};

    assignin('caller', varname, varvalue);

  end
end
