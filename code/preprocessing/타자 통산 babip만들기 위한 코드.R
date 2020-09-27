library(tidyverse)

batter_tidy = read.csv('C:/Users/seungjun/Desktop/baseball/data/batter_tidy.csv')
batter_after_complete = read.csv('C:/Users/seungjun/Desktop/baseball/data/batter_after_complete.csv')



df1 = select(batter_tidy,c(year,P_ID,PA,AB,BB,HP,HIT,HR,KK,HR))
df2 = select(batter_after_complete,c(year,P_ID,PA,AB,BB,HP,HIT,HR,KK,HR)) 

df3 = rbind(df1,df2)

write.csv(df3,'C:/Users/seungjun/Desktop/baseball/data/batter_for_total_babip.csv')







