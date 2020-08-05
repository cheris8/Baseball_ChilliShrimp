library(tidyverse)
library(lubridate)

pit_2016 = read_csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\개인투수\\2020빅콘테스트_스포츠투아이_제공데이터_개인투수_2016.csv")
pit_2017 = read_csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\개인투수\\2020빅콘테스트_스포츠투아이_제공데이터_개인투수_2017.csv")
pit_2018 = read_csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\개인투수\\2020빅콘테스트_스포츠투아이_제공데이터_개인투수_2018.csv")
pit_2019 = read_csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\개인투수\\2020빅콘테스트_스포츠투아이_제공데이터_개인투수_2019.csv")
pit_2020 = read_csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\개인투수\\2020빅콘테스트_스포츠투아이_제공데이터_개인투수_2020.csv")

pit_2016 = pit_2016 %>% select(-c(G_ID, HEADER_NO, QUIT_CK, P_WHIP_RT, P2_WHIP_RT, CB_WHIP_RT))
pit_2017 = pit_2017 %>% select(-c(G_ID, HEADER_NO, QUIT_CK, P_WHIP_RT, P2_WHIP_RT, CB_WHIP_RT))
pit_2018 = pit_2018 %>% select(-c(G_ID, HEADER_NO, QUIT_CK, P_WHIP_RT, P2_WHIP_RT, CB_WHIP_RT))
pit_2019 = pit_2019 %>% select(-c(G_ID, HEADER_NO, QUIT_CK, P_WHIP_RT, P2_WHIP_RT, CB_WHIP_RT))
pit_2020 = pit_2020 %>% select(-c(G_ID, HEADER_NO, QUIT_CK, P_WHIP_RT, P2_WHIP_RT, CB_WHIP_RT))

pitcher = rbind(pit_2016, pit_2017, pit_2018, pit_2019, pit_2020)

pitcher = pitcher %>% mutate(GDAY_DS = ymd(GDAY_DS)) %>% mutate(year = year(GDAY_DS), month = month(GDAY_DS)) %>% select(-GDAY_DS)

colname = pitcher %>% colnames 

pitcher = pitcher %>% select(year, month, colname)

pitcher$WLS[is.na(pitcher$WLS) == T] = 'ND'

write.csv(pitcher, "pitcher.csv", row.names = FALSE)

