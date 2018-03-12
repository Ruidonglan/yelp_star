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
library(gtable)
library(grid)

yelp = read_csv("train_data.csv")
ts_data = yelp %>% transmute(date = date, stars = stars, city = city)
#cri = group_by(cri, date, type) %>% summarise(n = n())

#crime = crime %>% separate(Date,sep=" ",into = c("date","time","daytime")) %>% 
#  mutate(date=gsub(date,pattern="(.*)/(.*)/(.*)",replacement = "\\3-\\1-\\2")) %>%
#  mutate(date=as_date(date))

madison_ts = filter(ts_data, city == "Madison") %>% 
  transmute(stars=stars, date = date) %>% group_by(date) %>% 
  summarise(n = mean(stars)) 

madison_month = filter(ts_data, city == "Madison") %>% 
  transmute(stars=stars, date = date) %>% separate(date,sep="-",into = c("year","month","day")) %>%
  group_by(year,month) %>% summarise(n = mean(stars, na.rm = T)) %>% 
  transmute(date = make_date(year = year, month = month), n = n)

madison_jan = filter(ts_data, city == "Madison") %>% 
  transmute(stars=stars, date = date) %>% separate(date,sep="-",into = c("year","month","day")) %>%
  group_by(year,month) %>% summarise(n = mean(stars, na.rm = T)) %>% filter(month == "01") %>% summarise(n = mean(n))

madison_2010 = filter(madison_month, year >= 2010)

ggplot(data = madison_2010)+
  geom_point(mapping = aes(x = date, y = n)) +
  geom_line(mapping = aes(x = date, y = n)) +
  theme_set(theme_bw()) +
  labs(title="Mean stars in Madison") +
  theme(plot.title = element_text(colour = "black", face = "bold", size = 35, vjust = 1)) +
  xlab("Date") + ylab("Stars") +
  theme(plot.title=element_text(hjust=0.5))+
  theme(axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.title.y = element_text(size = 15),
        axis.title.x = element_text(size = 15))




#LV
lv_ts = filter(ts_data, city == "Las Vegas") %>% 
  transmute(stars=stars, date = date) %>% group_by(date) %>% 
  summarise(n = mean(stars)) 

lv_month = filter(ts_data, city == "Las Vegas") %>% 
  transmute(stars=stars, date = date) %>% separate(date,sep="-",into = c("year","month","day")) %>%
  group_by(year,month) %>% summarise(n = mean(stars, na.rm = T)) %>% 
  transmute(date = make_date(year = year, month = month), n = n)

lv_jan = filter(ts_data, city == "Las Vegas") %>% 
  transmute(stars=stars, date = date) %>% separate(date,sep="-",into = c("year","month","day")) %>%
  group_by(year,month) %>% summarise(n = mean(stars, na.rm = T)) %>% filter(month == "01") %>% summarise(n = mean(n))

lv_2007 = filter(lv_month, year >= 2007)

ggplot(data = lv_ts[2000:3978,])+
  #geom_point(mapping = aes(x = date, y = n)) +
  geom_line(mapping = aes(x = date, y = n)) +
  theme_set(theme_bw()) +
  labs(title="Mean stars in LV") +
  theme(plot.title = element_text(colour = "black", face = "bold", size = 35, vjust = 1)) +
  xlab("Date") + ylab("Stars") +
  theme(plot.title=element_text(hjust=0.5))+
  theme(axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.title.y = element_text(size = 15),
        axis.title.x = element_text(size = 15))


###total
ts = ts_data %>% 
  transmute(stars=stars, date = date) %>% group_by(date) %>% 
  summarise(n = mean(stars)) 
ts_month = ts_data %>% 
  transmute(stars=stars, date = date) %>% separate(date,sep="-",into = c("year","month","day")) %>%
  group_by(year,month) %>% summarise(stars = mean(stars, na.rm = T)) %>% 
  transmute(date = make_date(year = year, month = month), stars = stars)
a1 = ggplot(data = ts_month)+
  geom_point(mapping = aes(x = date, y = stars)) +
  geom_line(mapping = aes(x = date, y = stars)) +
  theme_set(theme_bw()) +
  labs(title="Mean Stars") +
  xlab("Date") + ylab("Stars") +
  theme_bw() +
  theme(plot.title = element_text(colour = "black", face = "bold", size = 20, vjust = 1)) +
  theme(text=element_text(family = "Tahoma"),
        axis.text.x = element_text(colour="black", size = 12),
        axis.text.y = element_text(colour="black", size = 12),
        axis.title.x = element_text(colour="black", size = 15),
        axis.title.y = element_text(colour="black", size = 15),
        title = element_text(colour="black", size = 32),
        axis.line = element_line(size=0.3, colour = "black"),
        plot.title = element_text(hjust = 0.5))
#ggsave("meanstars_all.png", width = 30, height = 20, units = "cm") 

ts_month_count = ts_data %>% 
  transmute(date = date) %>% separate(date,sep="-",into = c("year","month","day")) %>%
  group_by(year,month) %>% summarise(count = n()) %>% 
  transmute(date = make_date(year = year, month = month), count = count)
a2 = ggplot(data = ts_month_count) +
  geom_point(mapping = aes(x = date, y = count)) +
  geom_line(mapping = aes(x = date, y = count)) +
  theme_set(theme_bw()) +
  labs(title="Number of Reviews per Month") +
  xlab("Date") + ylab("Count") +
  theme_bw() +
  theme(plot.title = element_text(colour = "black", face = "bold", size = 20, vjust = 1)) +
  theme(text=element_text(family = "Tahoma"),
        axis.text.x = element_text(colour="black", size = 12),
        axis.text.y = element_text(colour="black", size = 12),
        axis.title.x = element_text(colour="black", size = 15),
        axis.title.y = element_text(colour="black", size = 15),
        title = element_text(colour="black", size = 32),
        axis.line = element_line(size=0.3, colour = "black"),
        plot.title = element_text(hjust = 0.5))
#ggsave("reviewsnumber.png", width = 30, height = 20, units = "cm") 

plot_grid(a1,a2,labels = NULL, nrow = 1,align = "h")
ggsave("time.png", width = 30, height = 14, units = "cm") 
