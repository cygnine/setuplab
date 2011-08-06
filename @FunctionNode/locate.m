function[] = locate(obj);
%  locate -- prints the client-side global file location

disp([fullfile(obj.path, obj.function_name), '.m']);
