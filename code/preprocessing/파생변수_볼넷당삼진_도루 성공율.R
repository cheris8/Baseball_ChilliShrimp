
###--볼넷당 삼진비율과 도류성공율 컬럼 만들기--------###
install.packages('tidyverse')
library(tidyverse)


batter_tidy = read.csv('C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/batter_tidy.csv',header=T)
Pitcher = read.csv('C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/pitcher.csv',header=T)

head(Pitcher)
tail(Pitcher)
str(Pitcher) 

head(batter_tidy)
tail(batter_tidy)
str(batter_tidy) 



###----------볼넷 당 삼진 비율(KBB,투수기준)---------###

pitcher = Pitcher %>%
  group_by(P_ID) %>%
  summarise(Total_KK = sum(KK), Total_BB = sum(BB)) # 선수별로 스트라이크와 볼넷을 합산


P_KBB = pitcher %>%          # KBB컬럼 추가
  mutate(KBB = Total_KK/Total_BB)

head(P_KBB, n= 20)

sum(is.na(P_KBB$KBB))          # NA 개수 세기 
sum(is.infinite(P_KBB$KBB))    # Inf 개수 세기  

P_KBB$KBB[is.na(P_KBB$KBB)] = 0
P_KBB$KBB[is.infinite(P_KBB$KBB)] = 0   

sum(is.na(P_KBB$KBB)) 
sum(is.infinite(P_KBB$KBB))

head(P_KBB)

###----------볼넷 당 삼진 비율(KBB,타자기준)---------###

batter = batter_tidy %>%
  group_by(P_ID) %>%
  summarise(Total_KK = sum(KK), Total_BB = sum(BB)) # 선수별로 스트라이크와 볼넷을 합산

B_KBB = batter %>%            # KBB컬럼 추가
  mutate(KBB = Total_KK/Total_BB)

head(B_KBB,n=20)

sum(is.na(B_KBB$KBB))           # NA 개수 세기 
sum(is.infinite(B_KBB$KBB))     # Inf 개수 세기

B_KBB$KBB[is.na(B_KBB$KBB)] =  0
B_KBB$KBB[is.infinite(B_KBB$KBB)] =  0

sum(is.na(B_KBB$KBB))
sum(is.infinite(B_KBB$KBB))

head(B_KBB, n =20)
###----------------도루 성공율(SB_rate)------------------###
batter = batter_tidy %>%
  group_by(P_ID) %>%
  summarise(Total_SB = sum(SB), Total_CS = sum(CS)) # 선수별로 도루성공과 도루실패를 합산

SB_RATE = batter %>%           # SB_rate 컬럼 추가
  mutate(SB_rate = Total_SB/(Total_SB+Total_CS))

head(SB_RATE,n=20)

sum(is.na(SB_RATE$SB_rate))          # NA 개수 세기 
sum(is.infinite(SB_RATE$SB_rate))    # Inf 개수 세기 

SB_RATE$SB_rate[is.na(SB_RATE$SB_rate)] = 0

sum(is.infinite(SB_RATE$SB_rate))

head(SB_RATE,n=20)
###---------------기존 pitcher 데이터와 합치기---------------###
P_df1 = cbind(select(pitcher,P_ID),select(P_KBB,KBB))

P_df2 = left_join(Pitcher,P_df1,by='P_ID')

###---------------기존 batter_tidy데이터와 합치기---------------###
B_df1 = cbind(select(batter,P_ID), select(B_KBB,KBB), select(SB_RATE,SB_rate) )

B_df2 = left_join(batter_tidy,B_df1,by= 'P_ID' )
###------------------결과 저장-----------------------### 


write.csv(P_df2,'C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/pitcher_볼넷당삼진.csv')
write.csv(B_df2,'C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/batter_tidy_볼넷당삼진_도루성공율.csv')



