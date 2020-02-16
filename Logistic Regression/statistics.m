clc
clear all


data = readtable('sample_logit.xlsx');

pred = data{:,2:10}; 
resp = data{:,11};

names=data.Properties.VariableNames;
param_names=names(2:10);


% Find Indices of Positive and Negative Examples
pos = find(resp == 1);
neg = find(resp == 0);

DefaultSample=pred(pos,:);
UndefaultSample=pred(neg,:);


myTable=stats(pred);
myTable.Properties.RowNames=param_names;
myTable

myTable2=stats(DefaultSample);
myTable2.Properties.RowNames=param_names;
myTable2

myTable3=stats(UndefaultSample);
myTable3.Properties.RowNames=param_names;
myTable3


% difference between default and undefault
difference=(myTable2{:,:}-myTable3{:,:})./myTable3{:,:};
myTable4 = array2table(difference);
myTable4.Properties.VariableNames=myTable.Properties.VariableNames;
myTable4.Properties.RowNames=param_names;
myTable4


function mytable=stats(x)

minval=min(x);
maxval=max(x);
meanval=mean(x);
medianval=median(x);
sd=std(x);

summary=[minval; maxval; meanval; medianval; sd];
summary=summary';

paramlist={'min','max','mean','median','sd'};
mytable = array2table(summary,'VariableNames',paramlist);

end


