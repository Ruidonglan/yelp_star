library(plyr)
library(dplyr)
library(readr)
library(SenSrivastava)
library(ggplot2)
library(ggmap)
library(hexbin)
library(data.table)
library(choroplethrMaps)
library(choroplethr)
library(mapproj)
library(tidyr)
library(lubridate)
library(nycflights13)
library(stringr)
library(TSA)
library(forecast)
library(ModelMetrics)
library(forecast)
library(cowplot)
library(stringr)

yelp = read_csv("train_data.csv")
#bar chart for all
ggplot(data = yelp) +
  geom_bar(mapping = aes(x = stars)) +
  ggtitle("Bar Chart for Stars") +
  theme_bw() + 
  theme(text=element_text(family = "Tahoma"),
        axis.text.x = element_text(colour="black", size = 20),
        axis.text.y = element_text(colour="black", size = 20),
        axis.title.x = element_text(colour="black", size = 26),
        axis.title.y = element_text(colour="black", size = 26),
        title = element_text(colour="black", size = 32),
        axis.line = element_line(size=0.3, colour = "black"),
        plot.title = element_text(hjust = 0.5)) +
  scale_y_continuous(name = "Count",
                     breaks = seq(0, 600000, 200000),
                     limits=c(0, 600000),
                     labels = c("0","200000","400000","600000")) +
  ylab("Stars")
ggsave("stars_distribution.png", width = 30, height = 25, units = "cm") 



ggplot(data = yelp) +
  geom_point(mapping = aes(x = longitude, y = latitude), size = .01)
ggsave("city_distribution.png", width = 30, height = 25, units = "cm") 

#word counts at different stars using small sample.
subset = yelp
words = subset$text %>% strsplit(" ")
word_count = rep(NA,length(words))
for (i in 1:length(words)) {
  word_count[i] = length(words[[i]])
}
subset = subset %>% mutate(length = word_count, stars = as.factor(stars))
#ggplot(data = subset %>% filter(length < 400), mapping = aes(x = length, colour = stars)) +
#  geom_freqpoly(bins = 200)
star1 = ggplot(data = subset %>% filter(stars == 1)) + 
  geom_density(mapping = aes(x = length),adjust = .1) + 
  theme(text=element_text(family = "Tahoma"),
        axis.title = element_text(face="bold"),
        axis.text.x = element_text(colour="black", size = 11),
        axis.text.y = element_text(colour="black", size = 9),
        axis.line = element_line(size=0, colour = "black"),
        plot.title = element_text(hjust = 0.5)) +
  theme_bw() +
  scale_y_continuous(name = "Density",
                     breaks = seq(0, 0.025, 0.005),
                     limits=c(0, 0.025)) +
  scale_x_continuous(name = "Words",
                   breaks = seq(0, 1000, 250),
                   limits=c(0, 1001))+
  ggtitle("1 Star")
star2 = ggplot(data = subset %>% filter(stars == 2)) + 
  geom_density(mapping = aes(x = length),adjust = .1) + 
  theme(text=element_text(family = "Tahoma"),
        axis.title = element_text(face="bold"),
        axis.text.x = element_text(colour="black", size = 11),
        axis.text.y = element_text(colour="black", size = 0),
        axis.line = element_line(size=0, colour = "black"),
        plot.title = element_text(hjust = 0.5),
        strip.background = element_blank(), strip.placement = "outside") +
  theme_bw()+
  scale_y_continuous(name = NULL,
                     breaks = seq(0, 0.025, 0.005),
                     limits=c(0, 0.025))+
  scale_x_continuous(name = "Words",
                   breaks = seq(0, 1000, 250),
                   limits=c(0, 1000))+
  ggtitle("2 Stars")
star3 = ggplot(data = subset %>% filter(stars == 3)) + 
  geom_density(mapping = aes(x = length),adjust = .1) + 
  theme(text=element_text(family = "Tahoma"),
        axis.title = element_text(face="bold"),
        axis.text.x = element_text(colour="black", size = 11),
        axis.text.y = element_text(colour="black", size = 0),
        axis.line = element_line(size=0, colour = "black"),
        plot.title = element_text(hjust = 0.5),
        strip.background = element_blank(), strip.placement = "outside") +
  theme_bw()+
  scale_y_continuous(name = NULL,
                     breaks = seq(0, 0.025, 0.005),
                     limits=c(0, 0.025))+
  scale_x_continuous(name = "Words",
                   breaks = seq(0, 1000, 250),
                   limits=c(0, 1000))+
  ggtitle("3 Stars")
star4 = ggplot(data = subset %>% filter(stars == 4)) + 
  geom_density(mapping = aes(x = length),adjust = .1) + 
  theme(text=element_text(family = "Tahoma"),
        axis.title = element_text(face="bold"),
        axis.text.x = element_text(colour="black", size = 11),
        axis.text.y = element_text(colour="black", size = 0),
        axis.line = element_line(size=0, colour = "black"),
        plot.title = element_text(hjust = 0.5),
        strip.background = element_blank(), strip.placement = "outside") +
  theme_bw()+
  scale_y_continuous(name = NULL,
                     breaks = seq(0, 0.025, 0.005),
                     limits=c(0, 0.025))+
  scale_x_continuous(name = "Words",
                   breaks = seq(0, 1000, 250),
                   limits=c(0, 1000))+
  ggtitle("4 Stars")
star5 = ggplot(data = subset %>% filter(stars == 5)) + 
  geom_density(mapping = aes(x = length),adjust = .1) + 
  theme(text=element_text(family = "Tahoma"),
        axis.title = element_text(face="bold"),
        axis.text.x = element_text(colour="black", size = 11),
        axis.text.y = element_text(colour="black", size = 0),
        axis.line = element_line(size=0, colour = "black"),
        plot.title = element_text(hjust = 0.5),
        strip.background = element_blank(), strip.placement = "outside") +
  theme_bw()+
  scale_y_continuous(name = NULL,
                     breaks = seq(0, 0.028, 0.004),
                     limits=c(0, 0.028))+
  scale_x_continuous(name = "Words",
                     breaks = seq(0, 1000, 250),
                     limits=c(0, 1000))+
  ggtitle("5 Stars")
plot_grid(star1,star2,star3,star4,star5,labels = NULL, nrow = 1,align = "h")

ggsave("density_with_stars.png", width = 30, height = 10, units = "cm") 

###### Categories
cata = subset$categories %>% strsplit("', '")
for (i in 1:length(cata)) {
  cata[[i]][1] <- (cata[[i]][1] %>% strsplit("'"))[[1]][2]
  cata[[i]][cata[[i]] %>% length] <- (cata[[i]][cata[[i]] %>% length] %>% strsplit("'"))[[1]][1]
}
count = 0
for (i in 1:length(cata)) {
  count = count + length(cata[[i]])
}
cata1 = rep(0,count)

check_cata <- function(x,y){
  index = rep(0,length(x))
  for (i in 1:length(x)) {
    if(sum(x[[i]] == y) == 1){
      index[i] = 1
    }else{
      index[i] = 0
    }
  }
  return(index)
}

subset[which(check_cata(cata,"Restaurants") == F),] %>% View
cata[[which(check_cata(cata,"Restaurants") == F)[1]]] %>% View
 
subset[which(check_cata(cata,"Department Stores") == T),] %>% View


#### fast food, chinese food etc
subset = subset %>% mutate(is.fastfood = as.factor(check_cata(cata,"Fast Food")), stars = as.numeric(stars))
fastfood1 = ggplot(data = subset %>% filter(is.fastfood == 1)) + 
  geom_bar(mapping = aes(x = stars, y = ..prop.., group = 1))+
  scale_y_continuous(name = NULL,
                     breaks = seq(0, 0.4, 0.1),
                     limits=c(0, 0.4))
fastfood2 = ggplot(data = subset %>% filter(is.fastfood == 0)) + 
  geom_bar(mapping = aes(x = stars, y = ..prop.., group = 1))+
  scale_y_continuous(name = NULL,
                     breaks = seq(0, 0.4, 0.1),
                     limits=c(0, 0.4))
plot_grid(fastfood1,fastfood2,labels = NULL, nrow = 1,align = "h")


subset = subset %>% mutate(is.coffee = as.factor(check_cata(cata,"Coffee & Tea")), stars = as.numeric(stars))
coffee1 = ggplot(data = subset %>% filter(is.coffee == 1)) + 
  geom_bar(mapping = aes(x = stars, y = ..prop.., group = 1))+
  scale_y_continuous(name = NULL,
                     breaks = seq(0, 0.5, 0.1),
                     limits=c(0, 0.5))
coffee2 = ggplot(data = subset %>% filter(is.coffee == 0)) + 
  geom_bar(mapping = aes(x = stars, y = ..prop.., group = 1))+
  scale_y_continuous(name = NULL,
                     breaks = seq(0, 0.5, 0.1),
                     limits=c(0, 0.5))
plot_grid(coffee1,coffee2,labels = NULL, nrow = 1,align = "h")


subset = subset %>% mutate(is.chinese = as.factor(check_cata(cata,"Chinese")), stars = as.numeric(stars))
chinese1 = ggplot(data = subset %>% filter(is.chinese == 1)) + 
  geom_bar(mapping = aes(x = stars, y = ..prop.., group = 1))+
  scale_y_continuous(name = NULL,
                     breaks = seq(0, 0.5, 0.1),
                     limits=c(0, 0.5))
chinese2 = ggplot(data = subset %>% filter(is.chinese == 0)) + 
  geom_bar(mapping = aes(x = stars, y = ..prop.., group = 1))+
  scale_y_continuous(name = NULL,
                     breaks = seq(0, 0.5, 0.1),
                     limits=c(0, 0.5))
plot_grid(chinese1,chinese2,labels = NULL, nrow = 1,align = "h")

subset = subset %>% mutate(is.dep = as.factor(check_cata(cata,"Shopping")), stars = as.numeric(stars))
fastfood1 = ggplot(data = subset %>% filter(is.dep == 1)) + 
  geom_bar(mapping = aes(x = stars, y = ..prop.., group = 1))+
  scale_y_continuous(name = NULL,
                     breaks = seq(0, 0.4, 0.1),
                     limits=c(0, 0.4))
fastfood2 = ggplot(data = subset %>% filter(is.dep == 0)) + 
  geom_bar(mapping = aes(x = stars, y = ..prop.., group = 1))+
  scale_y_continuous(name = NULL,
                     breaks = seq(0, 0.4, 0.1),
                     limits=c(0, 0.4))
plot_grid(fastfood1,fastfood2,labels = NULL, nrow = 1,align = "h")


a = subset %>% mutate(stars = as.numeric(stars)) %>% filter(is.dep == 1)
a$stars %>% mean
a = yelp %>% filter(city == "Henderson")
a$longitude %>% summary()
a$latitude %>% summary()





######categories frequency
cf = tribble(
  ~categories,       ~freq,
  "Nightlife",       316212,
  "Bars",        306568,
  "Food",        293370,
  "American (New)",       247549,
  "American (Traditional)",       234035,
  "Breakfast & Brunch",      198066,
  "Sandwiches",     142801,
  "Mexican",         140678,
  "Italian",    138698
)
ggplot(data = cf) +
  geom_bar(mapping = aes(x = categories, y = freq),stat = "identity") +
  ggtitle("Bar Chart for Categories(Top 10)") +
  theme_bw() +
  theme(plot.title = element_text(colour = "black", face = "bold", size = 20, vjust = 1)) +
  theme(text=element_text(family = "Tahoma"),
        axis.text.x = element_text(colour="black", size = 8),
        axis.text.y = element_text(colour="black", size = 9),
        axis.title.x = element_text(colour="black", size = 15),
        axis.title.y = element_text(colour="black", size = 15),
        title = element_text(colour="black", size = 32),
        axis.line = element_line(size=0.3, colour = "black"),
        plot.title = element_text(hjust = 0.5)) +
  scale_y_continuous(name = "Count",
                     breaks = seq(0, 300000, 100000),
                     limits=c(0, 350000),
                     labels = c("0","100000","200000","300000")) +
  geom_text(aes(x= categories, y = freq, label = freq),vjust = -.5)
ggsave("categories_freq.png", width = 30, height = 10, units = "cm") 

###Cities freq
city = tribble(
  ~cities,       ~freq,
  "Las vegas",       457350,
  "Phoenix",        160070,
  "Toronto",        147006,
  "Scottsdale",       87923,
  "Charlotte",       73527,
  "Pittsburgh",   60421,
  "Tempe",      45731,
  "Montreal",     43318,
  "Henderson",         39756,
  "Chandler",    33011
)
ggplot(data = city) +
  geom_bar(mapping = aes(x = cities, y = freq),stat = "identity") +
  ggtitle("Reviews Count of Cities(Top 10)") +
  theme_bw() +
  theme(plot.title = element_text(colour = "black", face = "bold", size = 20, vjust = 1)) +
  theme(text=element_text(family = "Tahoma"),
        axis.text.x = element_text(colour="black", size = 10),
        axis.text.y = element_text(colour="black", size = 10),
        axis.title.x = element_text(colour="black", size = 15),
        axis.title.y = element_text(colour="black", size = 15),
        title = element_text(colour="black", size = 32),
        axis.line = element_line(size=0.3, colour = "black"),
        plot.title = element_text(hjust = 0.5)) +
  scale_y_continuous(name = "Count",
                     breaks = seq(0, 450000, 150000),
                     limits=c(0, 480000),
                     labels = c("0","150000","300000","450000")) +
  geom_text(aes(x= cities, y = freq, label = freq),vjust = -.5)
ggsave("cities_freq.png", width = 30, height = 13, units = "cm") 


###top chain restaurant
chain = tribble(
  ~name,       ~numcities,
  "McDonald's",       185,
  "Pizza Hut",        95,
  "Taco Bell",        88,
  "Subway",       86,
  "Panera Bread",       79,
  "Burger King",   76,
  "Wendy's",      73,
  "Domino's Pizza",     70,
  "Chipotle Mexican Grill",         69,
  "Jimmy John's",    54
)
ggplot(data = chain) +
  geom_bar(mapping = aes(x = name, y = numcities),stat = "identity") +
  ggtitle("Number of Cities Appeared of Top 10 Chain") +
  theme_bw() +
  theme(plot.title = element_text(colour = "black", face = "bold", size = 20, vjust = 1)) +
  theme(text=element_text(family = "Tahoma"),
        axis.text.x = element_text(colour="black", size = 9),
        axis.text.y = element_text(colour="black", size = 10),
        axis.title.x = element_text(colour="black", size = 15),
        axis.title.y = element_text(colour="black", size = 15),
        title = element_text(colour="black", size = 32),
        axis.line = element_line(size=0.3, colour = "black"),
        plot.title = element_text(hjust = 0.5)) +
  scale_y_continuous(name = "Count",
                     breaks = seq(0, 200, 40),
                     limits=c(0, 200)) +
  geom_text(aes(x= name, y = numcities, label = numcities),vjust = -.5)+
  xlab("Chain Brands")
ggsave("chian_city.png", width = 30, height = 13, units = "cm") 

#####Categories frequency in different stars.
fastfood = tribble(
  ~stars,    ~freq,
  "1",       0.08425636,
  "2",       0.05125294,
  "3",       0.04391476,
  "4",       0.03629629,
  "5",       0.03300756
)
cafes = tribble(
  ~stars,    ~freq,
  "1",       0.03344142,
  "2",       0.03940263,
  "3",       0.0421027,
  "4",       0.04598297,
  "5",       0.05496319
)
french = tribble(
  ~stars,    ~freq,
  "1",       0.01311059,
  "2",       0.01977021,
  "3",       0.02251562,
  "4",       0.02671106,
  "5",       0.03084681
)
wings = tribble(
  ~stars,    ~freq,
  "1",       0.04327892,
  "2",       0.02713237,
  "3",       0.02259537,
  "4",       0.01886614,
  "5",       0.0180038
)
vegan = tribble(
  ~stars,    ~freq,
  "1",       0.01957784,
  "2",       0.02456677,
  "3",       0.02708343,
  "4",       0.03262406,
  "5",       0.03621831
)
sportsbar = tribble(
  ~stars,    ~freq,
  "1",       0.05168331,
  "2",       0.04100367,
  "3",       0.03649373,
  "4",       0.02839952,
  "5",       0.02231635
)
a1 =ggplot(data = fastfood) + 
  geom_bar(mapping = aes(x = stars, y = freq),stat = "identity") +
  ggtitle("Fast Food") +
  theme_bw() +
  theme(plot.title = element_text(colour = "black", face = "bold", size = 17, vjust = 1)) +
  theme(text=element_text(family = "Tahoma"),
        axis.text.x = element_text(colour="black", size = 9),
        axis.text.y = element_text(colour="black", size = 10),
        axis.title.x = element_text(colour="black", size = 12),
        axis.title.y = element_text(colour="black", size = 12),
        title = element_text(colour="black", size = 32),
        axis.line = element_line(size=0.3, colour = "black"),
        plot.title = element_text(hjust = 0.5)) + 
  xlab("Stars") +
  ylab("Frequency")
a2 =ggplot(data = cafes) + 
  geom_bar(mapping = aes(x = stars, y = freq),stat = "identity") +
  ggtitle("Cafes") +
  theme_bw() +
  theme(plot.title = element_text(colour = "black", face = "bold", size = 17, vjust = 1)) +
  theme(text=element_text(family = "Tahoma"),
        axis.text.x = element_text(colour="black", size = 9),
        axis.text.y = element_text(colour="black", size = 10),
        axis.title.x = element_text(colour="black", size = 12),
        axis.title.y = element_text(colour="black", size = 12),
        title = element_text(colour="black", size = 32),
        axis.line = element_line(size=0.3, colour = "black"),
        plot.title = element_text(hjust = 0.5)) + 
  xlab("Stars") +
  ylab("Frequency")
a3 =ggplot(data = french) + 
  geom_bar(mapping = aes(x = stars, y = freq),stat = "identity") +
  ggtitle("French") +
  theme_bw() +
  theme(plot.title = element_text(colour = "black", face = "bold", size = 17, vjust = 1)) +
  theme(text=element_text(family = "Tahoma"),
        axis.text.x = element_text(colour="black", size = 9),
        axis.text.y = element_text(colour="black", size = 10),
        axis.title.x = element_text(colour="black", size = 12),
        axis.title.y = element_text(colour="black", size = 12),
        title = element_text(colour="black", size = 32),
        axis.line = element_line(size=0.3, colour = "black"),
        plot.title = element_text(hjust = 0.5)) + 
  xlab("Stars") +
  ylab("Frequency")
a4 =ggplot(data = wings) + 
  geom_bar(mapping = aes(x = stars, y = freq),stat = "identity") +
  ggtitle("Chicken Wings") +
  theme_bw() +
  theme(plot.title = element_text(colour = "black", face = "bold", size = 17, vjust = 1)) +
  theme(text=element_text(family = "Tahoma"),
        axis.text.x = element_text(colour="black", size = 9),
        axis.text.y = element_text(colour="black", size = 10),
        axis.title.x = element_text(colour="black", size = 12),
        axis.title.y = element_text(colour="black", size = 12),
        title = element_text(colour="black", size = 32),
        axis.line = element_line(size=0.3, colour = "black"),
        plot.title = element_text(hjust = 0.5)) + 
  xlab("Stars") +
  ylab("Frequency")
a5 =ggplot(data = vegan) + 
  geom_bar(mapping = aes(x = stars, y = freq),stat = "identity") +
  ggtitle("Vegetarian") +
  theme_bw() +
  theme(plot.title = element_text(colour = "black", face = "bold", size = 17, vjust = 1)) +
  theme(text=element_text(family = "Tahoma"),
        axis.text.x = element_text(colour="black", size = 9),
        axis.text.y = element_text(colour="black", size = 10),
        axis.title.x = element_text(colour="black", size = 12),
        axis.title.y = element_text(colour="black", size = 12),
        title = element_text(colour="black", size = 32),
        axis.line = element_line(size=0.3, colour = "black"),
        plot.title = element_text(hjust = 0.5)) + 
  xlab("Stars") +
  ylab("Frequency")
a6 =ggplot(data = sportsbar) + 
  geom_bar(mapping = aes(x = stars, y = freq),stat = "identity") +
  ggtitle("Sports Bar") +
  theme_bw() +
  theme(plot.title = element_text(colour = "black", face = "bold", size = 17, vjust = 1)) +
  theme(text=element_text(family = "Tahoma"),
        axis.text.x = element_text(colour="black", size = 9),
        axis.text.y = element_text(colour="black", size = 10),
        axis.title.x = element_text(colour="black", size = 12),
        axis.title.y = element_text(colour="black", size = 12),
        title = element_text(colour="black", size = 32),
        axis.line = element_line(size=0.3, colour = "black"),
        plot.title = element_text(hjust = 0.5)) + 
  xlab("Stars") +
  ylab("Frequency")
plot_grid(a1,a2,a3,a4,a5,a6,labels = c("A","B","C","D","E","F"), nrow = 2,align = "h")
ggsave("cate_stars.png", width = 30, height = 20, units = "cm") 

#####chain vs local, stars
chain_stars = tribble(
  ~stars,    ~freq,
  "1",       0.1751024866094138,
  "2",       0.1241172686196475,
  "3",       0.1591946198270445,
  "4",       0.26424713486340107,
  "5",       0.2773384900804931
)
b1 = ggplot(data = chain_stars) +
  geom_bar(mapping = aes(x = stars, y = freq),stat = "identity") +
  labs(title="Chain Restaurant",
       subtitle = "Mean = 3.345") +
  xlab("Stars")+
  theme_bw() +
  theme(plot.title = element_text(colour = "black", face = "bold", size = 20, vjust = 1),
        plot.subtitle = element_text(colour = "black", size = 15, vjust = 1,hjust = 0.5)) +
  theme(text=element_text(family = "Tahoma"),
        axis.text.x = element_text(colour="black", size = 12),
        axis.text.y = element_text(colour="black", size = 12),
        axis.title.x = element_text(colour="black", size = 15),
        axis.title.y = element_text(colour="black", size = 15),
        title = element_text(colour="black", size = 32),
        axis.line = element_line(size=0.3, colour = "black"),
        plot.title = element_text(hjust = 0.5)) +
  scale_y_continuous(name = "Frequency",
                     breaks = seq(0, .4, .1),
                     limits=c(0, .42))
local_stars = tribble(
  ~stars,    ~freq,
  "1",       0.09214973569752632,
  "2",       0.09320991660066598,
  "3",       0.14319400606867563,
  "4",       0.2915904042682445,
  "5",       0.37985593736488754
)
b2 = ggplot(data = local_stars) +
  geom_bar(mapping = aes(x = stars, y = freq),stat = "identity") +
  labs(title="Local Restaurant",
       subtitle = "Mean = 3.774") +
  xlab("Stars")+
  theme_bw() +
  theme(plot.title = element_text(colour = "black", face = "bold", size = 20, vjust = 1)) +
  theme(text=element_text(family = "Tahoma"),
        axis.text.x = element_text(colour="black", size = 12),
        axis.text.y = element_text(colour="black", size = 12),
        axis.title.x = element_text(colour="black", size = 15),
        axis.title.y = element_text(colour="black", size = 15),
        title = element_text(colour="black", size = 32),
        axis.line = element_line(size=0.3, colour = "black"),
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(colour = "black", size = 15, vjust = 1,hjust = 0.5))+
  scale_y_continuous(name = NULL,
                     breaks = seq(0, .4, .1),
                     limits=c(0, .42))
plot_grid(b1,b2,labels = c("A","B"), nrow = 1,align = "h")

ggsave("chian_local_stars.png", width = 30, height = 14, units = "cm") 



######Categories sparse matrix
cata = yelp$categories %>% strsplit("', '")
for (i in 1:length(cata)) {
  cata[[i]][1] <- (cata[[i]][1] %>% strsplit("\\['"))[[1]][2]
  cata[[i]][cata[[i]] %>% length] <- (cata[[i]][cata[[i]] %>% length] %>% strsplit("\\']"))[[1]][1]
  if((i %% 10000) == 0){
    print(i/length(cata))
  }
}
for (i in 1:length(cata)) {
  cata[[i]] = cata[[i]] %>% str_sort(na_last=NA)
  if((i %% 10000) == 0){
    print(i/length(cata))
  }
}
#index = which(check_cata(cata,"Restaurants") == F)
cata1 = cata ###just in case
for (i in 1:length(cata)){
  k = as.vector(unlist(cata[[i]])) %>% strsplit(", '")
  m = as.vector(unlist(k)) %>% strsplit("\"") %>% unlist() %>% as.vector()
  m = m %>% strsplit("', ") %>% unlist() %>% as.vector()
  cata[[i]] = m
  if((i %% 10000) == 0){
    print(i/length(cata))
  }
}
ca = unlist(cata) %>% as.vector() %>% as.factor() %>% levels()
csm = matrix(rep(0,length(cata)*length(ca)), length(cata),length(ca))
for (i in 1:length(cata)) {
  for (j in 1:length(ca)) {
    if(sum(cata[[i]] == ca[j]) == 1){
      csm[i,j] = 1
    }
  }
  if((i %% 10000) == 0){
    print(i/length(cata))
  }
}


####Performance plot
index <- rep(1:5, times = 2) 
type <- rep(c("MSE","Accuracy"),each = 5) 
value <- c(1.4200+1,0.5540+1,0.5419+1,0.5276+1,0.4738+1,0.2600,0.5560,0.5598,0.5677,0.58) 
df <- data.frame(index = index, type = type, value = value)
ggplot(data= df, mapping = aes(x = index, y = value, linetype = type, colour = type, shape = type, fill = type)) + 
  geom_line() +
  geom_point()+
  labs(title="MSE Performance") +
  xlab("Number of Features")+
  ylab("Value")+
  theme_bw() +
  theme(plot.title = element_text(colour = "black", face = "bold", size = 20, vjust = 1)) +
  theme(text=element_text(family = "Tahoma"),
        axis.text.x = element_text(colour="black", size = 12),
        axis.text.y = element_text(colour="black", size = 12),
        axis.title.x = element_text(colour="black", size = 15),
        axis.title.y = element_text(colour="black", size = 15),
        title = element_text(colour="black", size = 15),
        axis.line = element_line(size=0.3, colour = "black"),
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(colour = "black", size = 15, vjust = 1,hjust = 0.5))+
  scale_y_continuous(breaks = seq(0, 2.5, 0.5),
                     limits=c(0, 2.5),
                     labels = c("0","0.5","1","0.5","1","1.5"))+
  scale_linetype_manual(values = c(1,2)) +
  scale_color_manual(values = c("steelblue","darkred"))+
  scale_x_continuous(breaks = seq(1, 5, 1),
                     limits=c(0.8, 5),
                     labels = c("10","100","207","207(2)","final"))
ggsave("double!.png", width = 30, height = 20, units = "cm") 

################Special marks
gantanhao = tribble(
  ~stars,    ~count,
  "1",       21200,
  "2",       9133,
  "3",       11156,
  "4",       37401,
  "5",       90973
)
ggplot(data = gantanhao) +
  geom_bar(mapping = aes(x = stars, y = count),stat = "identity") +
  labs(title="Double Excalmatory Mark",
       subtitle = "Mean = 3.9879") +
  xlab("Stars")+
  theme_bw() +
  theme(plot.title = element_text(colour = "black", face = "bold", size = 20, vjust = 1)) +
  theme(text=element_text(family = "Tahoma"),
        axis.text.x = element_text(colour="black", size = 12),
        axis.text.y = element_text(colour="black", size = 12),
        axis.title.x = element_text(colour="black", size = 15),
        axis.title.y = element_text(colour="black", size = 15),
        title = element_text(colour="black", size = 32),
        axis.line = element_line(size=0.3, colour = "black"),
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(colour = "black", size = 15, vjust = 1,hjust = 0.5))+
  scale_y_continuous(name = NULL,
                     breaks = seq(0, 100000, 20000),
                     limits=c(0, 100000),
                     labels = c("0","20000","40000","60000","80000","100000"))
ggsave("double!.png", width = 30, height = 20, units = "cm") 
