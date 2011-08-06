function[] = disp(obj);
% disp -- Displays the helpstring for the FunctionNode object.
%     [] = disp(obj);

presdir = pwd;
cd(obj.path);
help(obj.function_name);
cd(presdir);

% fprintf(obj.helpstring);
