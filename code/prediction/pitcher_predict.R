library(tidyverse)

babip = read_csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/pitcher_Total_BABIP.csv")

babip = babip %>% select(-X1)

pitcher = read_csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/pitcher_rate_BABIP_2020.csv")

pitcher = pitcher %>% select(-X1)

babip = babip %>% select(P_ID, BABIP) %>% unique()

HR = pitcher %>% select(P_ID, HR_rate) %>% unique()

pitcher = pitcher %>% left_join(babip, by = c('P_ID'))

rates = pitcher %>% select(-c(HR_rate)) %>% unique()

feature = read_csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/pitcher_feature_selection.csv")



feature = feature %>% select(-c(X1, R, X, TB_SC_B, TB_SC_T, WLS_D, WLS_L, WLS_ND, WLS_S, WLS_W, START_CK, RELIEF_CK, CG_CK)) %>% colnames() 

p_t =  read_csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/pitcher_all.csv")

p_t = p_t %>% filter(year == 2020) %>% select(P_ID, T_ID) %>% unique()


predict = read_csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/predicted_inplay_hit_pitcher.csv")

predict = predict %>% left_join(HR, by = c('P_ID'))

predict = predict %>% mutate(HIT = inplay_H / (1 - HR_rate)) %>% select(year, month, P_ID, PA, HIT, HR_rate)

predict[is.na(predict) == T] = 0

predict$HR_rate[predict$HR_rate == 1] = 0

predict = predict %>% left_join(rates, by = c("P_ID"))

feature

predict = predict %>% mutate(HP = PA * HP_rate, BB = PA * BB_rate, H2 = HIT * H2_rate, H3 = HIT*H3_rate, HR = HIT * HR_rate) %>% mutate(AVG = HIT/(PA - BB- HP), OBP = (HIT + BB + HP) / PA, SLG = ((HIT - H2 - H3 - HR) + 2 * H2 + 3*H3 + 4*HR)/(PA-BB) , BK = BK_rate*(HIT + BB + HP), BF = BF_per_PA * PA, GD = GD_rate * PA) %>% mutate(OPS = OBP + SLG)

predict[is.na(predict) == T] = 0


predict = predict %>% left_join(p_t, by = c('P_ID'))

games = read_csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/schedule_left.csv")


predict = predict %>% left_join(games, by = c('year', 'month', 'T_ID')) %>%  select(feature, GD_rate, H_A_AWAY, H_A_HOME)

write.csv(predict, "pitcher_predict.csv", row.names = F)
