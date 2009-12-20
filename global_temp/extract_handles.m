function[handles] = extract_handles(packs)
% extract_handles -- extracts function handles from FunctionNode tree
%
% handles = extract_handles(packs)
%
%     The input packs is a tree-like struct with FunctionNode objects at the
%     nodes of the branches. This function preserves the tree structure of packs
%     in the output handles, except that the nodes of each branch are now
%     function handles.

handles = struct();

temp = fieldnames(packs);
for q = 1:length(temp)
  branch = getfield(packs, temp{q});
  if isa(branch, 'struct')
    handles = setfield(handles, temp{q}, extract_handles(branch));
  else
    handles = setfield(handles, temp{q}, branch.handle);
  end
end
