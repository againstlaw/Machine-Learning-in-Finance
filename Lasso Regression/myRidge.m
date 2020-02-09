clc
clear all


% Load data
filename = 'Houseprice_data_scaled.csv';
Data=readtable(filename);


y=Data.SalePrice;

Data(:,'SalePrice') = [];
X=Data{:,:};


n = length(y);

rng('default') % For reproducibility
c = cvpartition(n,'HoldOut',0.3);
idxTrain = training(c,1);
idxTest = ~idxTrain;


k = 5;
b = ridge(y(idxTrain),X(idxTrain,:),k,0);

yhat = b(1) + X(idxTest,:)*b(2:end);


% create table
colnames=Data.Properties.VariableNames;

% coef = b(2:end)';
% results = array2table(coef,'VariableNames',colnames);

coef = b(2:end);
results = array2table(coef,'RowNames',colnames)





% k = 0:1e-5:5e-3;
% betahat = ridge(y(idxTrain),X(idxTrain,:),k);
% 
% 
% figure(1)
% plot(k,betahat,'LineWidth',2)
% grid on 
% xlabel('Ridge Parameter') 
% ylabel('Standardized Coefficient') 
% title('{\bf Ridge Trace}')


