from gensim.models import Word2Vec

train_review = []
file = open("train_review.txt", encoding = 'UTF-8')
for line in file.readlines():
    train_review.append(eval(line))
file.close()

w2v5 = Word2Vec(train_review, size = 5, window =5, workers=4, min_count=5)
w2v5.save('w2v5')

w2v100 = Word2Vec(train_review, size = 100, window =5, workers=4, min_count=5)
w2v100.save('w2v100')

w2v200 = Word2Vec(train_review, size = 200, window =5, workers=4, min_count=5)
w2v200.save('w2v200')
