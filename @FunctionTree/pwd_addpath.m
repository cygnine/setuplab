function[] = pwd_addpath(self, varargin)
% pwd_addpath -- modifies global PATH
%
% pwd_addpath(subdir1, subdir2, ...)
%
%      Appends 'pwd + subdir' to the matlab global path for each subdir in
%      varargin.

for q = 1:length(varargin)
  subdir = varargin{q};
  addpath(fullfile(pwd,subdir));
end
