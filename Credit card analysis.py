#!/usr/bin/env python
# coding: utf-8

# In[ ]:


# This is an analysis aboout the correlations found in credit card Dataset

# Import libraries

import pandas as pd
import numpy as np
import seaborn as sns

import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
import matplotlib
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (15,11)

pd.options.mode.chained_assignment = None


# In[ ]:


# Reading and loading our Data

df = pd.read_csv(r'/Users/nicolpineda/Downloads/BankChurners.csv')
df.head()


# In[ ]:


#Changing column names for a better vizualization 

df_new = df.rename(columns = {'Naive_Bayes_Classifier_Attrition_Flag_Card_Category_Contacts_Count_12_mon_Dependent_count_Education_Level_Months_Inactive_12_mon_1': 'Months_inactive_1', 'Naive_Bayes_Classifier_Attrition_Flag_Card_Category_Contacts_Count_12_mon_Dependent_count_Education_Level_Months_Inactive_12_mon_2' : 'Months_inactive_2'})

#Arranging columns for sorting

first_column = df_new.pop('Card_Category')
df_new.insert(0, 'Card_Category', first_column)

fourth_column = df_new.pop('Credit_Limit')
df_new.insert(3, 'Credit_Limit', fourth_column)

fifth_column = df_new.pop('Income_Category')
df_new.insert(4, 'Income_Category', fifth_column)

df_new.head()


# In[ ]:


#Filtering missing data

for col in df_new.columns:
    missing_data = np.mean(df_new[col].isnull())
    print('{} - {}%'.format(col, round(missing_data*100)))


# In[ ]:


#Data types 

df_new.dtypes


# In[ ]:


#Drop any duplictes
df_new["CLIENTNUM"].drop_duplicates().sort_values(ascending = False)


# In[ ]:


#Sorting 

df_new.sort_values(by = ['Credit_Limit'], ascending = False)


# In[ ]:


pd.set_option('display.max_rows', None)


# In[ ]:


#Correlation between Income Category and Credit Limit

import matplotlib.pyplot as plt
plt.scatter(x = 'Income_Category', y= 'Credit_Limit')
plt.title("Income Category vs Credit Limit")
plt.xlabel("Yearly Income")
plt.ylabel("Credit Limit")

plt.show()


# In[ ]:


import seaborn as sns
import pandas as pd
df = pd.read_csv(r'/Users/nicolpineda/Downloads/BankChurners.csv')

sns.regplot(x="Income_Category", y="Credit_Limit", data= df, scatter_kws = {"color" : "red"}, line_kws = {"color" : "blue"})


# In[ ]:



df_new.corr(method ='pearson')


# In[ ]:


df_new.corr(method ='kendall')


# In[ ]:


df_new.corr(method ='spearman')


# In[ ]:


plt.figure(figsize = (15, 11))
correlation_matrix = df_new.corr()

sns.heatmap(correlation_matrix, annot = True, linewidths = 1)

plt.title("Correlation matrix for Numeric Features")

plt.xlabel("Card features")

plt.ylabel("Card features")

plt.show()


# In[ ]:


df_new.head()


# In[ ]:


df_numerized = df_new


for col_name in df_numerized.columns:
    if(df_numerized[col_name].dtype == 'object'):
        df_numerized[col_name]= df_numerized[col_name].astype('category')
        df_numerized[col_name] = df_numerized[col_name].cat.codes
        
df_numerized


# In[ ]:


plt.figure(figsize = (20, 16))
correlation_matrix = df_numerized.corr()

sns.heatmap(correlation_matrix, annot = True, linewidths = 1)

plt.title("Correlation matrix for Numeric Features")

plt.xlabel("Card features")

plt.ylabel("Card features")

plt.show()


# In[ ]:


df_numerized.corr(method='pearson')


# In[ ]:


correlation_mat = df_numerized.apply(lambda x: x.factorize()[0]).corr()

corr_pairs = correlation_mat.unstack()

print(corr_pairs)


# In[ ]:


sorted_pairs = corr_pairs.sort_values(kind="quicksort")

print(sorted_pairs)


# In[ ]:


strong_pairs = sorted_pairs[abs(sorted_pairs) > 0.5]

print(strong_pairs)


# In[ ]:




