function saveCSV(graphs, graphPath)

% Save the set of graph data set in a csv format
numSections = size(graphs,1);
for i=1:numSections
    numChapters = size(graphs{i}, 1);
    for j=1:numChapters
        csvwrite([graphPath 'Ldr_Sec_' num2str(i) '_CH_' num2str(j) '.csv'], ...
                    graphs{i}{j});
    end
end

end