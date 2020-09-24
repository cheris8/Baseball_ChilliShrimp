
batter_tidy = read.csv('C:/Users/seungjun/Desktop/baseball/data/batter_tidy.csv')
pitcher_data =  read.csv('C:/Users/seungjun/Desktop/baseball/data/pitcher.csv')

#-------타자 통산 도루시도율(타석당)------------#
#-------타자 통산 도루성공율--------------------#
#-------타자 통산 희생플라이(타석당)------------#
batter = batter_tidy %>%
  group_by(P_ID) %>%
  summarise(SB = sum(SB), CS = sum(CS), PA = sum(PA), SF = sum(SF)) %>%
  mutate(SB_try = (SB + CS) / PA, SB_succ = SB/(SB + CS), SF_per_PA = SF/ PA ) %>% 
  select(-c(SB,CS,PA,SF)) 

sum(is.na(batter$SB_try))
sum(is.na(batter$SB_succ))
sum(is.na(batter$SF_per_PA))

sum(is.infinite(batter$SB_try))
sum(is.infinite(batter$SB_succ))
sum(is.infinite(batter$SF_per_PA))

batter$SB_try[is.na(batter$SB_try)] = 0
batter$SB_succ[is.na(batter$SB_succ)] = 0
batter$SF_per_PA[is.na(batter$SF_per_PA)] = 0

batter$SB_try[is.infinite(batter$SB_try)] = 0
batter$SB_succ[is.infinite(batter$SB_succ)] = 0
batter$SF_per_PA[is.infinite(batter$SF_per_PA)] = 0

sum(is.na(batter$SB_try))
sum(is.na(batter$SB_succ))
sum(is.na(batter$SF_per_PA))

sum(is.infinite(batter$SB_try))
sum(is.infinite(batter$SB_succ))
sum(is.infinite(batter$SF_per_PA))

view(batter) ## 통산 도루시도율(타석당) -> SB_try
             ## 통산 도루성공율         -> SB_succ
             ## 통산 희생플라이         -> SF_per_PA   로 각각 저장했습니다.



#-------투수 통산 도루시도율(타석당)------------#
#-------투수 통산 도루성공율--------------------#
#-------투수 통산 희생플라이(타석당)------------#
#-------투수 통산 ERR(2020년도만,팀별)----------#

pitcher = pitcher_data %>%
  group_by(P_ID) %>%
  summarise(SB = sum(SB), CS = sum(CS), PA = sum(PA), SF = sum(SF)) %>%
  mutate(SB_try = (SB + CS) / PA, SB_succ = SB/(SB + CS), SF_per_PA = SF/ PA ) %>% 
  select(-c(SB,CS,PA,SF))

sum(is.na(pitcher$SB_try))
sum(is.na(pitcher$SB_succ))
sum(is.na(pitcher$SF_per_PA))

sum(is.infinite(pitcher$SB_try))
sum(is.infinite(pitcher$SB_succ))
sum(is.infinite(pitcher$SF_per_PA))

pitcher$SB_try[is.na(pitcher$SB_try)] = 0
pitcher$SB_succ[is.na(pitcher$SB_succ)] = 0
pitcher$SF_per_PA[is.na(pitcher$SF_per_PA)] = 0

pitcher$SB_try[is.infinite(pitcher$SB_try)] = 0
pitcher$SB_succ[is.infinite(pitcher$SB_succ)] = 0
pitcher$SF_per_PA[is.infinite(pitcher$SF_per_PA)] = 0

sum(is.na(pitcher$SB_try))
sum(is.na(pitcher$SB_succ))
sum(is.na(pitcher$SF_per_PA))

sum(is.infinite(pitcher$SB_try))
sum(is.infinite(pitcher$SB_succ))
sum(is.infinite(pitcher$SF_per_PA))

view(pitcher)     ## 통산 도루시도율(타석당) -> SB_try
                  ## 통산 도루성공율         -> SB_succ
                  ## 통산 희생플라이         -> SF_per_PA   로 각각 저장했습니다.

ERR = pitcher_data %>%
  filter(year==2020) %>%
  group_by(T_ID) %>%
  summarise(ERR= sum(ERR), PA= sum(PA) ) %>%
  mutate(ERR_per_PA = ERR / PA) %>%
  select(-c(ERR,PA))

sum(is.na(ERR$ERR_per_PA))
sum(is.infinite(ERR$ERR_per_PA))

view(ERR)        ## 투수 통산 ERR(2020년도만,팀별) -> ERR_per_PA로 저장했습니다.
