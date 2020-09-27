#  data import
library(tidyverse)
stadium = read_csv("C:/Users/dhxog/Desktop/ESC_summer/데이터분석분야_퓨처스리그_칠리새우/데이터/1. 크롤링/kbo_schedule_stadium.csv")

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

VS_T_ID_AWAY = stadium_away %>% transmute(VS_T_ID = T_ID)

stadium_home = cbind(stadium_home, VS_T_ID_AWAY)

VS_T_ID_HOME = stadium_home %>% transmute(VS_T_ID = T_ID)

stadium_away = cbind(stadium_away, VS_T_ID_HOME)

stadium_away = stadium_away %>% mutate(HOME = 0, AWAY = 1)
stadium_home = stadium_home %>% mutate(HOME = 1, AWAY = 0)

stadium = rbind(stadium_away, stadium_home) %>% arrange(year, month, day)



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

stadium = stadium %>% mutate(
  VS_T_ID_HH = case_when(
    VS_T_ID == 'HH' ~ 1,
    TRUE ~ 0
  ),
  VS_T_ID_HT = case_when(
    VS_T_ID == 'HT' ~ 1,
    TRUE ~ 0
  ),
  VS_T_ID_KT = case_when(
    VS_T_ID == 'KT' ~ 1,
    TRUE ~ 0
  ),
  VS_T_ID_LG = case_when(
    VS_T_ID == 'LG' ~ 1,
    TRUE ~ 0
  ),
  VS_T_ID_LT = case_when(
    VS_T_ID == 'LT' ~ 1,
    TRUE ~ 0
  ),
  VS_T_ID_NC = case_when(
    VS_T_ID == 'NC' ~ 1,
    TRUE ~ 0
  ),
  VS_T_ID_OB = case_when(
    VS_T_ID == 'OB' ~ 1,
    TRUE ~ 0
  ),
  VS_T_ID_SK = case_when(
    VS_T_ID == 'SK' ~ 1,
    TRUE ~ 0
  ),
  VS_T_ID_SS = case_when(
    VS_T_ID == 'SS' ~ 1,
    TRUE ~ 0
  ),
  VS_T_ID_WO = case_when(
    VS_T_ID == 'WO' ~ 1,
    TRUE ~ 0
  ),
)


stadium = stadium %>% select(-day) %>% group_by(year, month, T_ID) %>% summarise(stadium_MH = sum(stadium_MH), stadium_MS = sum(stadium_MS),stadium_JS = sum(stadium_JS),stadium_SW = sum(stadium_SW),stadium_DJ = sum(stadium_DJ),stadium_DG = sum(stadium_DG),stadium_GJ = sum(stadium_GJ),stadium_GC = sum(stadium_GC), stadium_SJ = sum(stadium_SJ), stadium_PH = sum(stadium_PH), stadium_US = sum(stadium_US), stadium_CJ = sum(stadium_CJ), stadium_CW = sum(stadium_CW), VS_T_ID_HH = sum(VS_T_ID_HH), VS_T_ID_HT = sum(VS_T_ID_HT),VS_T_ID_KT = sum(VS_T_ID_KT),VS_T_ID_LG = sum(VS_T_ID_LG),VS_T_ID_LT = sum(VS_T_ID_LT),VS_T_ID_NC = sum(VS_T_ID_NC),VS_T_ID_OB = sum(VS_T_ID_OB),VS_T_ID_SK = sum(VS_T_ID_SK),VS_T_ID_SS = sum(VS_T_ID_SS),VS_T_ID_WO = sum(VS_T_ID_WO), HOME = sum(HOME), AWAY = sum(AWAY))

write.csv(stadium, "schedule.csv", row.names = F)







