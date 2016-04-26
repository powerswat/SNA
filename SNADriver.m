function SNADriver

global basePath;

% xls graph data read
basePath = 'C:\Temp\Leadership data\SNA DATA\';     % Base directory path
numFiles = 4;
chatPaths = cell(numFiles,1);
chatPaths(1) = {'Original Data\2009-01-01\2009_01_01_idiscuss_chat.xlsx'};
chatPaths(2) = {'Original Data\2009-01-501\tkt4803_2009_01_501_idiscuss_chat.xlsx'};
chatPaths(3) = {'Original Data\2010-01-01\tkt4803_2010_01_01_idiscuss_chat.xls'};
chatPaths(4) = {'Original Data\2010-01-501\tkt4803_2010_01_501_idiscuss_chat.xls'};

chatStrs = cell(numFiles,1);
for i=1:numFiles
    [~, chatStr] = xlsread([basePath char(chatPaths(i))]);
    chatStrs(i) = {chatStr};
end

tsData = cell(numFiles, 1);
for i=1:numFiles
    tsRows = chatStrs{i}(2:end,5);
    tsData(i) = {datenum(char(tsRows))};
end

% Represent an overall histogram for all the four dicussion data based on
% a daily scale
[histInfoSt] = VizOverall(tsData, numFiles);

% Organized everyone's posting data
OrgIndvData(chatStrs, tsData, numFiles, histInfoSt);

end