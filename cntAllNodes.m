function numAllNodes = cntAllNodes(graphs)

numAllNodes = 0;
for i=1:size(graphs,1)
    for j=1:size(graphs{i}, 1)
       numAllNodes = numAllNodes + length(graphs{i}{j}); 
    end
end