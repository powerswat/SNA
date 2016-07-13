function [post] = addGraphID(basePath, pstStr, tgtColNum, ...
                                nameUidGidSidTbl, curSection)
   
post = cell(size(pstStr,1), size(pstStr,2)+1);

% Set up labels
post(1,1:3) = pstStr(1,1:3);
post{1,4} = 'gid';
post(1,5:end) = pstStr(1,4:end);

% Fill in data of the original dataset
post(2:end,1:3) = pstStr(2:end,1:3);
post(2:end,5:end) = pstStr(2:end,4:end);

% Extract students' information of the current section
curSecStudents = cell2mat(nameUidGidSidTbl(cell2mat( ...
                                nameUidGidSidTbl(:,4)) == curSection, 2:3));

% Assign graph id in the corresponding rows in the posting matrix
tmpGid = zeros(size(post,1)-1, 1);
for i=1:size(curSecStudents,1)
    selectedRows = (cellfun(@str2num, post(2:end,5)) ...
                    == curSecStudents(i,1));
    tmpGid(selectedRows) = curSecStudents(i,2);
end

for i=1:size(tmpGid,1)
    post{i+1,4} = num2str(tmpGid(i));
end

end