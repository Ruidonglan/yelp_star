import numpy as np

df = []
file = open("clean_text.txt",encoding = 'UTF-8')
for line in file.readlines():
    df.append(eval(line))
file.close()

from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.feature_extraction.text import CountVectorizer
texts = [" ".join(df[i]) for i in range(1546379)]
vectorizer = TfidfVectorizer(stop_words="english")
vectorizer = CountVectorizer(stop_words="english")
matrix = vectorizer.fit_transform(texts)

text_len = []
file = open("text_len.txt", encoding = 'UTF-8')
for line in file.readlines():
    text_len.append(eval(line))
file.close()
text_len_tem = [[i] for i in text_len]
text_len = np.array(text_len_tem)

spe_mark = []
file = open("special_mark.txt", encoding = 'UTF-8')
for line in file.readlines():
    spe_mark.append(eval(line))
file.close()
spe_mark_tem = [[i] for i in spe_mark]
spe_mark = np.array(spe_mark_tem)

from scipy.sparse import coo_matrix, hstack, csr_matrix
matrix_all = hstack([matrix, text_len])
matrix_all = csr_matrix(matrix_all)

star = []
file = open("star.txt", encoding = 'UTF-8')
for line in file.readlines():
    star.append(eval(line))
file.close()

from sklearn.model_selection import train_test_split
X_train, X_test, Y_train, Y_test = train_test_split(matrix, star, test_size=0.2, random_state=628)

# Multinomial Bayes
from sklearn.naive_bayes import MultinomialNB
nb = MultinomialNB()
pred_nb = nb.fit(X_train, Y_train).predict(X_test)

rmse = (sum((pred_nb - Y_test)**2)/len(Y_test))**0.5

# lasso
from sklearn import linear_model
clf = linear_model.Lasso(alpha = 0.1)
pred_lasso = clf.fit(X_train, Y_train).predict(X_test)

rmse = (sum((pred_lasso - Y_test)**2)/len(Y_test))**0.5

# svr
from sklearn import svm
svr_model = svm.SVR(cache_size = 500)
pred_svr = svr_model.fit(X_train,Y_train).predict(X_test)

rmse = (sum((pred_svr - Y_test)**2)/len(Y_test))**0.5

