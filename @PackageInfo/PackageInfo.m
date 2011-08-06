classdef PackageInfo
% PackageInfo -- Glorified struct datatype containing package information
%
% self = PackageInfo({module_list = {}, addpaths = {}, recurse_files=true, ...
%                     requires = {'setuplab'}, version=0);
%
%     This is a datatype that should be returned by every package's init__.m
%     file. It contains information that FunctionTree uses to perform the
%     crawling of directories.
  properties
    module_list
    addpaths
    recurse_files
    requires
    version
  end
  methods
    function self = PackageInfo(varargin)
      persistent inparse
      if isempty(inparse)
        inparse = inputParser();
        inparse.KeepUnmatched = false;

        inparse.addParamValue('module_list', {});
        inparse.addParamValue('addpaths', {});
        inparse.addParamValue('recurse_files', true);
        inparse.addParamValue('requires', {'setuplab'});
        inparse.addParamValue('version', 0);
      end

      if (nargin > 0) && isa(varargin{1}, 'PackageInfo');
        self = varargin{1};
        return
      end
      inparse.parse(varargin{:});

      % Jesus Christ Matlab, wtf. 'self = inparse.Results' is too vulgar for you?
      for q = fieldnames(inparse.Results)'
        self.(q{1}) = inparse.Results.(q{1});
      end
    end
  end
end
