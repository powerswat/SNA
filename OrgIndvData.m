function OrgIndvData(chatStrs, tsData, numFiles, histInfoSt)

users = cell(numFiles, 1);
usrSesTS = cell(numFiles, 1);
for i=1:numFiles
    users(i) = {unique(chatStrs{i}(2:end,2))};
    usrTS = cell(length(users(i)),2);
    tStmps = cell(length(users), 1);
    for j=1:length(users{i})
        usrTS(j,1) = users{i}(j);
        tStmps(j) = {find(str2num(users{i}{j}) ...
                        == cellfun(@str2num, chatStrs{i}(2:end,2)))};
        usrTS(j,2) = tStmps(j);
    end
    usrSesTS(i) = {usrTS};
end

% uData = struct('chats', chatStrs, 'ts', tsData);
end
