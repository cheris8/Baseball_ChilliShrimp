library(tidyverse)
library(lubridate)

predicted_pa = read_csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/predicted_pa_per_g_pitcher.csv")

player = read_csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/%EC%84%A0%EC%88%98/2020%EB%B9%85%EC%BD%98%ED%85%8C%EC%8A%A4%ED%8A%B8_%EC%8A%A4%ED%8F%AC%EC%B8%A0%ED%88%AC%EC%95%84%EC%9D%B4_%EC%A0%9C%EA%B3%B5%EB%8D%B0%EC%9D%B4%ED%84%B0_%EC%84%A0%EC%88%98_2020.csv")

game_left = read_csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/schedule_left.csv")

player = player %>% select(PCODE, T_ID) %>% mutate(P_ID = PCODE) %>% select(P_ID, T_ID)

predicted_pa = predicted_pa %>% mutate(ds = ymd(ds)) %>% mutate(year = year(ds), month = month(ds)) %>% select(year, month, P_ID, PA_PER_G)

predicted_pa = predicted_pa %>% arrange(year, month)

predicted_pa = predicted_pa %>% left_join(player, by = c('P_ID')) %>% select(year, month, P_ID, T_ID, PA_PER_G)

game_left_total = game_left %>% mutate(total_game = H_A_AWAY + H_A_HOME ) %>% select(year, month, T_ID, total_game)

predicted_pa = predicted_pa %>% left_join(game_left_total, by = c('year', 'month', 'T_ID'))

predicted_pa = predicted_pa %>% mutate(PA = round(PA_PER_G * total_game)) %>% select(year, month, P_ID, T_ID, PA)                          

write.csv(predicted_pa, "prediction_pitcher.csv", row.names = FALSE)
