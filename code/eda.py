import numpy as np
import matplotlib.pyplot as plt
import re
import pandas as pd
from nltk.corpus import stopwords
from nltk.stem.wordnet import WordNetLemmatizer
import string
import gensim
from gensim import corpora

clean_train_data = pd.read_csv('clean_train_data.csv')

### wordcloud
from wordcloud import WordCloud
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
stops = set(stopwords.words('english'))
five_stars = clean_train_data.loc[clean_train_data['stars'] == 5]
four_stars = clean_train_data.loc[clean_train_data['stars'] == 4]
three_stars = clean_train_data.loc[clean_train_data['stars'] == 3]
two_stars = clean_train_data.loc[clean_train_data['stars'] == 2]
one_stars = clean_train_data.loc[clean_train_data['stars'] == 1]

five_stars_text = five_stars['text'].to_string()
five_stars_text = re.sub('[^a-zA-Z]',' ',five_stars_text)
five_stars_word_tokens = word_tokenize(five_stars_text)
five_stars_word_tokens = [w for w in five_stars_word_tokens if not w in stops]
five_stars_word_tokens = [w for w in five_stars_word_tokens if not w in ['place','food','service','went','ive','time','one','restaurant','first','pizza','really','go','always','came','im','vegas','ever','lunch']]
five_stars_word_tokens = [w for w in five_stars_word_tokens if not w in ['place','went','restaurant','ordered','came','th','got','first','time','food','go','review','ive','im','really']]
wordcloud5_text = ' '.join(word for word in five_stars_word_tokens)
wordcloud5 = WordCloud(background_color="white",width=1000, height=860, margin=2).generate(wordcloud5_text)
plt.imshow(wordcloud5)
plt.axis("off")
plt.show()

one_stars_text = one_stars['text'].to_string()
one_stars_text = re.sub('[^a-zA-Z]',' ',one_stars_text)
one_stars_word_tokens = word_tokenize(one_stars_text)
one_stars_word_tokens = [w for w in one_stars_word_tokens if not w in stops]
one_stars_word_tokens = [w for w in one_stars_word_tokens if not w in ['place','went','restaurant','ordered','came','th','got','first','time','food','good','go','review']]
wordcloud1_text = ' '.join(word for word in one_stars_word_tokens)
wordcloud1 = WordCloud(background_color="white",width=1000, height=860, margin=2).generate(wordcloud1_text)
plt.imshow(wordcloud1)
plt.axis("off")
plt.show()

### lda
train_data = pd.read_csv("train_data.csv")
stars5 = train_data.loc[train_data['stars'] == 5]
stars1 = train_data.loc[train_data['stars'] == 1]
text5 = [text for text in stars5['text']]
text1 = [text for text in stars1['text']]

stop = set(stopwords.words('english'))
exclude = set(string.punctuation)
lemma = WordNetLemmatizer()

def clean(text):
    stop_free = " ".join([i for i in text.lower().split() if i not in stop])
    punc_free = ''.join(ch for ch in stop_free if ch not in exclude)
    normalized = " ".join(lemma.lemmatize(word) for word in punc_free.split())
    return normalized

clean_text5 = [clean(text).split() for text in text5]
clean_text1 = [clean(text).split() for text in text1]

dictionary5 = corpora.Dictionary(clean_text5)
text5_term_matrix = [dictionary5.doc2bow(text) for text in clean_text5]

dictionary1 = corpora.Dictionary(clean_text1)
text1_term_matrix = [dictionary1.doc2bow(text) for text in clean_text1]

Lda = gensim.models.ldamodel.LdaModel
ldamodel5 = Lda(text5_term_matrix, num_topics = 1, id2word = dictionary5)
print(ldamodel5.print_topics(num_topics=3, num_words=3))

ldamodel1 = Lda(text1_term_matrix, num_topics = 1, id2word = dictionary1)
print(ldamodel1.print_topics(num_topics=3, num_words=3))


