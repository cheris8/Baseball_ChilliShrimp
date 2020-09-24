library(tidyverse)

# 1. 크롤링 데이터 합치기
pitcher = read_csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\pitcher_predict.csv")
colnames(pitcher)

july_pitcher = read_csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\kbo_record_pitcher_july.csv")

july_pitcher = july_pitcher %>% mutate(year = 2020, month = 7) %>% select(-c(X1, 순위)) 

aug_pitcher = read_csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\kbo_record_pitcher_august.csv")

aug_pitcher = aug_pitcher %>% mutate(year = 2020, month = 8) %>% select(-c(X1, 순위)) 

sep_pitcher = read_csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\kbo_record_pitcher_septemberplus.csv")

sep_pitcher = sep_pitcher %>% mutate(year = 2020, month = 9) %>% select(-c(X1, 순위))

pitcher_left = rbind(july_pitcher, aug_pitcher, sep_pitcher)

head(pitcher_left)

colnames(pitcher_left) = c('P_ID', 'T_ID', 'HIT', 'H2', 'H3', 'HR', 'BB', 'HP', 'KK', 'WP', 'BK', 'AVG', 'year', 'month')

pitcher_left = pitcher_left %>% mutate(T_ID = case_when(
  T_ID == '한화' ~ 'HH',
  T_ID == 'KIA' ~ 'HT',
  T_ID == '삼성' ~ 'SS',
  T_ID == '두산' ~ 'OB',
  T_ID == '키움' ~ 'WO',
  T_ID == '롯데' ~ 'LT',
  TRUE ~ T_ID
)) 

pitcher_left = pitcher_left %>% mutate(AB = case_when(
  as.numeric(AVG) == 0 ~ 0,
  AVG == '-' ~ 0,
  TRUE ~ round(HIT / as.numeric(AVG))
), AVG = case_when(
  AVG == '-' ~ 0,
  TRUE ~ as.numeric(AVG)
) ) 

pitcher_left = pitcher_left %>% mutate(PA = AB + BB + HP)


# 2. P_ID, T_ID 코드로 바꾸기

player = read.csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\선수\\2020빅콘테스트_스포츠투아이_제공데이터_선수_2020.csv")

player_2016 = read.csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\선수\\2020빅콘테스트_스포츠투아이_제공데이터_선수_2016.csv")

player_2017 = read.csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\선수\\2020빅콘테스트_스포츠투아이_제공데이터_선수_2017.csv")

player_2019 = read.csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\선수\\2020빅콘테스트_스포츠투아이_제공데이터_선수_2019.csv")

player_2016 = player_2016 %>% select(PCODE, NAME, T_ID)

player_2017 = player_2017 %>% select(PCODE, NAME, T_ID)

player_2019 = player_2019 %>% select(PCODE, NAME, T_ID)

player = player %>% select(NAME, PCODE, T_ID)

library(sqldf)

pitcher_left = sqldf('SELECT year, month, P_ID, PCODE, pitcher_left.T_ID, PA, AB, HIT, H2, H3, HR,  BB, HP, KK, BK, AVG FROM pitcher_left LEFT OUTER JOIN player ON pitcher_left.P_ID = player.NAME AND pitcher_left.T_ID = player.T_ID' )


colnames(player_2017) = c( 'PCODE' , 'P_ID', 'T_ID')
colnames(player_2019) = c( 'PCODE' , 'P_ID', 'T_ID')
colnames(player_2016) = c( 'PCODE' , 'P_ID', 'T_ID')


player_before = rbind(player_2017, player_2019, player_2016) %>% unique()


pitcher_left[is.na(pitcher_left$PCODE) == T, 'PCODE'] = pitcher_left[is.na(pitcher_left$PCODE) == T, ] %>% left_join(player_before, by = c('P_ID')) %>% select(PCODE.y)


# 새로 데뷔한 선수들 코드 추가
new_player = pitcher_left[is.na(pitcher_left$PCODE) == T,] %>% select(P_ID, PCODE, T_ID) %>% unique()

new_PID = c(64896,50397,50109,65937,69703,50203, 69104,67711 ,64580 )

new_player["PCODE"] = new_PID


pitcher_left = pitcher_left %>% left_join(new_player, by = c('P_ID', 'T_ID')) %>% mutate(P_ID = case_when(
  is.na(PCODE.x) == T ~ as.numeric(PCODE.y),
  TRUE ~ as.numeric(PCODE.x)
)) %>% select(-c(PCODE.x, PCODE.y))

pitcher_left %>% summary

# 팀간 경기수 포함

schedule = read.csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\schedule_left.csv")

pitcher_left = pitcher_left %>% left_join(schedule, by = c('year', 'month', 'T_ID'))

pitcher_left %>% summary



write.csv(pitcher_left, "pitcher_left.csv", row.names = F)
