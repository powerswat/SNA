function [weights] = getWeights(postsWithWeights, numSections, ...
                                    tgtCol, posts, idcs, postIDCol, tsCol)

% Organize the leadership probabilities by chapter of each section
                                
weights = cell(numSections,1);
for i=1:numSections
    numChapters = size(idcs{i},1);
    weights{i} = cell(numChapters,1);
    for j=1:numChapters
        if j==1
            curCHPostIDSets = posts{i}(idcs{i}{j}(2:end),1:2);
        else
            curCHPostIDSets = posts{i}(idcs{i}{j},1:2);
        end
        
        curCHLen = size(curCHPostIDSets,1);
        weights{i}{j} = zeros(curCHLen,1);
        for k=1:curCHLen
            wghtRowIdcs = cell(size(curCHPostIDSets,2), 1);
            wghtRowIdcs(1) = {find(str2num(curCHPostIDSets{k,1}) ...
                                    == cell2mat(postsWithWeights(:,1)))};
            if length(wghtRowIdcs{1}) == 1
                weights{i}{j}(k) = postsWithWeights{wghtRowIdcs{1}, tgtCol};
            else
                wghtRowIdcs(2) = {find(str2num(curCHPostIDSets{k,2}) ...
                                    == cell2mat(postsWithWeights(:,2)))};
                finalIdx = intersect(wghtRowIdcs{1}, wghtRowIdcs{2});
                if ~isempty(finalIdx)
                    weights{i}{j}(k) = postsWithWeights{finalIdx, tgtCol}; 
                else
                    weights{i}{j}(k) = -1;
                end
            end
        end
    end
end

end
