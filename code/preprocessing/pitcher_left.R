library(tidyverse)

# 1. 크롤링 데이터 합치기


july_pitcher = read_csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/kbo_record_pitcher_july.csv")

july_pitcher = july_pitcher %>% mutate(year = 2020, month = 7) %>% select(-c(X1, 순위)) 

aug_pitcher = read_csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/kbo_record_pitcher_august.csv")

aug_pitcher = aug_pitcher %>% mutate(year = 2020, month = 8) %>% select(-c(X1, 순위)) 

sep_pitcher = read_csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/kbo_record_pitcher_septemberplus.csv")

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

player = read.csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/%EC%84%A0%EC%88%98/2020%EB%B9%85%EC%BD%98%ED%85%8C%EC%8A%A4%ED%8A%B8_%EC%8A%A4%ED%8F%AC%EC%B8%A0%ED%88%AC%EC%95%84%EC%9D%B4_%EC%A0%9C%EA%B3%B5%EB%8D%B0%EC%9D%B4%ED%84%B0_%EC%84%A0%EC%88%98_2020.csv")

player_2016 = read.csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/%EC%84%A0%EC%88%98/2020%EB%B9%85%EC%BD%98%ED%85%8C%EC%8A%A4%ED%8A%B8_%EC%8A%A4%ED%8F%AC%EC%B8%A0%ED%88%AC%EC%95%84%EC%9D%B4_%EC%A0%9C%EA%B3%B5%EB%8D%B0%EC%9D%B4%ED%84%B0_%EC%84%A0%EC%88%98_2016.csv")

player_2017 = read.csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/%EC%84%A0%EC%88%98/2020%EB%B9%85%EC%BD%98%ED%85%8C%EC%8A%A4%ED%8A%B8_%EC%8A%A4%ED%8F%AC%EC%B8%A0%ED%88%AC%EC%95%84%EC%9D%B4_%EC%A0%9C%EA%B3%B5%EB%8D%B0%EC%9D%B4%ED%84%B0_%EC%84%A0%EC%88%98_2017.csv")

player_2019 = read.csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/%EC%84%A0%EC%88%98/2020%EB%B9%85%EC%BD%98%ED%85%8C%EC%8A%A4%ED%8A%B8_%EC%8A%A4%ED%8F%AC%EC%B8%A0%ED%88%AC%EC%95%84%EC%9D%B4_%EC%A0%9C%EA%B3%B5%EB%8D%B0%EC%9D%B4%ED%84%B0_%EC%84%A0%EC%88%98_2019.csv")

player_2018 = read.csv("https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/%EC%84%A0%EC%88%98/2020%EB%B9%85%EC%BD%98%ED%85%8C%EC%8A%A4%ED%8A%B8_%EC%8A%A4%ED%8F%AC%EC%B8%A0%ED%88%AC%EC%95%84%EC%9D%B4_%EC%A0%9C%EA%B3%B5%EB%8D%B0%EC%9D%B4%ED%84%B0_%EC%84%A0%EC%88%98_2018.csv")

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




write.csv(pitcher_left, "pitcher_left.csv", row.names = F)
