
###--볼넷당 삼진비율과 도류성공율 컬럼 만들기--------###
install.packages('dplyr')
library(dplyr)


batter_tidy = read.csv('C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/batter_tidy.csv',header=T)
pitcher = read.csv('C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/pitcher.csv',header=T)

head(pitcher)
tail(pitcher)
str(pitcher) 

head(batter_tidy)
tail(batter_tidy)
str(batter_tidy) 




###----------볼넷 당 삼진 비율(KBB,투수기준)---------###
sub_pitcher = pitcher %>%     # KBB 구하기 위해 P_ID, KK, BB 선택
  select(P_ID, KK, BB)

P_KBB = sub_pitcher %>%          # KBB컬럼 추가
  mutate(KBB = KK/BB)

head(P_KBB, n= 20)

sum(is.na(P_KBB$KBB))          # NA 개수 세기 
sum(is.infinite(P_KBB$KBB))    # Inf 개수 세기  

P_KBB$KBB[is.na(P_KBB$KBB)] = 0
P_KBB$KBB[is.infinite(P_KBB$KBB)] = 0    # 나중에 다시 확인**************

sum(is.na(P_KBB$KBB)) 
sum(is.infinite(P_KBB$KBB))




###----------볼넷 당 삼진 비율(KBB,타자기준)---------###
sub_batter = batter_tidy %>%
  select(P_ID, SB, CS, KK, BB)  # KBB, SB% 구하기 위해 P_ID, SB, CS, KK, BB 선택

B_KBB = sub_batter %>%            # KBB컬럼 추가
  mutate(KBB = KK/BB)

head(B_KBB,n=20)

sum(is.na(B_KBB$KBB))           # NA 개수 세기 
sum(is.infinite(B_KBB$KBB))     # Inf 개수 세기

B_KBB$KBB[is.na(B_KBB$KBB)] =  0
B_KBB$KBB[is.infinite(B_KBB$KBB)] =  0  # 나중에 다시 확인************

sum(is.na(B_KBB$KBB))
sum(is.infinite(B_KBB$KBB))

###----------------도루 성공율(SB_rate)------------------###

SB_RATE = B_KBB %>%           # SB_rate 컬럼 추가
  mutate(SB_rate = SB/(SB+CS))

head(SB_RATE,n=20)

sum(is.na(SB_RATE$SB_rate))          # NA 개수 세기 
sum(is.infinite(SB_RATE$SB_rate))    # Inf 개수 세기 

SB_RATE$SB_rate[is.na(SB_RATE$SB_rate)] = 0

sum(is.infinite(SB_RATE$SB_rate))

###---------------기존 batter_tidy데이터와 합치기---------------###
batter_tidy <- cbind(batter_tidy,select(SB_RATE,KBB,SB_rate))

###------------------결과 저장-----------------------### 


write.csv(select(P_KBB,KBB),'C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/투수_볼넷당삼진.csv')
write.csv(batter_tidy,'C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/batter_tidy_볼넷당삼진_도루성공율.csv')



