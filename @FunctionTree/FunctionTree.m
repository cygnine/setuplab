classdef FunctionTree < Singleton
% FunctionTree -- A tree of FunctionNode's
%
% obj = FunctionTree.instance()
%
%     This singleton class stores all FunctionNode's for packages that reside in
%     a directory structure parallel to setuplab. Setuplab's 'classes'
%     subdirectory *must* be on the MATLAB path for this to work.
%
%     WARNING: Creating a FunctionTree instance performs some actions of
%     questionable programming propriety. It recurses the directory structure of
%     the machine to search for packages (that is, directories parallel to
%     setuplab that contain an 'init__.m' file). Therefore, many 'cd' commands
%     are performed. 
%
%     The MATLAB path is augmented as specified in each package's init__ file.
  properties(SetAccess=private)
    packages
  end
  methods(Static)
    function self = instance(verbosity)
      if nargin==0
        verbosity=2;
      end
      persistent obj
      if isempty(obj)
        obj = FunctionTree(verbosity);
      end
      self = obj;
    end
  end

  methods(Access=private)
    function self = FunctionTree(verbosity)
      directory_info = validate_setuplab_existence(self);
      %self = recurse_directories(self, directory_info);
      packages = initialize_packages(self);
      names = find_modules(self, directory_info.path);

      presdir = pwd;
      cd(directory_info.path);

      if verbosity == 0
        mystr = ['Initializing packages...this is done every time you ' ...
                 '''clear all'', ''clear functions'', or start MATLAB\n'];
        fprintf(mystr);
      end

      for q = 1:length(names)
        if verbosity > 1
          fprintf(['  Initializing ' names{q} '\n']);
        end
        packages = add_module(self, packages, names(q));
      end

      cd(presdir);
      self.packages = packages;
    end

    dinfo = validate_setuplab_existence(self); 
    self = recurse_files(self,varargin);
    packagaes = initialize_packages(self);
    names = find_modules(self, parent_package_directory);
    packages = add_module(self, packages, module_list, varargin);
    pwd_addpath(self, varargin);
  end

  methods
    varargout = subsref(self, s);
  end
end
