function[varargout] = subsref(self, s)
% subsref -- Overloaded subscripting method for FunctionTree
%
% varargout = subsref(self, s)
%
%     This method overloads subscripting via the dot operator '.' to access the
%     'packages' property.

switch s(1).type
case '.'  % Then get appropriate sub-package from self.packages
  if strcmp(s(1).subs, 'packages')
    varargout{1} = self.packages;
  else
    varargout{1} = subsref(self.packages, s);
  end
otherwise % Just call builtin
  [varargin{1:nargout}] = builtin('subsref', self, s);
end
