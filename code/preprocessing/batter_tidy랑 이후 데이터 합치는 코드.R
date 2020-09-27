library(tidyverse)

batter_tidy = read.csv('C:/Users/seungjun/Desktop/baseball/data/batter_tidy.csv')
batter_after = read.csv('C:/Users/seungjun/Desktop/baseball/data/batter_after_complete.csv')

batter_before = batter_tidy %>% filter(month != 7 ) 

names(batter_before)
names(batter_after)

df1 = batter_before %>% select(year,T_ID,PA,AB,HIT,H2,H3,HR,SB,CS,SF,BB,HP,KK,GD)
df2 = batter_after %>%  select(year,T_ID,PA,AB,HIT,H2,H3,HR,SB,CS,SF,BB,HP,KK,GD)


batter_all = rbind(df1,df2)
