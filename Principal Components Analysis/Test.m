clc
clear all


url = 'https://fred.stlouisfed.org/';
c = fred(url);

startdate = '01/01/1995';
enddate = today;

series = {'DGS3MO','DGS6MO','DGS1','DGS2','DGS3','DGS5','DGS7','DGS10','DGS20'};
Maturity=[3/12 6/12 1 2 3 5 7 10 20];
CMR = fetch(c,series,startdate,enddate);

close(c)


% number of market variables
N=length(series);


for i=1:N
    myData=CMR(i).Data;
    DateStrings=datestr(myData(:,1));
    Date=datetime(DateStrings,'InputFormat','dd-MMM-yyy');
    r=myData(:,2);
    Data{i}=timetable(Date,r);
end

Stocks=synchronize(Data{:});
Treasury=rmmissing(Stocks);
Treasury.Properties.VariableNames=series;
Price=timetable2table(Treasury);

StockDate = Price.Date;
StockPrice = Price{:,2:end};


figure(1)
plot(StockDate,StockPrice,'linewidth',1)
grid on
title('Treasury Constant Maturity Rate','Fontsize',14)
ylabel('Interest rate (%)', 'Fontsize',12)
legend(series,'FontSize',10,'Location','best')



% Principal Component Analysis
% PCA
Covariance=cov(StockPrice);
[coeff,latent,explained] = pcacov(Covariance);


figure(2)
plot(Maturity,coeff(:,1),'ko-','linewidth',1,'MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
hold on
plot(Maturity,coeff(:,2),'rs-','linewidth',1,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',5)
hold on
plot(Maturity,coeff(:,3),'b^-','linewidth',1,'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',5)
grid on
xticks(0:5:20)
title('Principal Components Analysis (PCA)','Fontsize',14)
xlabel('Maturity (years)', 'Fontsize',12)
ylabel('Factor loadings', 'Fontsize',12)
legend({'PC1: Level','PC2: Slope', 'PC3: Curvature'}, 'FontSize', 12, 'Location','best')




% principal components
newStockPrice=StockPrice*coeff;
PC=newStockPrice(:,1:3);


% Principal Factors in Yield Curve
FirstPC = 1/3*sum(StockPrice,2);
SecondPC = StockPrice(:,8)-StockPrice(:,1);
ThirdPC = 1/2*StockPrice(:,1)+1/2*StockPrice(:,6)-StockPrice(:,3);


figure(3)
plot(StockDate,PC(:,1),'r-','linewidth',1)
hold on
plot(StockDate,FirstPC,'b-','linewidth',1)
grid on
title('Level','Fontsize',14)
ylabel('Interest rate (%)', 'Fontsize',12)
legend({'PC1: Level','1/3*(sum all yields)'}, 'FontSize', 12, 'Location','best')



figure(4)
plot(StockDate,PC(:,2),'r-','linewidth',1)
hold on
plot(StockDate,SecondPC,'b-','linewidth',1)
grid on
title('Slope','Fontsize',14)
ylabel('Interest rate (%)', 'Fontsize',12)
legend({'PC2: Slope','10yr - 3m'}, 'FontSize', 12, 'Location','best')



figure(5)
plot(StockDate,PC(:,3),'r-','linewidth',1)
hold on
plot(StockDate,ThirdPC,'b-','linewidth',1)
grid on
title('Curvature','Fontsize',14)
ylabel('Interest rate (%)', 'Fontsize',12)
legend({'PC3: Curvature','1/2*3m + 1/2*5yr - 1yr'}, 'FontSize', 12, 'Location','best')





% Predicted market variables using the first 3 PCs
Estimation=PC*coeff(:,1:3)';



figure(6)
plot(StockDate,StockPrice(:,8),'r-','linewidth',1)
hold on
plot(StockDate,Estimation(:,8),'b-','linewidth',1)
grid on
title('10-Year Treasury Constant Maturity Rate','Fontsize',14)
ylabel('Interest rate (%)', 'Fontsize',12)
legend({'Observed','Predicted'}, 'FontSize', 12, 'Location','best')



