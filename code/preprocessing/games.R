# Game by Team

library(tidyverse)
library(lubridate)

g_2016= read_csv("C:/Users/dhxog/Desktop/ESC_summer/Baseball_ChilliShrimp/data/경기/2020빅콘테스트_스포츠투아이_제공데이터_경기_2016.csv")
g_2017 = read_csv("C:/Users/dhxog/Desktop/ESC_summer/Baseball_ChilliShrimp/data/경기/2020빅콘테스트_스포츠투아이_제공데이터_경기_2017.csv")
g_2018 = read_csv("C:/Users/dhxog/Desktop/ESC_summer/Baseball_ChilliShrimp/data/경기/2020빅콘테스트_스포츠투아이_제공데이터_경기_2018.csv")
g_2019 = read_csv("C:/Users/dhxog/Desktop/ESC_summer/Baseball_ChilliShrimp/data/경기/2020빅콘테스트_스포츠투아이_제공데이터_경기_2019.csv")
g_2020 = read_csv("C:/Users/dhxog/Desktop/ESC_summer/Baseball_ChilliShrimp/data/경기/2020빅콘테스트_스포츠투아이_제공데이터_경기_2020.csv")

df = read_csv("C:/Users/dhxog/Desktop/ESC_summer/Baseball_ChilliShrimp/data/batter_tidy.csv")

game = rbind(g_2016, g_2017, g_2018, g_2019, g_2020)

game = game %>% select(GDAY_DS, VISIT_KEY, HOME_KEY)

game = game %>% mutate(GDAY_DS = ymd(GDAY_DS)) %>% mutate(year = year(GDAY_DS), month = month(GDAY_DS)) %>%
  select(year, month, VISIT_KEY, HOME_KEY)

game

game_visit = game %>% mutate(count = 1) %>% group_by(year, month, VISIT_KEY) %>% summarise(VISIT_G = sum(count)) %>% 
  ungroup() %>% mutate(T_ID = VISIT_KEY) %>% select(year, month, T_ID, VISIT_G)
game_home = game %>% mutate(count = 1) %>% group_by(year, month, HOME_KEY) %>% summarise(HOME_G = sum(count)) %>%
  ungroup() %>% mutate(T_ID = HOME_KEY) %>% select(year, month, T_ID, HOME_G)

games = game_visit %>% left_join(game_home, by = c('year', 'month', 'T_ID'))

games

df_merged = df %>% left_join(games, by = c('year', 'month', 'T_ID'))

df_merged

write.csv(df_merged, 'games_merged.csv', row.names = F)


vs = game %>% filter(year == 2020) %>% mutate(T_ID = VISIT_KEY, VS_T_ID = HOME_KEY) %>% select(year, month, T_ID, VS_T_ID)
t = game %>% filter(year == 2020) %>% mutate(T_ID = HOME_KEY, VS_T_ID = VISIT_KEY) %>% select(year, month, T_ID, VS_T_ID)

game_2020 = rbind(vs, t) %>% arrange(year, month)

game_2020 %>% View()

write.csv(game_2020, 'game_2020.csv', row.names = F)
