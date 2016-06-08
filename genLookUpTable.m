function [lookUpTbl] = genLookUpTable(idxCell)

% Formulate a lookup table that links names, user ids, and graph ids together

% Check whether the length of each vector is equal or not.
% If it is, merge all the given indices in one table
numIndcs = length(idxCell);
refLen = length(idxCell{1});
lookUpTbl = cell(refLen, numIndcs);
lookUpTbl(:,1) = idxCell{1};
for i=2:numIndcs
    curLen = length(idxCell{i});
    
    if curLen ~= refLen
        error('The length of matrices in each cell array must be equal.');
    end
    
    if iscell(idxCell{i})
        lookUpTbl(:,i) = idxCell{i};
    else
        for j=1:refLen
            lookUpTbl{j,i} = idxCell{i}(j);
        end
    end
    
end

end