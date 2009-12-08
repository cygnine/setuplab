function[varargout] = subsref(self,s);
% subsref -- The overloaded method mimicking function handle behavior
%     [varargout] = subsref(self,s);

switch s(1).type
case '()'
  %varargout = cell([abs(nargout(self.handle)) 1]);
  %[varargout{:}] = self.handle(s.subs{:});
  [varargout{1:nargout}] = feval(self.handle, s.subs{:});
case '.'
  [varargout{1:nargout}] = self.(s(1).subs);
otherwise 
  error('Unrecognized subscripting of function');
end
