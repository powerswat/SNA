function [rcvdGraphs] = genReceivedGraph(graphs)

% [recvGraphs] = genReceivedGraph(graphs): 
% Convert the given message sending graph to message receving graph by
% transposing every matrix in the graph data set


numSections = size(graphs, 1);
rcvdGraphs = cell(numSections, 1);
for i=1:numSections
    numChapters = size(graphs{i}, 1);
    rcvdGraphs{i} = cell(numChapters, 1);
    for j=1:numChapters
        rcvdGraphs{i}{j} = graphs{i}{j}';
    end
end