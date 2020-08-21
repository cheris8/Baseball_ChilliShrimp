library(tidyverse)

schedule = read_csv("C:/Users/dhxog/Desktop/ESC_summer/Baseball_ChilliShrimp/data/kbo_schedule.csv")
before = read_csv("C:/Users/dhxog/Desktop/ESC_summer/Baseball_ChilliShrimp/data/kbo_schedule_before_0719.csv")


schedule = schedule %>% select(-c(X1, day))
before = before %>% select(-c(X1, day))

schedule = schedule %>% mutate(team_visit = case_when(
  team_visit == '한화' ~ 'HH',
  team_visit == 'KIA' ~ 'HT',
  team_visit == '롯데' ~ 'LT',
  team_visit == '두산' ~ 'OB',
  team_visit == '삼성' ~ 'SS',
  team_visit == '키움' ~ 'WO',
  TRUE ~ team_visit
), team_home = case_when(
  team_home == '한화' ~ 'HH',
  team_home == 'KIA' ~ 'HT',
  team_home == '롯데' ~ 'LT',
  team_home == '두산' ~ 'OB',
  team_home == '삼성' ~ 'SS',
  team_home == '키움' ~ 'WO',
  TRUE ~ team_home
))

before = before %>% mutate(team_visit = case_when(
  team_visit == '한화' ~ 'HH',
  team_visit == 'KIA' ~ 'HT',
  team_visit == '롯데' ~ 'LT',
  team_visit == '두산' ~ 'OB',
  team_visit == '삼성' ~ 'SS',
  team_visit == '키움' ~ 'WO',
  TRUE ~ team_visit
), team_home = case_when(
  team_home == '한화' ~ 'HH',
  team_home == 'KIA' ~ 'HT',
  team_home == '롯데' ~ 'LT',
  team_home == '두산' ~ 'OB',
  team_home == '삼성' ~ 'SS',
  team_home == '키움' ~ 'WO',
  TRUE ~ team_home
))

home = schedule %>% mutate(T_ID = team_home, APP_T_ID = team_visit, H_A = 'HOME') %>%
  select(year, month, T_ID, APP_T_ID, H_A)
away = schedule %>% mutate(T_ID = team_visit, APP_T_ID = team_home, H_A = 'AWAY') %>%
  select(year, month, T_ID, APP_T_ID, H_A)

before_home = before %>% mutate(T_ID = team_home, APP_T_ID = team_visit, H_A = 'HOME') %>%
  select(year, month, T_ID, APP_T_ID, H_A)
before_away = before %>% mutate(T_ID = team_visit, APP_T_ID = team_home, H_A = 'AWAY') %>%
  select(year, month, T_ID, APP_T_ID, H_A)

schedule = rbind(home, away)
before = rbind(before_home, before_away) %>% arrange(month)

schedule = schedule %>% arrange(month)

write.csv(schedule, "schedule.csv", row.names = FALSE)
write.csv(before, "before_0719.csv", row.names = FALSE)
