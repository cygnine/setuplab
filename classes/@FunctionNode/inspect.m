function[] = inspect(obj);
%  inspect -- opens the m-file that the FunctionNode points to in Matlab's text
%      editor

open([fullfile(obj.path, obj.function_name), '.m']);
