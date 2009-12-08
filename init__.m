function[setuplab] = init__()
% init__ -- setup file for setuplab
%
% [setuplab] = init__()

pwd_addpath('classes');  % Yay FunctionNode

setuplab = recurse_files;
