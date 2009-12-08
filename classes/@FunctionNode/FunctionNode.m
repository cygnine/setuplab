classdef FunctionNode
% FunctionNode -- A function handle-like object
%     obj = FunctionNode()
%     obj = FunctionNode(handle, function_name, path)
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
