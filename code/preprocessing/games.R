# Game by Team

library(tidyverse)
library(lubridate)

g_2016= read_csv("C:/Users/dhxog/Desktop/ESC_summer/Baseball_ChilliShrimp/data/경기/2020빅콘테스트_스포츠투아이_제공데이터_경기_2016.csv")
g_2017 = read_csv("C:/Users/dhxog/Desktop/ESC_summer/Baseball_ChilliShrimp/data/경기/2020빅콘테스트_스포츠투아이_제공데이터_경기_2017.csv")
g_2018 = read_csv("C:/Users/dhxog/Desktop/ESC_summer/Baseball_ChilliShrimp/data/경기/2020빅콘테스트_스포츠투아이_제공데이터_경기_2018.csv")
g_2019 = read_csv("C:/Users/dhxog/Desktop/ESC_summer/Baseball_ChilliShrimp/data/경기/2020빅콘테스트_스포츠투아이_제공데이터_경기_2019.csv")
g_2020 = read_csv("C:/Users/dhxog/Desktop/ESC_summer/Baseball_ChilliShrimp/data/경기/2020빅콘테스트_스포츠투아이_제공데이터_경기_2020.csv")

game = rbind(g_2016, g_2017, g_2018, g_2019, g_2020)

game = game %>% select(GDAY_DS, VISIT_KEY, HOME_KEY)

game = game %>% mutate(GDAY_DS = ymd(GDAY_DS)) %>% mutate(year = year(GDAY_DS), month = month(GDAY_DS)) %>%
  select(year, month, VISIT_KEY, HOME_KEY)

game_visit = game %>% mutate(count = 1) %>% group_by(year, month, VISIT_KEY) %>% summarise(VISIT = sum(count)) %>% 
  ungroup() %>% mutate(T_ID = VISIT_KEY) %>% select(year, month, T_ID, VISIT)
game_home = game %>% mutate(count = 1) %>% group_by(year, month, HOME_KEY) %>% summarise(HOME = sum(count)) %>%
  ungroup() %>% mutate(T_ID = HOME_KEY) %>% select(year, month, T_ID, HOME)

games = game_visit %>% left_join(game_home, by = c('year', 'month', 'T_ID'))

write.csv(games, 'games.csv', row.names = F)
