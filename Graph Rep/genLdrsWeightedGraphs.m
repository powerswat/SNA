function [graphs] = genLdrsWeightedGraphs(senders, recipients, weights, ...
                                            numSections)

% Generate a set of leaders' message graph data set for each chapter 
% in each section.
                                        
graphs = cell(numSections, 1); 
for i=1:numSections
    numChapters = size(senders{i}, 1);
    graphs{i} = cell(numChapters, 1);
    for j=1:numChapters
        numRows = size(senders{i}{j}, 1);
        graphs{i}{j} = zeros(numRows, 3);
        graphs{i}{j}(:,1) = senders{i}{j};
        graphs{i}{j}(:,2) = recipients{i}{j};
        graphs{i}{j}(:,3) = weights{i}{j};
        
        graphs{i}{j}(graphs{i}{j}(:,1)<=0,:) = [];
        graphs{i}{j}(graphs{i}{j}(:,2)<=0,:) = [];
        graphs{i}{j}(graphs{i}{j}(:,3)<0.5,:) = [];
        
        % Aggregate multiple same directional edges by averaging the
        % weights of them.
        graphs{i}{j} = aggregateGraph(graphs{i}{j});
    end
end

end


% Aggregate multiple same directional edges by averaging the weights of them.
function [outGraph] = aggregateGraph(inGraph)

msgSet = unique(inGraph(:,1:2), 'rows');
numMsgSet = size(msgSet, 1);
[numGRows, numGCols] = size(inGraph);
for i=1:numMsgSet
    dupMsgIdx = intersect(find(inGraph(:,1) == msgSet(i,1)), ...
                            find(inGraph(:,2) == msgSet(i,2)));
    weights = inGraph(dupMsgIdx,3);
    outGraph(i,:) = [msgSet(i,1) msgSet(i,2) mean(weights)];
end

end
