clc
clear all


data = readtable('sample_logit.xlsx');

pred = data{:,2:10}; 
resp = data{:,11};

names=data.Properties.VariableNames;
param_names=names(2:10);


% logistic regression

mdl = fitglm(pred,resp,'Distribution','binomial','Link','logit');
score_log = mdl.Fitted.Probability;

[Xlog,Ylog,Tlog,AUClog] = perfcurve(resp,score_log,true);



% SVM classifier

mdlSVM = fitcsvm(pred,resp,'Standardize',true);

mdlSVM = fitPosterior(mdlSVM);
[~,score_svm] = resubPredict(mdlSVM);

[Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(resp,score_svm(:,logical(mdlSVM.ClassNames)),true);



%  naive Bayes classifier

mdlNB = fitcnb(pred,resp);

[~,score_nb] = resubPredict(mdlNB);

[Xnb,Ynb,Tnb,AUCnb] = perfcurve(resp,score_nb(:,logical(mdlNB.ClassNames)),true);




figure(1)
plot(Xlog,Ylog,'r','LineWidth',1)
hold on
plot(Xsvm,Ysvm,'b','LineWidth',1)
plot(Xnb,Ynb,'k','LineWidth',1)
legend('Logistic Regression','Support Vector Machines','Naive Bayes','Location','Best')
xlabel('False positive rate');
ylabel('True positive rate');
title('ROC Curves for Logistic Regression, SVM, and Naive Bayes Classification')
hold off

