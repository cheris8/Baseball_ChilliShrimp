## 데이터 합치기
library(tidyverse)

pitcher_all = read.csv('C:/Users/seungjun/Desktop/baseball/data/pitcher.csv',header=T)
pitcher_AVG_OBP_SLG_OPS =read.csv('C:/Users/seungjun/Desktop/baseball/data/pitcher_AVG_OBP_SLG_OPS.csv',header=T)
pitcher_볼넷당삼진 = read.csv('C:/Users/seungjun/Desktop/baseball/data/pitcher_볼넷당삼진.csv',header=T)
pitcher_Total_BABIP = read.csv('C:/Users/seungjun/Desktop/baseball/data/pitcher_Total_BABIP.csv',header=T)
pitcher_ERA = read.csv('C:/Users/seungjun/Desktop/baseball/data/pitcher_ERA_FIP_WHIP_SB_try_SB_succ.csv',header=T)
  
head(pitcher_all)
head(pitcher_AVG_OBP_SLG_OPS)
head(pitcher_볼넷당삼진)
head(pitcher_Total_BABIP)
head(pitcher_ERA)

pitcher_AVG_OBP_SLG_OPS = pitcher_AVG_OBP_SLG_OPS %>% select(-X)
pitcher_볼넷당삼진 = pitcher_볼넷당삼진 %>% select(-X)
pitcher_Total_BABIP = pitcher_Total_BABIP %>% select(-X)
pitcher_ERA = pitcher_ERA %>% select(-X)

pitcher_all =pitcher_all %>%
  left_join(pitcher_AVG_OBP_SLG_OPS, by=names(pitcher_all)) %>%
  left_join(pitcher_볼넷당삼진, by=names(pitcher_all)) %>%
  left_join(pitcher_Total_BABIP, by=names(pitcher_all)) %>%
  left_join(pitcher_ERA, by=names(pitcher_all)) 

head(pitcher_all)
write.csv(pitcher_all,'C:/Users/seungjun/Desktop/baseball/data/pitcher_all.csv')
