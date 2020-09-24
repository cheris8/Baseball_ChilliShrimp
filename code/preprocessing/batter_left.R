library(tidyverse)

# 1. 크롤링 데이터 합치기
batter = read_csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\batter_predict.csv")
colnames(batter)

july_batter = read_csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\kbo_record_hitter_july.csv")

july_batter = july_batter %>% mutate(year = 2020, month = 7) %>% select(-c(X1, 순위)) 

aug_batter = read_csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\kbo_record_hitter_august.csv")

aug_batter = aug_batter %>% mutate(year = 2020, month = 8) %>% select(-c(X1, 순위)) 

sep_batter = read_csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\kbo_record_hitter_septemberplus.csv")

sep_batter = sep_batter %>% mutate(year = 2020, month = 9) %>% select(-c(X1, 순위))

batter_left = rbind(july_batter, aug_batter, sep_batter)

colnames(batter_left) = c('P_ID', 'T_ID', 'AVG', 'AB', 'HIT', 'H2', 'H3', 'HR', 'RBI', 'BB', 'HP', 'KK', 'GD', 'year', 'month')

batter_left['AVG'] = round(as.numeric(batter_left$AVG), 3)

batter_left$AVG[is.na(batter_left$AVG) == T] = 0

batter_left = batter_left %>% mutate(PA = AB + BB + HP)

batter_left = batter_left %>% mutate(T_ID = case_when(
  T_ID == '한화' ~ 'HH',
  T_ID == 'KIA' ~ 'HT',
  T_ID == '삼성' ~ 'SS',
  T_ID == '두산' ~ 'OB',
  T_ID == '키움' ~ 'WO',
  T_ID == '롯데' ~ 'LT',
  TRUE ~ T_ID
)) 







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

batter_left = sqldf('SELECT year, month, P_ID, PCODE, batter_left.T_ID, PA, AB, HIT, H2, H3, HR, RBI, BB, HP, KK, GD, AVG FROM batter_left LEFT OUTER JOIN player ON batter_left.P_ID = player.NAME AND batter_left.T_ID = player.T_ID' )





colnames(player_2017) = c( 'PCODE' , 'P_ID', 'T_ID')
colnames(player_2019) = c( 'PCODE' , 'P_ID', 'T_ID')
colnames(player_2016) = c( 'PCODE' , 'P_ID', 'T_ID')


player_before = rbind(player_2017, player_2019, player_2016) %>% unique()


player_before = player_before %>% filter(P_ID != '김재현' & T_ID != 'SK' & T_ID != 'SS')

player_before = player_before %>% select(-T_ID) %>% unique()

batter_left[is.na(batter_left$PCODE) == T, 'PCODE'] = batter_left[is.na(batter_left$PCODE) == T, ] %>% left_join(player_before, by = c('P_ID')) %>% select(PCODE.y)



new_player = batter_left[is.na(batter_left$PCODE) == T,] %>% select(P_ID, PCODE, T_ID) %>% unique() 

new_PID = c(50350,64209,65462, 50469,64896, 50802, 65522, 67893, 50203, 62332,69104, 67063, 67449)

new_player['PCODE'] = new_PID


batter_left = batter_left %>% left_join(new_player, by = c('P_ID', 'T_ID')) %>% mutate(P_ID = case_when(
  is.na(PCODE.x) == T ~ as.numeric(PCODE.y),
  TRUE ~ as.numeric(PCODE.x)
)) %>% select(-c(PCODE.x, PCODE.y))




# 팀간 경기수, 배팅 오더 포함

schedule = read.csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\schedule_left.csv")

batter_left = batter_left %>% left_join(schedule, by = c('year', 'month', 'T_ID'))

order = read.csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\batter_tidy.csv")

order = order %>% filter(year == 2020, month == 7) %>% select(P_ID, BAT_ORDER) %>% unique()

batter_left = batter_left %>% left_join(order, by = 'P_ID')

batter_left %>% summary

write.csv(batter_left, "batter_left.csv", row.names = F)
