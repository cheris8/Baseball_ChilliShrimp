library(tidyverse)

pitcher <- read.csv('C:/Users/seungjun/Desktop/baseball/data/raw_pitcher.csv')
names(pitcher)

## 리그 평균 ERA
Total_ERA = pitcher %>%
  select(year,ER,PA,HIT,BB,HP) %>% 
  group_by(year) %>%
  summarise(ER = sum(ER), PA= sum(PA), HIT= sum(HIT),BB= sum(BB), HP= sum(HP)) %>%
  mutate(Total_ERA = ER*9/(  (PA-HIT-BB-HP)/3) ) %>%
  select(year,Total_ERA)


## 선수별 ERA
ERA = pitcher %>%
  select(P_ID,year,ER,PA,HIT,BB,HP) %>% 
  mutate(ERA = ER*9/(  (PA-HIT-BB-HP)/3) ) %>%
  select(ERA)

ERA$ERA[is.na(ERA$ERA)] = 0
ERA$ERA[is.infinite(ERA$ERA)] = 99.99

sum(is.na(ERA$ERA))
sum(is.infinite(ERA$ERA))



###선수별 FIP.  IB 고려 x

Total_FIP = pitcher %>%
  group_by(year) %>%
  summarise(HR= sum(HR),KK=sum(KK) ,PA= sum(PA), HIT= sum(HIT),BB= sum(BB), HP= sum(HP)) %>%
  mutate(Total_FIP = (13*HR + 3*(BB+HP) - 2*KK) /  ((PA-HIT-BB-HP)/3)) %>%
  select(year,Total_FIP)


FIP = pitcher %>%
 mutate(FIP = (13*HR + 3*(BB+HP) - 2*KK) /  ((PA-HIT-BB-HP)/3)) 


FIP$FIP[is.na(FIP$FIP)] = 0
FIP$FIP[is.infinite(FIP$FIP)] = 0

sum(is.na(FIP$FIP))
sum(is.infinite(FIP$FIP))


R_FIP = FIP %>%
  left_join(Total_ERA,by='year') %>%
  left_join(Total_FIP,by='year') %>%
  mutate(R_FIP = FIP + (Total_ERA-Total_FIP)) %>% 
  select(R_FIP)

sum(is.na(R_FIP$R_FIP))
sum(is.infinite(R_FIP$R_FIP))

#----------볼넷 당 삼진 비율(KBB,투수기준)---------#

KBB = pitcher %>%
  mutate(KBB = KK/BB) %>%
  select(KBB)

sum(is.na(KBB$KBB))          
sum(is.infinite(KBB$KBB))    

KBB$KBB[is.na(KBB$KBB)] = 0
KBB$KBB[is.infinite(KBB$KBB)] = 0   

sum(is.na(KBB$KBB)) 
sum(is.infinite(KBB$KBB))

#--------------------------------#
kwERA = pitcher %>%
  mutate(kwERA = (5.40 -12*(KK-BB)/PA) ) %>%
  select(kwERA)


kwERA$kwERA[is.na(kwERA$kwERA)] = 0
kwERA$kwERA[is.infinite(kwERA$kwERA)] = 99.99

sum(is.na(kwERA$kwERA))
sum(is.infinite(kwERA$kwERA))





#---------------------------------#
dataset <- cbind(pitcher,KBB,ERA,R_FIP,kwERA)
dataset$SB_succ[is.na(dataset$SB_succ)] = 0
dataset$SB_try[is.na(dataset$SB_try)] = 0
dataset$BK_rate[is.na(dataset$BK_rate)] = 0

sum(is.na(dataset))

dataset %>% 
  summary()

write.csv(dataset,'C:/Users/seungjun/Desktop/baseball/data/pitcher_변수추가.csv')





