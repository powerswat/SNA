function [model, accuBT, tp, tn] = runAdaBoost(ldrGraphs, fllGraphs)

tp = 0;
while tp < 0.9
    % Prepare training and testing data sets
    trnRatio = 0.9;
    [trnX, trnY, tstX, tstY, posTrnX, negTrnX] ...
                = prepTrainTestDataset(ldrGraphs, fllGraphs, trnRatio);
            
    model = adaBoostTrain(negTrnX, posTrnX, {'nWeak', 30});

    tp = mean(adaBoostApply( tstX(tstY == 1,:), model )>0);
    tn = mean(adaBoostApply( tstX(tstY == -1,:), model )<0);
    accuBT = (tp + tn) / 2;

    % Display the testing accuracy
%     disp('Testing TP Accuracy (Boosted, Raw) = ');
%     disp(num2str(tp));
end

end