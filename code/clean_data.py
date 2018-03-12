"""This code clean both train and test review data"""
import numpy as np
import pandas as pd
import re

########## load data ##########
train_data = pd.read_csv('train_data.csv')
test_data = pd.read_csv('testval_data.csv')

########## clean data ##########
### step1: add label for !!! !? ?! :) :-) :( :-(
spe_mark = []
for review in train_data['text']:
    mark = [0,0,0,0]
    if '!!' in review:
        mark[0] = 1
    if ('?!' in review) or ('!?' in review):
        mark[1] = 1
    if ':)' in review or ':-)' in review:
        mark[2] = 1
    if ':(' in review or ':-(' in review:
        mark[3] = 1
    spe_mark.append(mark)

### step2: lower case
train_data['text'] = train_data['text'].str.lower()

### step3: remove punctuation, digits, and split word
def process(x):
    each = x
    each = re.sub('[-_~`!@#$%^&*()+={}[\]|:;"<>,.?/\\\]', " ", each)
    each = re.sub('[1234567890]', " ", each)
    return each.lower().split()

train_data['cle_text'] = train_data['text'].apply(process)
train_data['nwords'] = train_data['cle_text'].apply(len)

### step4: word count
word_counter= {}
for i in train_data['cle_text']:
    for j in i:
        word_counter[j] = word_counter.get(j,0) +1

# Get the top200 most frequent words
word_fre = [(freq, word) for word,freq in word_counter.items()]
word_top_200 = sorted(word_fre, reverse= True)[0:200]
word_high = []
for item in word_fre:
    if item[0] > 20:
        word_high.append(item[1])

with open('word_high.txt','w',encoding = 'UTF-8') as f:
    for i in range(len(word_high)):
        f.write(str(word_high[i])+ '\n')

### step5: remove low freq words and meaningless high freq words
## This is our manually defined stop words
with open('stop.txt') as f:
    stop_word = []
    for value in f.readlines():
        value = value.strip('\n')
        stop_word.append(value)
stop_word[0] = 'a'
del(stop_word[-1])

## remove stop words
import copy
def stop(s):
    temp = copy.deepcopy(s)
    for word in s:
        if word in stop_word:
            index = temp.index(word)
            del(temp[index])
    return temp

train_review = train_data['cle_text']
train_review = train_review.apply(stop)

## get low freq words and remove them
word_high = []
for item in word_fre:
    if item[0] > 20:
        word_high.append(item[1])

def stop_low(s):
    temp = []
    for word in s:
        if word  in word_high:
            temp.append(word)
    return temp

train_review = train_review.apply(stop_low)
train_review_list = []
for review in train_review:
    train_review_list.append(review)

### step6: write clean reviews
with open('train_review.txt','w',encoding = 'UTF-8') as f: ### train_review.txt, test_review.txt
    for i in range(len(train_review_list)):
        f.write(str(train_review_list[i])+'\n')
