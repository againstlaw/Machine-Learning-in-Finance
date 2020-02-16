clc
clear all


data = readtable('sample_logit.xlsx');

pred = data{:,2:10}; 
resp = data{:,11};

names=data.Properties.VariableNames;
param_names=names(2:10);
 

mdl = fitglm(pred,resp,'Distribution','binomial','Link','logit');

scores = mdl.Fitted.Probability;

[X,Y,T,AUC] = perfcurve(resp,scores,true);

AUC


figure(1)
plot(X,Y,'r','LineWidth',1)
xlabel('False positive rate','Fontsize',12) 
ylabel('True positive rate','Fontsize',12)
title('ROC for Classification by Logistic Regression','Fontsize',12)




% predicted probability
ypred = predict(mdl,pred);

modelfit = ypred >= 0.5;
correct = sum(modelfit==resp) / length(resp) * 100


% print table of coef
params=mdl.Coefficients;
params.Properties.RowNames(2:end)=param_names;
params




% params=mdl.Coefficients
% b=params.Estimate;
% 
% 
% % define logistic function
% sigmoid = @(x) 1./(1+exp(-x));
% 
% N=length(resp);
% mypred=[ones(N,1), pred];
% 
% % predict
% modelfit = sigmoid(mypred*b) >= 0.5;
% 
% correct = sum(modelfit==resp) / length(resp) * 100
% 


