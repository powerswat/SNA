function addGraphIDToPost(basePath, numSections)

% Add a column with Graph ID data to posting dataset

% Load the current version of input.mat
load([basePath 'input.mat']);

% Generate an ID look up table
origFileName = [basePath 'Final_Data-2012-03-11.xlsx'];
[finNum, finStr] = xlsread(origFileName);

idxCell = struct('names', strtrim({finStr(2:end,5)}), ...
                'classIDs', {finNum(:,4)}, 'graphIDs', {finNum(:,1)}, ...
                'sections', {finNum(:,2)});
unqSec = unique(idxCell.sections, 'stable');
for i=1:length(unqSec)
    curSecIdcs = find(idxCell.sections == unqSec(i));
    idxCell.sections(curSecIdcs) = i;
end

[nameUidGidSidTbl] = genLookUpTable(idxCell);


%% Read the posting data
postPaths = cell(numSections, 1);
postPaths(1) = {'SNA DATA\Original Data\2009-01-01\2009_01_01_posts.xlsx'};
postPaths(2) = {'SNA DATA\Original Data\2009-01-501\tkt4803_2009_01_501_posts.xlsx'};
postPaths(3) = {'SNA DATA\Original Data\2010-01-01\tkt4803_2010_01_01_posts.xls'};
postPaths(4) = {'SNA DATA\Original Data\2010-01-501\tkt4803_2010_01_501_posts.xls'};

posts = cell(numSections,1);
for i=1:numSections
    [~, pstStr] = xlsread([basePath char(postPaths(i))]);
    pstStr = addGraphID(basePath, pstStr, 4, nameUidGidSidTbl, i);
    posts(i) = {pstStr};
end

clear postPaths origFileName curSecIdcs idxCell unqSec
save([basePath 'input.mat']);
disp('Adding Graph ID is done.');

end

