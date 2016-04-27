function [tsPerUserSec] = getDateConvTSPerIDs(uIDs, uIdcs, rawData)

% Returns actual timestamp records that are converted to Date format 
% for every user in each section

numUser = length(uIDs);
tsPerUserSec = cell(numUser, 1);

if iscellstr(rawData)
    tmpTS = datenum(rawData);
else
    tmpTS = rawData;
end

% Generate a list of actual timestamps per user
for i=1:numUser
    curTSs = tmpTS(uIdcs{i}-1);
    tsPerUserSec(i) = {curTSs};
end

end