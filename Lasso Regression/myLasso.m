clc
clear all


% Load data
filename = 'Houseprice_data_scaled.csv';
Data=readtable(filename);


y=Data.SalePrice;

Data(:,'SalePrice') = [];
X=Data{:,:};


n = length(y);

rng('default')    % For reproducibility
c = cvpartition(n,'HoldOut',0.3);
idxTrain = training(c,1);
idxTest = ~idxTrain;

XTrain = X(idxTrain,:);
yTrain = y(idxTrain);

XTest = X(idxTest,:);
yTest = y(idxTest);

% Construct the lasso fit using 10-fold cross-validation.
[b,fitinfo] = lasso(XTrain,yTrain,'CV',10);
lassoPlot(b,fitinfo,'PlotType','Lambda','XScale','log');


% Plot the cross-validated fits.
lassoPlot(b,fitinfo,'PlotType','CV');
legend('show')



idxLambda1SE = fitinfo.Index1SE;
coef = b(:,idxLambda1SE);
coef0 = fitinfo.Intercept(idxLambda1SE);

yhat = XTest*coef + coef0;


% choose non-zero weights
ind=find(coef);
coef_select=coef(ind);

% create table
colnames=Data.Properties.VariableNames;

para_select=colnames(ind);
results = array2table(coef_select,'RowNames',para_select)


% coef_select = coef_select';
% results = array2table(coef_select,'VariableNames',para_select);


fitinfo.Lambda1SE

