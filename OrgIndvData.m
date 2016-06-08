function OrgIndvData(chatStrs, tsData, numFiles, histInfoSt)

global basePath;

users = cell(numFiles, 1);
usrDataIdcs = cell(numFiles, 1);
userTSs = cell(numFiles, 1);

for i=1:numFiles
    
    % User Ids in each section
    uIDs = cell2mat(cellfun(@str2num, chatStrs{i}(2:end,2), 'un', 0));
    users(i) = {unique(uIDs)};
    
    % Indices of each user's data in chatStrs of each section
    [usrTSIdcs] = getIdcsPerIDs(users, i, chatStrs{i}(2:end,2));
    usrDataIdcs(i) = {usrTSIdcs};
    
    % Actual timestamp records that are converted to Date format for every user 
    % in each section
    [tsPerUserSec] = getDateConvTSPerIDs(usrTSIdcs(:,1), usrTSIdcs(:,2), ...
                                        chatStrs{i}(2:end,5));
                                    
    % Activity data per user
    dataPerUserSec = cell(size(usrTSIdcs,1), 4);
    dataPerUserSec = [usrTSIdcs, tsPerUserSec];
    for j=1:size(dataPerUserSec,1)
        h = histogram(dataPerUserSec{j,3}, histInfoSt(i).binEdges);
        dataPerUserSec(j,4) = {h.Values'};
    end
    
    % Plot the histograms of every user's activities and total activities
    plot(histInfoSt(i).values)
    hold on;
    
    numUsers = size(dataPerUserSec,1);
    legends = cell(numUsers+1,1);
    legends(1) = {'Total'};
    for j=1:numUsers
        if j <= 5
            plot(dataPerUserSec{j,4}, '.', 'markersize', 20)
        elseif j > 5 && j <= 10
            plot(dataPerUserSec{j,4}, 'x', 'markersize', 5)
        else
            plot(dataPerUserSec{j,4}, 'o', 'markersize', 5)
        end
        legends(j+1) = {[num2str(dataPerUserSec{j})]};
        legend(legends(1:j+1));
        
        valMat = dataPerUserSec{j,4};
        nzIdcs = find(valMat);
        nzVals = valMat(nzIdcs);
        text(nzIdcs+0.2, nzVals, legends(j+1));
    end
    hold off;
    
    if ~exist([basePath 'Sec_' num2str(i) '_histo.png'], 'file')
        print([basePath 'Sec_' num2str(i) '_histo'], '-dpng');
    end
end

end
