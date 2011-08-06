function[dinfo] = validate_setuplab_existence(self)
% validate_setuplab_existence -- Finds setuplab and basic directory information
%
% dinfo = validate_setuplab_existence(self)
%
%     This function first determines if setuplab can be found (i.e. if the
%     'classes' subdirectory is on the MATLAB path). If not, it throws an error.
%
%     If setuplab is found, then it returns some basic directory information in
%     the struct dinfo. 

% first validation: find 'setuplab/classes' string in path
pth = path;
ind = strfind(pth, 'setuplab');
if isempty(ind)
  errmsg = ['cannot find setuplab/classes on the matlab path. ' ...
            'did you add this directory to the path?'];
  error(errmsg);
end

% if there's more than one entry (wtf?), just take the first
ind = ind(1);

% find indices in path that bound the global directory containing setuplab
sep_locations = strfind(pth, pathsep);

% hokay. if there is no colon before ind, setuplab is the first thing on the
% path (wtf?)
if ind < sep_locations(1)
  setuplab_loc = 1;
else
  setuplab_loc = sep_locations(find(sep_locations < ind, 1, 'last')) + 1;
end

% and if there is no colon after ind, setuplab is the last thing on the path
if ind > sep_locations(end)
  setuplab_loc(2) = length(pth) - 8;
else
  setuplab_loc(2) = sep_locations(find(sep_locations > ind, 1, 'first')) - 9;
end

dinfo.path = pth(setuplab_loc(1):setuplab_loc(2));
