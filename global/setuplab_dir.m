function[sdir] = setuplab_dir()
% setuplab_dir -- Returns the path for the setuplab module
%
% sdir = setuplab_dir()

[pathstr, garbage, garbage, garbage] = fileparts(mfilename('fullpath'));

flags = find(pathstr==filesep);

sdir = pathstr(1:(flags(end)-1));
