#  data import
library(tidyverse)
stadium = read_csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\kbo_schedule_stadium.csv")

stadium = stadium %>% select(-X1)
stadium = stadium %>% mutate(stadium = 구장) %>% select(-구장)

# 시범경기, 포스트시즌 삭제

## 2016시즌

stadium = stadium %>% filter(paste0(year , month) != '20163')

stadium = setdiff(stadium, stadium %>% filter(year == 2016 & month == 10 & day >= 10))


## 2017시즌

stadium = setdiff(stadium, stadium %>% filter(year == 2017 & month == 3 & day < 31))


stadium = setdiff(stadium, stadium %>% filter(year == 2017 & month == 10 & day > 4))

## 2018 시즌

stadium = setdiff(stadium, stadium %>% filter(year == 2018 & month == 3 & day < 24))

stadium = setdiff(stadium, stadium %>% filter(year == 2018 & month == 10 & day > 15))

## 2019 시즌

stadium = setdiff(stadium, stadium %>% filter(year == 2019 & month == 3 & day < 23))

stadium = setdiff(stadium, stadium %>% filter(year == 2019 & month == 10 & day > 2))

## 2020 시즌

stadium = setdiff(stadium, stadium %>% filter(year == 2020 & month == 4))
       
stadium = setdiff(stadium, stadium %>% filter(year == 2020 & month == 5 & day < 5))

# tidy 형식으로 만들기

stadium_away = stadium %>% select(year, month, day, team_visit, stadium)

stadium_home = stadium %>% select(year, month, day, team_home, stadium)

colnames(stadium_away) = c('year', 'month', 'day', 'T_ID', 'stadium')

colnames(stadium_home) = c('year', 'month', 'day', 'T_ID', 'stadium')

stadium = rbind(stadium_away, stadium_home) %>% arrange(year, month, day)

stadium = stadium %>% mutate(T_ID = case_when(
  T_ID == '한화' ~ 'HH',
  T_ID == 'KIA' ~ 'HT',
  T_ID == 'kt' ~ 'KT',
  T_ID == '롯데' ~ 'LT',
  T_ID == '두산' ~ 'OB',
  T_ID == '넥센' ~ 'WO',
  T_ID == '키움' ~ 'WO',
  T_ID == '삼성' ~ 'SS',
  TRUE ~ T_ID
))

stadium %>% select(stadium) %>% unique()



stadium = stadium %>% mutate(stadium = case_when(
  stadium == '문학' ~ 'MH',
  stadium == '마산' ~ 'MS',
  substr(stadium, 1, 2) == '잠실' ~ 'JS',
  substr(stadium, 1, 2) == '수원' ~ 'SW',
  substr(stadium, 1, 2) == '대전' ~ 'DJ',
  substr(stadium, 1, 2) == '대구' ~ 'DG',
  substr(stadium, 1, 2) == '광주' ~ 'GJ',
  stadium == '고척' ~ 'GC',
  stadium == '사직' ~ 'SJ',
  stadium == '포항' ~ 'PH',
  stadium == '울산' ~ 'US',
  stadium == '청주' ~ 'CJ',
  stadium == '창원' ~ 'CW'
))

# one - hot encoding

stadium = stadium %>% mutate(stadium_MH = case_when(stadium == 'MH' ~ 1, TRUE ~ 0),stadium_MS = case_when(stadium == 'MS' ~ 1, TRUE ~ 0), stadium_JS = case_when(stadium == 'JS' ~ 1, TRUE ~ 0),stadium_SW = case_when(stadium == 'SW' ~ 1, TRUE ~ 0), stadium_DJ = case_when(stadium == 'DJ' ~ 1, TRUE ~ 0), stadium_DG = case_when(stadium == 'DG' ~ 1, TRUE ~ 0), stadium_GJ = case_when(stadium == 'GJ' ~ 1, TRUE ~ 0), stadium_GC = case_when(stadium == 'GC' ~ 1, TRUE ~ 0), stadium_SJ = case_when(stadium == 'SJ' ~ 1, TRUE ~ 0), stadium_PH = case_when(stadium == 'PH' ~ 1, TRUE ~ 0), stadium_US = case_when(stadium == 'US' ~ 1, TRUE ~ 0), stadium_CJ = case_when(stadium == 'CJ' ~ 1, TRUE ~ 0), stadium_CW = case_when(stadium == 'CW' ~ 1, TRUE ~ 0))


stadium = stadium %>% select(-day) %>% group_by(year, month, T_ID) %>% summarise(stadium_MH = sum(stadium_MH), stadium_MS = sum(stadium_MS),stadium_JS = sum(stadium_JS),stadium_SW = sum(stadium_SW),stadium_DJ = sum(stadium_DJ),stadium_DG = sum(stadium_DG),stadium_GJ = sum(stadium_GJ),stadium_GC = sum(stadium_GC), stadium_SJ = sum(stadium_SJ), stadium_PH = sum(stadium_PH), stadium_US = sum(stadium_US), stadium_CJ = sum(stadium_CJ), stadium_CW = sum(stadium_CW))


# modeling_pitcher랑 합치기

pitcher = read_csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\modeling_pitcher.csv")

pitcher = pitcher %>% left_join(stadium, by = c('year', 'month', 'T_ID'))

write.csv(pitcher, 'modeling_pitcher_stadium.csv', row.names = F)
