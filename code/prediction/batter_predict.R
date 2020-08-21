library(tidyverse)

babip = read_csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/batter_Total_BABIP.csv")

babip = babip %>% select(-X1)

batter = read_csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/batter_rate_BABIP_2020.csv")

batter = batter %>% select(-X1)

babip = babip %>% select(P_ID, BABIP) %>% unique()

HR = batter %>% select(P_ID, HR_rate) %>% unique()

batter = batter %>% left_join(babip, by = c('P_ID'))

rates = batter %>% select(P_ID, BB_rate, HP_rate, BABIP, H2_rate, H3_rate, SB_rate) %>% unique()

feature = read_csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/batter_feature_selection.csv")

feature = feature %>% select(-c(X1, XR)) %>% colnames() 

p_t =  read_csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/batter_all.csv")

p_t = p_t %>% filter(year == 2020) %>% select(P_ID, T_ID) %>% unique()

bat_order = read_csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/batter_all.csv")

bat_order = bat_order %>% filter(year == 2020, month == 7) %>% select(P_ID, BAT_ORDER) %>% unique()


batter %>% colnames()

predict = read_csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/predicted_inplay_hit.csv")

predict = predict %>% left_join(HR, by = c('P_ID'))

predict = predict %>% mutate(HIT = inplay_H / (1 - HR_rate)) %>% select(year, month, P_ID, PA, HIT, HR_rate)

predict[is.na(predict) == T] = 0

predict$HR_rate[predict$HR_rate == 1] = 0

predict = predict %>% left_join(rates, by = c("P_ID"))

predict = predict %>% left_join(bat_order, by = c("P_ID"))

predict = predict %>% mutate(HP = PA * HP_rate, BB = PA * BB_rate, H2 = HIT * H2_rate, H3 = HIT*H3_rate, HR = HIT * HR_rate) %>% mutate(AVG = HIT/(PA - BB- HP), OBP = (HIT + BB + HP) / PA, SLG = ((HIT - H2 - H3 - HR) + 2 * H2 + 3*H3 + 4*HR)/(PA-BB) ) %>% mutate(OPS = OBP + SLG)

predict[is.na(predict) == T] = 0

predict = predict %>% select(PA, BB_rate, HR_rate, AVG, OBP, SLG, OPS, SB_rate, BABIP, H2_rate, H3_rate, year, month, P_ID, BAT_ORDER )

predict = predict %>% left_join(p_t, by = c('P_ID'))

games = read_csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/schedule_left.csv")


predict = predict %>% left_join(games, by = c('year', 'month', 'T_ID')) %>%  select(feature)

write.csv(predict, "batter_predict.csv", row.names = F)
