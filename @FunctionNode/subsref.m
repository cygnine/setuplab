function[varargout] = subsref(self,s);
% subsref -- The overloaded method mimicking function handle behavior
%     [varargout] = subsref(self,s);

if length(s)==1
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
elseif length(s)==2  % This must be self.handle(input1, input2, ...)
  [varargout{1:nargout}] = self.handle(s(2).subs{:});
end
