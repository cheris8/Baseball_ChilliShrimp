library(tidyverse)
batter_rate = read.csv('C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/batter_all.csv',header=T)
batter_rate
names(batter_rate)

data = batter_rate %>%
  filter(year==2020) %>%
  select(c(P_ID,HIT,H2,H3,HR)) %>%
  group_by(P_ID) %>%
  summarise(HIT=sum(HIT),H2=sum(H2),H3=sum(H3),HR=sum(HR))

data =data %>%
  mutate(H2_rate=H2/HIT, H3_rate=H3/HIT, HR_rate=HR/HIT) 

names(data)

data$H2_rate[is.na(data$H2_rate)] = 0
data$H3_rate[is.na(data$H3_rate)] = 0
data$HR_rate[is.na(data$HR_rate)] = 0

data$H2_rate[is.infinite(data$H2_rate)] = 0
data$H3_rate[is.infinite(data$H3_rate)] = 0
data$HR_rate[is.infinite(data$HR_rate)] = 0

data = data %>%
  select(c(P_ID,H2_rate,H3_rate,HR_rate))

names(data)


BABIP = batter_rate %>%  
  filter(year==2020) %>%
  group_by(P_ID) %>%                #  타자 P_ID 별로 통합된 변수들 생성
  summarise(Total_HIT = sum(HIT),Total_HR = sum(HR),Total_AB = sum(AB),Total_KK = sum(KK),Total_SF = sum(SF)) %>%
  mutate(BABIP = (Total_HIT - Total_HR) / (Total_AB - Total_KK - Total_HR + Total_SF))   # BABIP 계산

head(BABIP)

BABIP = BABIP %>%
  select(BABIP)
sum(is.na(BABIP$BABIP))             
sum(is.infinite((BABIP$BABIP)))

BABIP$BABIP[is.na(BABIP$BABIP)] = 0

sum(is.na(BABIP$BABIP))

df = cbind(data,BABIP)

write.csv(df,'C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/batter_rate_BABIP_2020.csv')
