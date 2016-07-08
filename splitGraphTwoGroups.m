function [ldrGraphs, fllGraphs, ldrIDs, fllIDs] = splitGraphTwoGroups( ...
            graphs, leaderList, nameUidGidSidTbl, isNormalize, comDirection)
                            
% Split each message communication graph into a leader's message sent/received 
% graph and followers' message sent/receiveed graph

% Fill 0s with all empty cells in each graph
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
ldrIDs = zeros(numNodes, 1);
fllIDs = zeros(numNodes, 1);
for i=1:size(graphs, 1)
    for j=1:size(graphs{i}, 1)
       curLdrIdcs = find(cell2mat(leaderList{i}(2:end, 2)) == j) + 1; 
       curLdrNames = leaderList{i}(curLdrIdcs, 1);
       
       
       if comDirection == 1         % Split on received messages
           tmpG = graphs{i}{j}';
       else
           tmpG = graphs{i}{j};
       end
           
       
       % Min-Max normalization per chapter
       if isNormalize == 1
           tmpG(2:end-2, 2:end-2) = minMaxNorm(tmpG(2:end-2, 2:end-2), 3) * 100;
       end
       
       for k=1:length(curLdrNames)
           curLdrRowIdInLookup = find(strcmp(nameUidGidSidTbl(:,1), curLdrNames(k)));
           curLdrGId = cell2mat(nameUidGidSidTbl(curLdrRowIdInLookup, 3));
           if isempty(curLdrGId)
               continue;
           end
           
           rowLdrInG = find(tmpG(2:end-2, 1) == curLdrGId)+1;
           ldrGraphs(ldrIdx, 1:size(tmpG(rowLdrInG, :), 2) - 3) = tmpG(rowLdrInG, 2:end-2);
           ldrIDs(ldrIdx) = tmpG(rowLdrInG,1);
           ldrIdx = ldrIdx + 1;
           tmpG(rowLdrInG, :) = [];
       end
       fllGraphs(fllIdx:fllIdx + size(tmpG, 1) - 4, 1:size(tmpG, 2) - 3) ...
            = tmpG(2:size(tmpG, 1) - 2, 2:end-2);
       fllIDs(fllIdx:fllIdx + size(tmpG, 1) - 4) ...
            = tmpG(2:size(tmpG, 1) - 2, 1);
       fllIdx = fllIdx + size(tmpG, 1) - 3 + 1;
    end
end

% Remove empty rows in the final graphs
rmvColIdx = max(min(find(sum(ldrGraphs) == 0)), min(find(sum(fllGraphs) == 0)));
ldrGraphs(:, rmvColIdx:end) = [];
ldrGraphs(ldrIdx:end, :) = [];
ldrIDs(ldrIdx:end, :) = [];
fllGraphs(:, rmvColIdx:end) = [];
fllGraphs(fllIdx:end, :) = [];
fllIDs(ldrIdx:end, :) = [];

% Sort the graphs in the descending order of the number of sent messages
ldrGraphs = sort(ldrGraphs, 2, 'descend');
fllGraphs = sort(fllGraphs, 2, 'descend');

% TEMP: Validating purpose
% hold on;
% for i=1:size(fllGraphs, 1)
%     plot(fllGraphs(i,:))
% end
% hold off;

end