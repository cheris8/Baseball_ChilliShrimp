
# 투수 BABIP
library(tidyverse)
pitcher = read.csv('C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/pitcher.csv',header=T)
str(pitcher)

BABIP = pitcher %>%                     
  group_by(P_ID) %>%                #  타자 P_ID 별로 통합된 변수들 생성
  summarise(Total_HIT = sum(HIT),Total_HR = sum(HR),Total_AB = sum(AB),Total_KK = sum(KK),Total_SF = sum(SF)) %>%
  mutate(BABIP = (Total_HIT - Total_HR) / (Total_AB - Total_KK - Total_HR + Total_SF))   # BABIP 계산

head(BABIP)

sum(is.na(BABIP$BABIP))             
sum(is.infinite((BABIP$BABIP)))

BABIP$BABIP[is.na(BABIP$BABIP)] = 0

sum(is.na(BABIP$BABIP))

df1 = left_join(pitcher,select(BABIP,P_ID,BABIP), by='P_ID')
df1

write.csv(df1,'C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/Batter_Total_BABIP.csv')

