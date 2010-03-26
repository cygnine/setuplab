function[packages] = initialize_packages()
% initialize_packages -- Creates the initial (empty) package list
%
% packages = initialize_packages()
%
%     Basically a constructor for a non-existent class. The variable 'packages'
%     will be declared global from the calling function. This function just
%     initializes some required fields.

packages = struct('deprecation_list__', {{'_____'}});
