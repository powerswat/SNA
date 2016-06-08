function [ldrGraphs, fllGraphs] = splitGraphTwoGroups( ...
                                graphs, leaderList, nameUidGidSidTbl, isNormalize)

% TODO: Sort the graph in the decsending order of the number of sent
% messages
mssngNodeIdx = 1;
numNodes = cntAllNodes(graphs);
mssngNodes = zeros(numNodes, 5);
for i=1:size(graphs, 1)
    for j=1:size(graphs{i}, 1)
        msgSentIdx = graphs{i}{j}(2:end-2,1);
        msgRcvdIdx = graphs{i}{j}(1,2:end-2)';
        
        % Test if there is any missing row or column in the graph
        [mssngNode, vecType, loc] = testMissingInfoGraph(msgSentIdx, msgRcvdIdx);
        if (mssngNode > -1)
            msNodeLen = length(mssngNode);
            for k=1:msNodeLen
                mssngNodes(mssngNodeIdx, 1) = i;
                mssngNodes(mssngNodeIdx, 2) = j;
                mssngNodes(mssngNodeIdx, 3) = mssngNode(k);
                mssngNodes(mssngNodeIdx, 4) = vecType;
                mssngNodes(mssngNodeIdx, 5) = loc(k);
                mssngNodeIdx = mssngNodeIdx + 1;
            end
        end
    end
end
mssngNodes(mssngNodeIdx:end,:) = [];

% Insert a row or column of zeros into each graph matrix that has any missing
% nodes. 
for k=1:size(mssngNodes, 1)
    i = mssngNodes(k, 1);
    j = mssngNodes(k, 2);
    if mssngNodes(k, 4) == 0
        tmp = zeros(size(graphs{i}{j}, 1)+1, size(graphs{i}{j}, 2));
        tmp(1:mssngNodes(k,5),:) = graphs{i}{j}(1:mssngNodes(k,5),:);
        tmp(mssngNodes(k,5)+1,:) = [mssngNodes(k,3), zeros(1, size(graphs{i}{j}, 2)-1)];
        tmp(mssngNodes(k,5)+2:end,:) = graphs{i}{j}(mssngNodes(k,5)+1:end,:);
    else
        tmp = zeros(size(graphs{i}{j}, 1), size(graphs{i}{j}, 2)+1);
        tmp(:,1:mssngNodes(k,5)) = graphs{i}{j}(:,1:mssngNodes(k,5));
        tmp(:,mssngNodes(k,5)+1) = [mssngNodes(k,3); zeros(size(graphs{i}{j}, 1)-1, 1)];
        tmp(:,mssngNodes(k,5)+2:end) = graphs{i}{j}(:,mssngNodes(k,5)+1:end);
    end
    graphs{i}(j) = {tmp};
end

% Split the graphs into the leaders' messages and followers' messages
ldrIdx = 1;
fllIdx = 1;
ldrGraphs = zeros(numNodes, numNodes);
fllGraphs = zeros(numNodes, numNodes);
for i=1:size(graphs, 1)
    for j=1:size(graphs{i}, 1)
       curLdrIdcs = find(cell2mat(leaderList{i}(2:end, 2)) == j) + 1; 
       curLdrName = leaderList{i}(curLdrIdcs, 1);
       
       tmpG = graphs{i}{j};
       
       % Min-Max normalization per chapter
       if isNormalize == 1
           tmpG(2:end-2, 2:end-2) = minMaxNorm(tmpG(2:end-2, 2:end-2), 3) * 100;
       end
       
       for k=1:length(curLdrName)
           curLdrGIdcs = find(strcmp(nameUidGidSidTbl(:,1), curLdrName(k)));
           curLdrGId = cell2mat(nameUidGidSidTbl(curLdrGIdcs, 3));
           if isempty(curLdrGId)
               continue;
           end
           
           rowLdrG = find(tmpG(2:end-2, 1) == curLdrGId)+1;
           ldrGraphs(ldrIdx, 1:size(tmpG(rowLdrG, :), 2) - 3) = tmpG(rowLdrG, 2:end-2);
           ldrIdx = ldrIdx + 1;
           tmpG(rowLdrG, :) = [];
       end
       fllGraphs(fllIdx:fllIdx + size(tmpG, 1) - 4, 1:size(tmpG, 2) - 3) ...
            = tmpG(2:size(tmpG, 1) - 2, 2:end-2);
       fllIdx = fllIdx + size(tmpG, 1) - 3 + 1;
    end
end

% Remove empty rows in the final graphs
rmvColIdx = max(min(find(sum(ldrGraphs) == 0)), min(find(sum(fllGraphs) == 0)));
ldrGraphs(:, rmvColIdx:end) = [];
ldrGraphs(ldrIdx:end, :) = [];
fllGraphs(:, rmvColIdx:end) = [];
fllGraphs(fllIdx:end, :) = [];

% Sort the graphs in the descending order of the number of sent messages
ldrGraphs = sort(ldrGraphs', 'descend')';
fllGraphs = sort(fllGraphs', 'descend')';

% TEMP: Validating purpose
% hold on;
% for i=1:size(fllGraphs, 1)
%     plot(fllGraphs(i,:))
% end
% hold off;

end