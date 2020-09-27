library(tidyverse)

bat_2016 = read_csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\개인타자\\2020빅콘테스트_스포츠투아이_제공데이터_개인타자_2016.csv")
bat_2017 = read_csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\개인타자\\2020빅콘테스트_스포츠투아이_제공데이터_개인타자_2017.csv")
bat_2018 = read_csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\개인타자\\2020빅콘테스트_스포츠투아이_제공데이터_개인타자_2018.csv")
bat_2019 = read_csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\개인타자\\2020빅콘테스트_스포츠투아이_제공데이터_개인타자_2019.csv")
bat_2020 = read_csv("C:\\Users\\dhxog\\Desktop\\ESC_summer\\Baseball_ChilliShrimp\\data\\개인타자\\2020빅콘테스트_스포츠투아이_제공데이터_개인타자_2020.csv")
bat_2016 %>% view
bat_2016 = bat_2016 %>% select(-c(G_ID, HEADER_NO, START_CK, P_HRA_RT ))
bat_2017 = bat_2017 %>% select(-c(G_ID, HEADER_NO, START_CK, P_HRA_RT ))
bat_2018 = bat_2018 %>% select(-c(G_ID, HEADER_NO, START_CK, P_HRA_RT ))
bat_2019 = bat_2019 %>% select(-c(G_ID, HEADER_NO, START_CK, P_HRA_RT ))
bat_2020 = bat_2020 %>% select(-c(G_ID, HEADER_NO, START_CK, P_HRA_RT ))

library(lubridate)

bat_2016 = bat_2016 %>% mutate(GDAY_DS = ymd(GDAY_DS)) %>% mutate(year = year(GDAY_DS), month = month(GDAY_DS)) %>% select(-GDAY_DS)
bat_2017 = bat_2017 %>% mutate(GDAY_DS = ymd(GDAY_DS)) %>% mutate(year = year(GDAY_DS), month = month(GDAY_DS)) %>% select(-GDAY_DS)
bat_2018 = bat_2018 %>% mutate(GDAY_DS = ymd(GDAY_DS)) %>% mutate(year = year(GDAY_DS), month = month(GDAY_DS)) %>% select(-GDAY_DS)
bat_2019 = bat_2019 %>% mutate(GDAY_DS = ymd(GDAY_DS)) %>% mutate(year = year(GDAY_DS), month = month(GDAY_DS)) %>% select(-GDAY_DS)
bat_2020 = bat_2020 %>% mutate(GDAY_DS = ymd(GDAY_DS)) %>% mutate(year = year(GDAY_DS), month = month(GDAY_DS)) %>% select(-GDAY_DS)
colname = bat_2016 %>% colnames() 

bat_2016 = bat_2016 %>% select(year, month , colname[1:26])
bat_2017 = bat_2017 %>% select(year, month , colname[1:26])
bat_2018 = bat_2018 %>% select(year, month , colname[1:26])
bat_2019 = bat_2019 %>% select(year, month , colname[1:26])
bat_2020 = bat_2020 %>% select(year, month , colname[1:26])


batter = rbind(bat_2016, bat_2017, bat_2018, bat_2019, bat_2020)
write.csv(batter, 'batter_int.csv', row.names = F)
