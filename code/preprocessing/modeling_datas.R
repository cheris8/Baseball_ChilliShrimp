# 1. 데이터 불러오기

library(tidyverse)


# 2020년 6월까지
batter_before = read.csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\batter_feature_selection.csv")

batter_before = batter_before %>% select(-X)

pitcher_before = read.csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\pitcher_feature_selection.csv")

pitcher_before = pitcher_before %>% select(-X)

batter_before %>% glimpse

pitcher_before %>% view

# 2020년 7월부터

batter_after = read_csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\batter_after_7.csv")

pitcher_after = read.csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\pitcher_after_7.csv")

batter_after %>% glimpse


# batter_after 완성하기

batter %>% view()


batter = batter_after  %>%
  mutate(H2_rate=H2/HIT,H3_rate=H3/HIT,HR_rate=HR/HIT,
         BB_rate=BB/PA, HP_rate=HP/PA, KK_rate=KK/PA, GD_rate=GD/PA, OBP = (HIT  + BB + HP) / PA, SLG = ((HIT - H2 - H3 - HR) + 2 * H2 + 3 * H3 + 4 * HR)/AB, OPS = OBP + SLG, 
         XR = ((HIT - H2 - H3 - HR)*0.5 + H2 * 0.72 + H3 * 1.04 + HR * 1.44 + (HP + BB) * 0.34 + SB * 0.18 - CS * 0.32 - (PA - HIT - KK) * 0.09 - KK * 0.098 - GD * 0.37 + SF * 0.37), BABIP = ((HIT - HR)/(PA - KK - HR + SF)), SB_rate = SB / (SB + CS))
names(batter)

batter$H2_rate[is.na(batter$H2_rate)] = 0
batter$H3_rate[is.na(batter$H3_rate)] = 0
batter$HR_rate[is.na(batter$HR_rate)] = 0
batter$BB_rate[is.na(batter$BB_rate)] = 0
batter$HP_rate[is.na(batter$HP_rate)] = 0
batter$KK_rate[is.na(batter$KK_rate)] = 0
batter$GD_rate[is.na(batter$GD_rate)] = 0
batter$OBP[is.na(batter$OBP)] = 0
batter$SLG[is.na(batter$SLG)] = 0
batter$OPS[is.na(batter$OPS)] = 0
batter$BABIP[is.na(batter$BABIP)] = 0
batter$SB_rate[is.na(batter$SB_rate)] = 0


batter$H2_rate[is.infinite(batter$H2_rate)] = 0
batter$H3_rate[is.infinite(batter$H3_rate)] = 0
batter$HR_rate[is.infinite(batter$HR_rate)] = 0
batter$BB_rate[is.infinite(batter$BB_rate)] = 0
batter$HP_rate[is.infinite(batter$HP_rate)] = 0
batter$KK_rate[is.infinite(batter$KK_rate)] = 0
batter$GD_rate[is.infinite(batter$GD_rate)] = 0
batter$OBP[is.infinite(batter$OBP)] = 0
batter$SLG[is.infinite(batter$SLG)] = 0
batter$OPS[is.infinite(batter$OPS)] = 0
batter$BABIP[is.infinite(batter$BABIP)] = 0
batter$SB_rate[is.infinite(batter$SB_rate)] = 0


batter[is.na(batter)] = 0

write.csv(batter, "batter_after_complete.csv", row.names = F)

batter_before = batter_before %>% select(-c(P_AB_CN, P_HIT_CN))

batter = batter %>% select(batter_before %>% colnames())

batter_before = batter_before %>% filter(paste0(year, month) != '20207')

batter_model = rbind(batter_before, batter)

write.csv(batter_model, "modeling_batter.csv", row.names = F)

# Pitcher_after 완성하기

pitcher_after %>% glimpse
pitcher_before %>% glimpse


pitcher = pitcher_after  %>%
  mutate(H2_rate=H2/HIT,H3_rate=H3/HIT,HR_rate=HR/HIT,
         BB_rate=BB/PA, HP_rate=HP/PA, KK_rate=KK/PA,  OBP = (HIT  + BB + HP) / PA, SLG = ((HIT - H2 - H3 - HR) + 2 * H2 + 3 * H3 + 4 * HR)/AB, OPS = OBP + SLG, BABIP = ((HIT - HR)/(PA - KK - HR + (PA - AB - BB - HP))), BK_rate = BK / (HIT + BB + HP))
names(batter)

pitcher_data =  read.csv('C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\pitcher.csv')

pitcher_total = pitcher_data %>%
  group_by(P_ID) %>%
  summarise(SB = sum(SB), CS = sum(CS), PA = sum(PA), SF = sum(SF)) %>%
  mutate(SB_try = (SB + CS) / PA, SB_succ = SB/(SB + CS)) %>% 
  select(-c(SB,CS,PA,SF))

sum(is.na(pitcher_total$SB_try))
sum(is.na(pitcher_total$SB_succ))


sum(is.infinite(pitcher_total$SB_try))
sum(is.infinite(pitcher_total$SB_succ))


pitcher_total$SB_try[is.na(pitcher_total$SB_try)] = 0
pitcher_total$SB_succ[is.na(pitcher_total$SB_succ)] = 0

pitcher_total$SB_try[is.infinite(pitcher_total$SB_try)] = 0
pitcher_total$SB_succ[is.infinite(pitcher_total$SB_succ)] = 0

sum(is.na(pitcher_total$SB_try))
sum(is.na(pitcher_total$SB_succ))


sum(is.infinite(pitcher_total$SB_try))
sum(is.infinite(pitcher_total$SB_succ))


pitcher = pitcher %>% left_join(pitcher_total, by = "P_ID")

pitcher$H2_rate[is.na(pitcher$H2_rate)] = 0
pitcher$H3_rate[is.na(pitcher$H3_rate)] = 0
pitcher$HR_rate[is.na(pitcher$HR_rate)] = 0
pitcher$SLG[is.na(pitcher$SLG)] = 0
pitcher$OPS[is.na(pitcher$OPS)] = 0


pitcher_before = pitcher_data %>%
  mutate(H2_rate=H2/HIT,H3_rate=H3/HIT,HR_rate=HR/HIT,
         BB_rate=BB/PA, HP_rate=HP/PA, KK_rate=KK/PA,  OBP = (HIT  + BB + HP) / PA, SLG = ((HIT - H2 - H3 - HR) + 2 * H2 + 3 * H3 + 4 * HR)/AB, OPS = OBP + SLG, BABIP = ((HIT - HR)/(PA - KK - HR + (PA - AB - BB - HP))), BK_rate = BK / (HIT + BB + HP))

pitcher_before = pitcher_before %>% left_join(pitcher_total, by = "P_ID")

pitcher_before = pitcher_before %>% mutate(H_A_AWAY = TB_SC_T, H_A_HOME = TB_SC_B, AVG = HIT / AB)

pitcher_before[is.na(pitcher_before)] = 0
pitcher_before$BK_rate[is.infinite(pitcher_before$BK_rate)] = 0

\
pitcher = pitcher %>% select(-c(AB, HIT, H2, H3, HR, BB, HP, KK, BK, ER))

pitcher_before = pitcher_before %>% filter(paste0(year, month) != '20207') %>% select(pitcher %>% colnames())


pitcher_model = rbind(pitcher_before, pitcher)

ERR = pitcher_data %>% group_by(year, T_ID) %>% mutate(ERR = sum(ERR) / sum(PA)) %>% select(year, T_ID, ERR) %>% unique()

pitcher_model = pitcher_model %>% left_join(ERR, by = c("year", "T_ID"))

write.csv(pitcher_model, "modeling_pitcher.csv", row.names = F)
