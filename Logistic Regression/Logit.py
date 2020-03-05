
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

from sklearn.linear_model import LogisticRegression
from sklearn.metrics import roc_curve
from sklearn.metrics import roc_auc_score
from sklearn.metrics import confusion_matrix



# function to plot the ROC curves
def plot_roc_curve(fpr, tpr):
    plt.plot(fpr, tpr, color='orange', label='ROC')
    plt.plot([0, 1], [0, 1], color='darkblue', linestyle='--')
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.title('Receiver Operating Characteristic (ROC) Curve')
    plt.legend()
    plt.show()



# Load data
filename = 'sample_logit.xlsx'

data = pd.read_excel(filename)

X = data.iloc[:,1:10]
y = data['default_f1']


clf = LogisticRegression(C=1e9).fit(X, y)

#clf = LogisticRegression().fit(X, y)

y_pred = clf.predict(X)

y_pred_prob = clf.predict_proba(X)[:,1]

fpr, tpr, thresholds = roc_curve(y, y_pred_prob)

plot_roc_curve(fpr, tpr)


auc = roc_auc_score(y, y_pred_prob)
print('AUC: %.2f' % auc)


my_confusion_matrix = confusion_matrix(y_pred, y)
print(my_confusion_matrix)


"""
df = pd.DataFrame(X.columns, clf.coef_.T).reset_index()
df.columns = ['Coef', 'Feature']
print(df)
"""


df = pd.DataFrame(clf.coef_.T, X.columns, columns=['Coef'])
df.loc['(Intercept)'] = clf.intercept_
print(df)



