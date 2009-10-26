function[] = pwd_addpath(subdir)
%  pwd_addpath -- modifies global PATH
%
%      Appends 'pwd + subdir' to the matlab global path

addpath(fullfile(pwd,subdir));
