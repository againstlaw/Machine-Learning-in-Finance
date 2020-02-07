clc
clear all


% Load data
filename = 'countryriskdata.csv';
Data=readtable(filename);

myData=Data{:,3:6};


% standardization
% Standardized z-scores
Z = zscore(myData);


% k-means clustering
k=3;
[idx,C] = kmeans(Z,k);

countries=Data.Country;
countries(idx==1)   % low risk
countries(idx==2)   % high risk
countries(idx==3)   % moderate risk


% Create silhouette plots
clust = kmeans(Z,k);
silhouette(Z,clust,'Euclidean')


% Compute the silhouette values
h=silhouette(Z,clust,'Euclidean');

silhouette_score=mean(h)
