function [leaders, followers] = splitCellTwoGroups(rawData, leaderList, ...
                        nameUidGidSidTbl, senderIdCol, numCell, stRowNum, tsColNum)

                    
%% Prepare the exact amount of space to contain the leaders' and the followers' data                    
rowSize = 1;
for i=1:size(rawData,1)
   rowSize = rowSize + size(rawData{i}, 1);
end
colSize = size(rawData{1}, 2);
leaders = cell(rowSize, colSize);
followers = cell(rowSize, colSize);
  

%% NOTE: Remove the leaders who did not show enough leadership. 
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


%% Get numeric timestamp data
[TSs] = getTimeStamps(rawData, numCell, stRowNum, tsColNum);
[ldrStTSs] = getTimeStamps(leaderList, numCell, stRowNum, 3);
[ldrEdTSs] = getTimeStamps(leaderList, numCell, stRowNum, 4);

curLdrLoc = 1;
curFllLoc = 1;
for i=1:numCell
    
    % Extract rows for the current section from the whole index table
    curSecIdcs = find(cell2mat(nameUidGidSidTbl(:,4)) == i);
    curSecUGSTbl = nameUidGidSidTbl(curSecIdcs, :);
    
    for j=1:length(curSecUGSTbl)
        
        % Retreive the current user's raw data
        curUsrRawDataIdx = find(str2num(char(rawData{i}(2:end, senderIdCol))) ...
                        == curSecUGSTbl{j,2})+1;
        if isempty(curUsrRawDataIdx)
            continue;
        end
        
        % Retrieve all the raw data related to the current user (Including
        % the dat during the leader's tenure and the follower's tenure)
        curUsrRawData = rawData{i}(curUsrRawDataIdx, :);
        curUsrTS = TSs{i}(curUsrRawDataIdx-1, :);
        
        % Retreive the current user's raw data when he/she was a leader
        % curLdrName: The person who we focus on to locate the tenure that
        % he/she was acting as a leader.
        curLdrName = curSecUGSTbl(str2double(cell2mat( ...
                        curUsrRawData(1,senderIdCol))) == cell2mat(curSecUGSTbl(:,2)),:);        
        if isempty(curLdrName)
            continue;
        end
        
        % Find the timeline that the current user acted as a leader
        curLdrTSIdx = find(strcmpi(leaderList{i}(:,1), curLdrName(1))) - 1;
        if isempty(curLdrTSIdx)
            continue;
        end
            
        curLdrTS = [ldrStTSs{i}(curLdrTSIdx), ldrEdTSs{i}(curLdrTSIdx)];
        for k=1:size(curUsrRawData, 1)
            isLdrTimeLine = intersect(curUsrTS(k) >= curLdrTS(1), ...
                                        curUsrTS(k) <= curLdrTS(2));
            if ~isempty(isLdrTimeLine)
                leaders(curLdrLoc, :) = curUsrRawData(k,:);
                curLdrLoc = curLdrLoc + 1;
            else
                followers(curFllLoc, :) = curUsrRawData(k,:);
                curFllLoc = curFllLoc + 1;
            end
        end
    end
end

leaders(curLdrLoc:end, :) = [];
followers(curFllLoc:end, :) = [];

end