# data 불러오기

library(tidyverse)

batter = read_csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\데이터분석분야_퓨처스리그_칠리새우\\데이터\\2. preprocessing\\batter_tidy.csv")

pitcher = read_csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\데이터분석분야_퓨처스리그_칠리새우\\데이터\\2. preprocessing\\pitcher_tidy.csv")


# predicted_pa 만들기

batter_predict = batter %>% filter(paste0(year, month) == '20209') %>% select(year, P_ID, PA)

batter_predict = batter_predict %>% mutate(month = 10) %>% select(year, month, P_ID, PA)

pitcher_predict = pitcher %>% filter(paste0(year, month) == '20209') %>% select(year, P_ID, PA)

pitcher_predict = pitcher_predict %>% mutate(month = 10) %>% select(year, month, P_ID, PA)


# 저장하기

write.csv(batter_predict, "batter_predict_pa.csv", row.names = F)
write.csv(pitcher_predict, "pitcher_predict_pa.csv", row.names = F)