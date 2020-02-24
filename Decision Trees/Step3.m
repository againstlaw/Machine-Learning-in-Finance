clc
clear all


% Bitcoin-USD

load data/bitCoinData.mat


names=data1_train.Properties.VariableNames;
param_names=names(1:end-1);
resp_name=names(end);

Mdl = fitrensemble(data1_train,'Response',...
    'OptimizeHyperparameters','auto');

X = data2_test(:,param_names);
Y = data2_test(:,resp_name);

Yfit = predict(Mdl,X);


% Compare the predicted volatility with actual volatility
x = 1:numel(Y);

yActual = Y.Response;

figure;
plot(x,yActual,'k--','linewidth',1)
hold on
plot(x,Yfit,'r-','linewidth',1)
grid on
xlabel('Days', 'Fontsize',12)
ylabel('Annualized volatility', 'Fontsize',12)
legend({'acutal','predicted'},'FontSize', 12, 'Location','best')
title('Predicted Volatility vs. Actual Volatility','Fontsize',14)

