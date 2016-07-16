function [recipients] = getRecipients( ...
                posts, replyMsgCol, senderCol, numSections, idcs, postIDCol)

% Organize the message recipients by chapter of each section
            
recipients = cell(numSections,1);
for i=1:numSections
    numChapters = size(idcs{i},1);
    recipients{i} = cell(numChapters,1);
    msgIDs = posts{i}(:,1);
    msgIDs(1) = [];
    msgIDs = cellfun(@str2num, msgIDs);
    for j=1:numChapters
        tmpReplyMsgIDs = posts{i}(idcs{i}{j}, replyMsgCol);
        if j==1
            tmpReplyMsgIDs(1) = [];
        end
        
        replyMsgIDs = cellfun(@str2num, tmpReplyMsgIDs);
        senderIDs = cellfun(@str2num, posts{i}(2:end, senderCol));
        lenRow = size(replyMsgIDs,1);
        recipients{i}{j} = zeros(lenRow,1);
        for k=1:lenRow
            if replyMsgIDs(k) == -1
                recipients{i}{j}(k) = -1;
            else
                recipients{i}{j}(k) = senderIDs((msgIDs == replyMsgIDs(k)));
            end
        end
    end
end

end
