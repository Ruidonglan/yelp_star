from keras.models import Sequential
from keras.layers import Dense
import numpy as np

###################################################
## read data
np.random.seed(628)
##########################
mean_feature = []
file = open("mean_feature_train_200.txt",encoding = 'UTF-8')
i=0
for line in file.readlines():
    print(i)
    i+=1
    mean_feature.append(eval(line))
file.close()

mean_feature_model = np.array(mean_feature)
##########################
std_feature = []
file = open("std_feature.txt",encoding = 'UTF-8')
i = 0
nullstd = [0]*100
for line in file.readlines():
    print(i)
    i+=1
    try :
        std_feature.append(eval(line))
    except NameError:
        std_feature.append(nullstd)
file.close()

std_feature_model = np.array(std_feature)
##########################
text_len = []
## read len for all dataset
file = open("text_len_combine.txt", encoding = 'UTF-8')
for line in file.readlines():
    text_len.append(eval(line))
file.close()

text_len_model = np.array([text_len])
text_len_model = text_len_model.T

def nor(x, Min ,Max):
    temp = (x-Min)/(Max-Min)
    return(temp)
    
final_len = []
Min =min(text_len_model)
Max = max(text_len_model)

final_len = nor(text_len_model, Min,Max)

len_feature_train = final_len[0:1546379]
len_feature_test = final_len[1546379:]
##########################
stars = []
file = open("star.txt",encoding = 'UTF-8')
for line in file.readlines():
    stars.append(eval(line))
file.close()
##########################

Y = np.array(stars)

X = np.concatenate( (mean_feature_model, std_feature_model ), axis =1)

###################################################
################Text NNT Modeling##################
################And normalization##################
###################################################

## modeling:
model = Sequential()

## add hidden layer

model.add(Dense(25, input_dim = 400,kernel_initializer='normal', activation = 'sigmoid'))

model.add(Dense(25, activation = 'relu'))

## the out put layer
model.add(Dense(1, activation= 'linear'))

model.compile(loss = 'mse', optimizer = 'sgd', metrics = ['accuracy'])

history = model.fit(X, Y, nb_epoch = 64, batch_size = 500)

###################################################
X_text_feature = model.predict(X)

## read the dataset for test set
mean_feature_test = []
file = open("mean_feature200_test.txt",encoding = 'UTF-8')
i=0
for line in file.readlines():
    print(i)
    i+=1
    mean_feature_test.append(eval(line))
file.close()
mean_feature_test_model = np.array(mean_feature_test)

## the std
std_feature_test = []
file = open("std_feature200_test.txt",encoding = 'UTF-8')
i=0
for line in file.readlines():
    print(i)
    i+=1
    std_feature_test.append(eval(line))
file.close()
std_feature_test_model = np.array(std_feature_test)

temp_test_X_text =  np.concatenate( (mean_feature_test_model, std_feature_test_model), axis =1)

final_test_X_text = model.predict(temp_test_X_text)

###################################################
###################################################
#################Combine the text and Len##########
#################Do theFinal modeling #############
###################################################

## data preparation
X_final = np.concatenate((X_text_feature,len_feature_train ), axis=1)
## modeling initial:
model = Sequential()
## add two hidden layer:
model.add(Dense(5, input_dim = 2 ,kernel_initializer='normal', activation = 'sigmoid'))
model.add(Dense(5, activation = 'relu'))
## the out put layer:
model.add(Dense(1, activation= 'linear'))
## complie part:
model.compile(loss = 'mse', optimizer = 'sgd', metrics = ['accuracy'])
## Final Modeling:
history = model.fit(X_final, Y, nb_epoch = 64, batch_size = 500)

###################################################

## we may add a linear regression layer here

###################################################
## combine X for final test

X_final_test = np.concatenate((final_test_X_text,len_feature_test),axis = 1)

final_predictions = model.predict(X_final_test)

## make some arrangement for final predictions:
for i in range(len(final_predictions)):
    temp = final_predictions[i]
    if temp <=1:
        final_predictions[i] = 1
    if temp >=5:
        final_predictions[i] = 5
    print(i)

import pandas as pd

preds = pd.DataFrame(columns = ['Id', 'Prediction1'])

preds['Id'] = list(np.arange(1 , 1016665 , 1))
preds['Prediction1'] = final_predictions

preds.to_csv('preds.csv' , index = False)
