function [leaders, followers] = splitCellTwoGroups(rawData, leaderList, ...
                        nameUidGidSidTbl, senderIdCol, numCell, stRowNum, tsColNum)

% Prepare some space to contain the leaders' and the followers' data                    
rowSize = 1;
for i=1:size(rawData,1)
   rowSize = rowSize + size(rawData{i}, 1);
end
colSize = size(rawData{1}, 2);
leaders = cell(rowSize, colSize);
followers = cell(rowSize, colSize);
                    
% NOTE: Remove the leaders who did not show enough leadership. 
%       (Manually determined)
rmvGid = [35 39 45 46 54]';
rmvNames = cell(length(rmvGid), 1);
for i=1:length(rmvGid)
    rmvName = char(nameUidGidSidTbl( ...
                find(cell2mat(nameUidGidSidTbl(:,3)) == rmvGid(i)), 1));
    for j=1:numCell
        rmvIdxLdrList = find(~cellfun(@isempty, strfind(leaderList{j}(:,1), rmvName)));
        if ~isempty(rmvIdxLdrList)
            leaderList{j}(rmvIdxLdrList,:) = [];
        end
    end    
end

% Get numeric timestamp data
[TSs] = getTimeStamps(rawData, numCell, stRowNum, tsColNum);
[ldrStTSs] = getTimeStamps(leaderList, numCell, stRowNum, 3);
[ldrEdTSs] = getTimeStamps(leaderList, numCell, stRowNum, 4);

secDict = unique(cell2mat(nameUidGidSidTbl(:,4)));
curLdrIdx = 1;
curFllIdx = 1;
for i=1:numCell
    
    curSecTblIdcs = find(cell2mat(nameUidGidSidTbl(:,4)) == i);
    curSecUGSTbl = nameUidGidSidTbl(curSecTblIdcs, :);
    
    for j=1:length(curSecUGSTbl)
        
        % Retreive the current user's raw data
        curUsrIdx = find(str2num(char(rawData{i}(2:end, senderIdCol))) ...
                        == curSecUGSTbl{j,2})+1;
        if isempty(curUsrIdx)
            continue;
        end
        curUsrRawData = rawData{i}(curUsrIdx, :);
        curUsrTS = TSs{i}(curUsrIdx-1, :);
        
        % Retreive the current user's raw data when he/she was a leader
        curUsrRow = curSecUGSTbl(find(str2double(cell2mat( ...
                        curUsrRawData(1,senderIdCol))) == cell2mat(curSecUGSTbl(:,2))),:);        
        if isempty(curUsrRow)
            continue;
        end
                    
        % Retrieve all the raw data related to the current user
        curUsrRawData = rawData{i}(curUsrIdx, :);
        
        % Find the timeline that the current user acted as a leader
        curLdrTSIdx = find(strcmpi(leaderList{i}(:,1), curUsrRow(1))) - 1;
        if isempty(curLdrTSIdx)
            continue;
        end
            
        curLdrTS = [ldrStTSs{i}(curLdrTSIdx), ldrEdTSs{i}(curLdrTSIdx)];
        for k=1:size(curUsrRawData, 1)
            isLdrTimeLine = intersect(curUsrTS(k) >= curLdrTS(1), ...
                                        curUsrTS(k) <= curLdrTS(2));
            if ~isempty(isLdrTimeLine)
                leaders(curLdrIdx, :) = curUsrRawData(k,:);
                curLdrIdx = curLdrIdx + 1;
            else
                followers(curFllIdx, :) = curUsrRawData(k,:);
                curFllIdx = curFllIdx + 1;
            end
        end
    end
end

leaders(curLdrIdx:end, :) = [];
followers(curFllIdx:end, :) = [];

end