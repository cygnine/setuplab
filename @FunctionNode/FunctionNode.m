classdef FunctionNode
% FunctionNode -- A function handle-like object
%
% obj = FunctionNode()
% obj = FunctionNode(handle, function_name, path)
%
%     FunctionNode's can transparently serve as function handles: parenthetical
%     indexing forwards all inputs to a stored function handle. However,
%     FunctionNode's natively store various other tidbits of information about
%     the function: 
%        - the helpstring (accessible by calling with no indexing, even when the
%          function is not on the MATLAB path)
%        - the global path to the function 
%        - an 'inspect' method that opens the file for editing in matlab's editor
%
%     FunctionNode's can be passed around in different workspaces like variables
%     and therefore allow scoping, renaming functions, and calling functions
%     regardless of MATLAB's path.
  properties
    %helpstring = ''; % The Matlab help string
    path = ''; % String representation of the path where the function is stored
    function_name = '';  % String name of the function
    handle = @false; % Function handle leading to the function
  end
  methods

    function self = FunctionNode(handle,function_name,path)
    % FunctionNode -- A function handle-like object
    %     obj = FunctionNode()
    %     obj = FunctionNode(handle, function_name, path)
    %
    %     Initializes an object that is meant to emulate a function handle.
    %     However, by coding it as an object, we are allowed to do other magical
    %     things with it like transporting helpstrings around without keeping
    %     things in the Matlab path.
      if nargin>0
        self.path = path;
        self.handle = handle;
        self.function_name = function_name;
        temp = pwd;
        cd(self.path);
        %self.helpstring = help(self.function_name);
        cd(temp);
      else
        self.path = '';
        %self.helpstring = '';
        self.function_name = '';
        self.handle = @false;
      end
    end

    varargout = subsref(self,varargin);
    function handle = get.handle(self)
      handle = self.handle;
    end
    
    [] = inspect(self)
    [] = locate(self)
    [] = disp(self);
  end
end
