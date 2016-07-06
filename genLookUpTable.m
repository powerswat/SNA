function [lookUpTbl] = genLookUpTable(idxCell)

% Formulate a lookup table that links names, user ids, and graph ids together

% Check whether the length of each vector is equal or not.
% If it is, merge all the given indices in one table
fields = fieldnames(idxCell);
numIndcs = length(fields);
refLen = length(idxCell.names);
lookUpTbl = cell(refLen, numIndcs);
lookUpTbl(:,1) = idxCell.names;
for i=2:numel(fields)
    curLen = length(idxCell.(fields{i}));
    
    if curLen ~= refLen
        error('The length of matrices in each cell array must be equal.');
    end
    
    if iscell(idxCell.(fields{i}))
        lookUpTbl(:,i) = idxCell.(fields{i});
    else
        for j=1:refLen
            lookUpTbl{j,i} = idxCell.(fields{i})(j);
        end
    end
    
end

end