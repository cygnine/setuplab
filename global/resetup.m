% Script resetup
%
% WARNING: this script clears ALL workspace data. Make SURE you're ok with this
% before running the file

clear

setupdir = setuplab_dir();
currdir = pwd;

cd(setupdir);

fname = 'setuplab_dir_record.mat';

save(fname, 'currdir');

clear all; clear import; restoredefaultpath
setup;

load setuplab_dir_record.mat
delete('setuplab_dir_record.mat');
cd(currdir)

clear
