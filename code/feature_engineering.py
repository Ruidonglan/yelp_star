import numpy as np
from gensim.models import Word2Vec
w2v5 = Word2Vec.load('w2v5')
w2v100 = Word2Vec.load('w2v100')
w2v200 = Word2Vec.load('w2v200')

########## read train and test data ##########
test_review = []
file = open("test_review.txt", encoding = 'UTF-8')
for line in file.readlines():
    test_review.append(eval(line))
file.close()

for i in range(len(test_review)):
    if len(test_review[i]) == 0:
        test_review[i] = ['']


train_review = []
file = open("train_review.txt", encoding = 'UTF-8')
for line in file.readlines():
    train_review.append(eval(line))
file.close()

for i in range(len(train_review)):
    if len(train_review[i]) == 0:
        train_review[i] = ['']

########## get text length for train ##########
text_len = []
for i in train_review:
    text_len.append(len(i))

with open('text_len_train.txt', 'w', encoding = 'UTF-8') as f:
    for i in range(len(text_len)):
        f.write(str(text_len[i]) + '\n')

########## get text length for text ##########
text_len = []
for i in test_review:
    text_len.append(len(i))

with open('text_len_test.txt', 'w', encoding = 'UTF-8') as f:
    for i in range(len(text_len)):
        f.write(str(text_len[i]) + '\n')

########## get text length for combine ##########
combine = train_review + test_review
text_len = []
for i in combine:
    text_len.append(len(i))

with open('text_len_combine.txt', 'w', encoding = 'UTF-8') as f:
    for i in range(len(text_len)):
        f.write(str(text_len[i]) + '\n')

########## create mean feature for train ##########
count = 0
mean_feature = []
n = len(train_review)
dim = 200
for i in range(n):
    temp = train_review[i]
    l = len(temp)
    temp2 = []
    for each in temp:
        temp2.append(w2v200.wv[each]) ### w2v5, w2v100, w2v200
    temp = []
    for i in range(dim):
        newtemp = [one[i] for one in temp2]
        temp.append(sum(newtemp)/l)
    mean_feature.append(temp)
    count+=1
    print(count)

with open('combine_train_mean_200.txt', 'w', encoding = 'UTF-8') as f: ### combine_train_mean_5.txt, combine_train_mean_100.txt, combine_train_mean_200.txt
    for i in range(len(mean_feature)):
        f.write(str(mean_feature[i])+'\n')

########## create mean feature for test ##########
count = 0
mean_feature = []
n = len(test_review)
dim = 200
for i in range(n):
    temp = test_review[i]
    l = len(temp)
    temp2 = []
    for each in temp:
        temp2.append(w2v200.wv[each]) ### w2v5, w2v100, w2v200
    temp = []
    for i in range(dim):
        newtemp = [one[i] for one in temp2]
        temp.append(sum(newtemp)/l)
    mean_feature.append(temp)
    count+=1
    print(count)

with open('combine_test_mean_200.txt', 'w', encoding = 'UTF-8') as f: ### combine_test_mean_5.txt, combine_test_mean_100.txt, combine_test_mean_200.txt
    for i in range(len(mean_feature)):
        f.write(str(mean_feature[i])+'\n')
        
########## create std feature for train ##########
count = 0
std_feature = []
n = len(train_review)
dim = 200
for i in range(n):
    temp = train_review[i]
    l = len(temp)
    temp2 = []
    for each in temp:
        temp2.append(w2v200.wv[each]) ### w2v5, w2v100, w2v200
    temp = []
    for i in range(dim):
        newtemp = [one[i] for one in temp2]
        newtemp = np.array(newtemp)
        temp.append(np.std(newtemp))
    std_feature.append(temp)
    count += 1
    print(count)
    
with open('combine_train_std_200.txt', 'w', encoding = 'UTF-8') as f: ### combine_train_std_5.txt, combine_train_std_100.txt, combine_train_std_200.txt
    for i in range(len(std_feature)):
        f.write(str(std_feature[i])+'\n')

########## create std feature for test ##########
count = 0
std_feature = []
n = len(test_review)
dim = 200
for i in range(n):
    temp = test_review[i]
    l = len(temp)
    temp2 = []
    for each in temp:
        temp2.append(w2v200.wv[each]) ### w2v5, w2v100, w2v200
    temp = []
    for i in range(dim):
        newtemp = [one[i] for one in temp2]
        newtemp = np.array(newtemp)
        temp.append(np.std(newtemp))
    std_feature.append(temp)
    count += 1
    print(count)
        
with open('combine_test_std_200.txt', 'w', encoding = 'UTF-8') as f: ### combine_test_std_5.txt, combine_test_std_100.txt, combine_test_std_200.txt
    for i in range(len(std_feature)):
        f.write(str(std_feature[i])+'\n')

