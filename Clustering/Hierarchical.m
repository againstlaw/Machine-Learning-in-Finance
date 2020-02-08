clc
clear all


% Load data
filename = 'countryriskdata.csv';
Data=readtable(filename);

myData=Data{:,3:6};

% standardization
% Standardized z-scores
Z = zscore(myData);


% Hierarchical Clustering
cosD = pdist(Z,'cosine');
clustTreeCos = linkage(cosD,'average');
cophenet(clustTreeCos,cosD)


% To visualize the hierarchy of clusters
figure(1)
[h,nodes] = dendrogram(clustTreeCos,0);
h_gca = gca;
h_gca.TickDir = 'out';
h_gca.TickLength = [.002 0];
h_gca.XTickLabel = [];


ptsymb = {'bs','r^','md','go','c+'};

hidx = cluster(clustTreeCos,'criterion','distance','cutoff',0.9);

figure(2)
for i = 1:3
    clust = find(hidx==i);
    plot3(Z(clust,2),Z(clust,3),Z(clust,4),ptsymb{i});
    hold on
end
hold off

colnames=Data.Properties.VariableNames;
names=colnames(3:6);

xlabel(names(2));
ylabel(names(3));
zlabel(names(4));
grid on



countries=Data.Country;
countries(hidx==1)   % high risk
countries(hidx==2)   % moderate risk
countries(hidx==3)   % low risk

