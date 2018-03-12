################################################
## import some packages
import pandas as pd
import nltk
import matplotlib.pyplot as plt
import numpy as np
import re
from collections import Counter
import scipy

################################################
##read the data file
filename = 'train_data.csv'

reviews = pd.read_csv(filename)
reviews.head()

################################################
## process the cata 
cata = reviews['categories'] 
try1 = cata[0]
def tolist(x):
    return(list(eval(x)))
res = cata[0:5].apply(tolist)
reviews['listcata'] = cata.apply(tolist)

## stars：
rev_star1 = reviews[reviews['stars'] == 1]
rev_star2 = reviews[reviews['stars'] == 2]
rev_star3 = reviews[reviews['stars'] == 3]
rev_star4 = reviews[reviews['stars'] == 4]
rev_star5 = reviews[reviews['stars'] == 5]

samp1 = reviews.iloc[0:6,:]
sampc1 = reviews['listcata'][0:6]   

## find how many unique catas are there in our review
res = []
for each in reviews['listcata']:
    res.extend(each)
len(res)
unique_cata = list(set(res))
len(unique_cata)
unique_cata[0:6]

## show the top 30 catas(maximum times)
counter ={}
for i in res: 
    counter[i] = counter.get(i, 0) + 1
xxx1 = sorted([ (freq,word) for word, freq in counter.items() ], reverse=True)[0:30]
xxx12 = [each[0] for each in xxx1]
plt.figure()
plt.grid()
plt.bar(range(len(xxx12)), xxx12)

## this part is to find the distriubtion of a gievn cata:
def plotcata(name , p = 0):
    def Findcata(x):
        if name in x: 
            return 1
        else:
            return 0
    n1 = sum(rev_star1['listcata'].apply(Findcata))
    n2 = sum(rev_star2['listcata'].apply(Findcata))
    n3 = sum(rev_star3['listcata'].apply(Findcata))  
    n4 = sum(rev_star4['listcata'].apply(Findcata))
    n5 = sum(rev_star5['listcata'].apply(Findcata))
    l1 = rev_star1.shape[0]
    l2 = rev_star2.shape[0]
    l3 = rev_star3.shape[0]
    l4 = rev_star4.shape[0]
    l5 = rev_star5.shape[0]
    num_list = np.array([n1/l1,n2/l2,n3/l3,n4/l4,n5/l5])
    if p ==1 :
        plt.figure()
        plt.grid()
        plt.title(name)
        plt.bar(range(len(num_list)), num_list)    
    return(num_list)

################################################
## process the city names
cities = reviews['city']
sampc1= cities[0:20]

## conver all city name into the lower case, delte the blank
## also conver all city name with saint into st
def chulistring(x):
    temp1 = re.sub('[\s.-]','',x).lower()
    return(re.sub('saint','st',temp1).lower())
reviews['newcites'] = cities.apply(chulistring)

## see how many unique cities there
rescit = reviews['newcites'].tolist()
len(rescit)
unique_cit = list(set(rescit))
len(unique_cit)
unique_cit[0:6]
counter ={}
for i in rescit: 
    counter[i] = counter.get(i, 0) + 1

## plot top 10 of the cities
xx2 = sorted([ (freq,word) for word, freq in counter.items() ], reverse=True)[0:10]
xx22 = [each[0] for each in xx2]
plt.figure()
plt.grid()
plt.title('Number of City(top20)')
plt.bar(range(len(xx22)), xx22)

## write the city name into a csv file
import csv
csvfile = open('cities.csv', 'w')
writer = csv.writer(csvfile)
writer.writerow(['number', 'city'])
writer.writerows(xx2)
csvfile.close()

################################################
## try to use the lat and lont to make some clusters

## example funciton
"""

sklearn.cluster.KMeans(n_clusters=8,
     init='k-means++', 
    n_init=10, 
    max_iter=300, 
    tol=0.0001, 
    precompute_distances='auto', 
    verbose=0, 
    random_state=None, 
    copy_x=True, 
    n_jobs=1, 
    algorithm='auto'
    )
estimator =sklearn.cluster.KMeans(n_clusters=3)# cluster
estimator.fit(data)# cluster
"""
import sklearn
from sklearn import cluster
## try on our onw data
newsam  = reviews[['longitude' , 'latitude']]

## chose the cluster as 3
estimator = sklearn.cluster.KMeans(n_clusters=3)
estimator.fit(newsam)

label_pred = estimator.labels_ # get cluster labels

labels = list(label_pred)
with open('cluster.txt','w',encoding = 'UTF-8') as f:
    for i in range(len(labels)):
        f.write(str(labels[i])+'\n')


centroids = estimator.cluster_centers_ # get cluster center
inertia = estimator.inertia_ # sum

## looking at the specify data
reviews['kmeanslabel'] = label_pred
kml0 = reviews[reviews['kmeanslabel'] == 0 ]
kml1 = reviews[reviews['kmeanslabel'] == 1 ]
kml2 = reviews[reviews['kmeanslabel'] == 2 ]

## plot each of them
tongji0 = []
for i in range(1,6):
    temp = len(kml0[kml0['stars']==i] )
    tongji0.append(temp/float(948784))
plt.figure()
plt.grid()
plt.title('Kmeans class 0')
plt.bar(range(1,6), tongji0)
tongji1 = []
for i in range(1,6):
    temp = len(kml1[kml1['stars']==i] )
    tongji1.append(temp/float(568373))
plt.figure()
plt.grid()
plt.title('Kmeans class 1')
plt.bar(range(1,6), tongji1)
tongji2 = []
for i in range(1,6):
    temp = len(kml2[kml2['stars']==i] )
    tongji2.append(temp/float(29222))
plt.figure()
plt.grid()
plt.title('Kmeans class 2')
plt.bar(range(1,6), tongji2)

################################################
## looking at the catas again:

"""
tempindex = []
listcata = list(reviews['listcata'])
for i in range(1546379):
    if 'Restaurants' in listcata[i]:
        next
    else:
        tempindex.append[i]
chainre = reviews['newcites'].groupby(reviews['name']).count() # wrong mainpulation
"""

## Use the groupby function to make a data set
newchain =  reviews.groupby(reviews['name']).newcites.nunique()

"""
    Name: 33950
    Chain: 951
"""

## plot some figures to help with the analysis
## make two new subset( chain name and unchain name)
chainname = list(newchain.index[newchain>2])
tpind = []
for i in range(1546379):
    if reviews['name'][i] in chainname:
        tpind.append(i)
chainreview = reviews.loc[tpind]
chainreview['stars'].mean()
unchainreview = reviews.drop(tpind)
unchainreview['stars'].mean()

## Plot the frequency of each stars
chainstarn = []
for i in range(1,6):
    chaintemp = len(chainreview[chainreview['stars'] == i])
    chainstarn.append(chaintemp/float(len(chainreview)))
unchainstarn = []
for i in range(1,6):
    unchaintemp = len( unchainreview[unchainreview['stars'] == i]  )
    unchainstarn.append(unchaintemp/float(len(unchainreview)))
    
################################################
## Consider about the wordvec 
    
## the package:
import gensim as gen

## Obaitn a small sample:
samind = np.random.randint(1546379,size = 50000)
sam = reviews.loc[samind]

################################################
## try the stopwords
from nltk.corpus import stopwords
from nltk.stem.wordnet import WordNetLemmatizer
import string
import gensim
from gensim import corpora

text5 = [text for text in rev_star1['text']]
##some basic mainuplation
stop = set(stopwords.words('english'))
exclude = set(string.punctuation)
lemma = WordNetLemmatizer()
## this is a text clean function
def clean(text):
    stop_free = " ".join([i for i in text.lower().split() if i not in stop])
    punc_free = ''.join(ch for ch in stop_free if ch not in exclude)
    normalized = " ".join(lemma.lemmatize(word) for word in punc_free.split())
    return normalized
## then, we split each text into some words
clean_text5 = [clean(text).split() for text in text5]

## convert the clean text into one-hot coding matrix
dictionary5 = corpora.Dictionary(clean_text5)
text5_term_matrix = [dictionary5.doc2bow(text) for text in clean_text5]

## do the modeling use the lda topics
Lda = gensim.models.ldamodel.LdaModel
ldamodel5 = Lda(text5_term_matrix, num_topics = 5, id2word = dictionary5, passes = 10)

print(ldamodel5.print_topics(num_topics=5, num_words=5))

################################################
## try to do the modeling
# first, we sample a sample text as text:
from nltk.tokenize import word_tokenize
from collections import Counter
#
samind = np.random.randint(1546379,size=100000)
samreview = reviews.loc[samind]
# Rearrange the index
samreview.index = range(100000)
# absorb the text info and convert all of them into lower case
###samtext = [each.lower().split() for each in samreview['text']]
# here we use word_tokenize to do the sentences to split
samtext = []
for each in samreview['text']:
    samtext.extend(word_tokenize(each.lower()))
# count how many each word apperaed in our review 
samtext_counter ={}
for i in samtext: 
    samtext_counter[i] = samtext_counter.get(i, 0) + 1
samword_most = sorted([ (freq,word) for word, freq in samtext_counter.items() ], reverse=True)[0:100]

##then, we redo the process on our whole dataset
################################################
## use the data from Zhou-Wenyan
from nltk.tokenize import word_tokenize
from collections import Counter

text = reviews['text']
text_pro = []

for each in text:
    each = re.sub('[-_~`!@#$%^&*()+={}[\]|:;"<>,.?/\\\]', " ", each)
    each = re.sub('[1234567890]', " ", each)
    text_pro.extend( word_tokenize(each.lower()) )
    
word_counter= {}
for i in text_pro:
    word_counter[i] = word_counter.get(i,0) +1
    
# Get the top200 most frequent words    
word_fre = [ (freq, word) for word,freq in word_counter.items()]  
word_top_200 = sorted(word_fre, reverse= True)[0:200]

words = list(word_counter.keys())

low_fre = []
for each in words:
    if int(word_counter[each]) == 1:
        low_fre.append(each)
## make a plot of rates for the number of words
l = []
lnew = range(20)
for i in lnew:
    low_fre = []
    for each in words:
        if int(word_counter[each]) <= i:
            low_fre.append(each)      
    l.append(len(low_fre))
    
lnew = np.array(l)
plt.figure()
plt.grid()
plt.plot(range(20), lnew , 'b--')

################################################
## esamble a package for us to do convert word into onehotcoding matrix
textsam = text[0:1000]
# make a list to delte something
del_word_list = []
for each in words:
    if int(word_counter[each]) <= 5:
        del_word_list.append(each)

def processs(x):
    each = x
    each = re.sub('[-_~`!@#$%^&*()+={}[\]|:;"<>,.?/\\\]', " ", each)
    each = re.sub('[1234567890]', " ", each)
    temp = word_tokenize(each.lower())
    tempnew = []
    for one in temp:
        if one not in del_word_list:
            tempnew.append(one)
    return(tempnew)
    
## we try to process a 10000 sample:
x1 = reviews['text'][0:10000].apply(processs)

################################################
## try to run the model:
newsamtest = reviews.loc[range(10000)]

## add the col of text words number
def callen(x):
    return(len(x.split(' ')))
newsamtest['nwords'] = newsamtest['text'].apply(callen)

## add the col of chainres lable
def findchain(x):
    #temp1 = re.sub('[\s.-]','',x).lower()
    #temp1 = re.sub('saint','st',temp1)
    if x in chainname:
        return(1)
    else:
        return(0)
reviews['chain'] = reviews['name'].apply(findchain)

##
from sklearn.feature_extraction.text import CountVectorizer
vectorizer = CountVectorizer(lowercase=True, stop_words="english")
## make the sparse matrix
matrix = vectorizer.fit_transform(newsamtest['text'])

## Use the word2vec:
from gensim.models import Word2Vec
model = Word2Vec(newsamtest['text'], size = 26905, min_count=3)
