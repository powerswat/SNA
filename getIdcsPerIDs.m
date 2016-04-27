function [result] = getIdcsPerIDs(users, curFileNum, rawData)

% Returns indices of each user's data in chatStrs of each section

result = cell(length(users(curFileNum)),2);
tmpMat = cell(length(users), 1);
for j=1:length(users{curFileNum})
    result{j,1} = users{curFileNum}(j);
    tmpMat(j) = {find(users{curFileNum}(j) ...
                    == cellfun(@str2num, rawData)) + 1};
    result(j,2) = tmpMat(j);
end

end