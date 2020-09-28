# 1. 데이터 불러오기

library(tidyverse)


# 2. 2020년 7월부터 크롤링한것들 이어붙이기

batter_after = read.csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/kbo_record_batter_byPID.csv")

pitcher_after = read.csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/kbo_record_pitcher_byPID.csv")

batter_after = batter_after %>% transmute(P_ID = P_ID, year = year, month = month, AVG = AVG1, PA = PA, AB = AB, HIT = H, H2 = X2B,
                           H3 = X3B, HR = HR, SB = SB, CS = CS, BB = BB, HP = HBP, KK = SO, GP = GDP, SF = PA - AB - BB - HP)

batter_after = batter_after %>% select(year, month, P_ID, PA, SB, CS, SF)


pitcher_after = pitcher_after %>% transmute(P_ID = P_ID, year = year, month = month, PA = TBF, HIT = H, HR = HR, BB = BB, HP = HBP, KK = SO, R = R, ER = ER)


batter_left = read.csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/batter_left.csv")

batter_left = batter_left %>% select(-PA)


pitcher_left = read.csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/pitcher_left.csv")


batter_left = batter_left %>% left_join(batter_after, by = c("year", "month", "P_ID"))

pitcher_left = pitcher_left %>% select(-PA)

pitcher_after  = pitcher_after %>% select(year, month, P_ID, PA, R, ER)

pitcher_left = pitcher_left %>% left_join(pitcher_after, by = c("year", "month", "P_ID"))

pitcher_left = pitcher_left %>% mutate(AB = case_when(
  AVG == 0 ~ PA - BB - HP,
  TRUE ~ AB
))

pitcher_left = pitcher_left %>% mutate(SF = PA - AB - BB - HP)

pitcher_left = pitcher_left %>% select(-AVG)

batter_left

## 저장

write.csv(batter_left, "batter_after_7.csv", row.names = F)
write.csv(pitcher_left, "pitcher_after_7.csv", row.names = F)
