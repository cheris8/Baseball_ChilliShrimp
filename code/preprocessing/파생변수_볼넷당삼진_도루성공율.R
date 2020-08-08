

###--볼넷당 삼진비율과 도류성공율 컬럼 만들기--------###

batter = read.csv('C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/batter.csv',header=T)
pitcher = read.csv('C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/pitcher.csv',header=T)

head(pitcher)
tail(pitcher)
str(pitcher) 

head(batter)
tail(batter)
str(batter) 

install.packages('dplyr')
library(dplyr)


###----------볼넷 당 삼진 비율(KBB,투수기준)---------###
sub_pitcher = pitcher %>%     # KBB 구하기 위해 P_ID, KK, BB 선택
  select(P_ID, KK, BB)

P_KBB = sub_pitcher %>%          # KBB컬럼 추가
  mutate(KBB = KK/BB)

head(P_KBB, n= 20)

sum(is.na(P_KBB$KBB))          # NA 개수 세기 
sum(is.infinite(P_KBB$KBB))    # Inf 개수 세기

# P_KBB$KBB[is.na(P_KBB$KBB)] =  ## na값을 뭘로 바꿔야 좋을까요..? 0/0인 경우...
# P_KBB$KBB[is.infinite(P_KBB$KBB)] =  ## Inf값을 뭘로 바꿔야 좋을까요..?  3/0인 경우...


###----------볼넷 당 삼진 비율(KBB,타자기준)---------###
sub_batter = batter %>%
  select(P_ID, SB, CS, KK, BB)  # KBB, SB% 구하기 위해 P_ID, SB, CS, KK, BB 선택

B_KBB = sub_batter %>%            # KBB컬럼 추가
  mutate(KBB = KK/BB)

head(B_KBB,n=20)

sum(is.na(B_KBB$KBB))           # NA 개수 세기 
sum(is.infinite(B_KBB$KBB))     # Inf 개수 세기

# B_KBB$KBB[is.na(B_KBB$KBB)] =  ## na값을 뭘로 바꿔야 좋을까요..? 0/0인 경우...
# B_KBB$KBB[is.infinite(B_KBB$KBB)] =  ## Inf값을 뭘로 바꿔야 좋을까요..?  3/0인 경우...


###----------------도루 성공율(SB%)------------------###

SB_PER = B_KBB %>%           # SB_per 컬럼 추가
  mutate(SB_per = SB/(SB+CS))

head(SB_PER,n=20)

sum(is.na(SB_PER$SB_per))          # NA 개수 세기 
sum(is.infinite(SB_PER$SB_per))    # Inf 개수 세기 



# SB_PER$SB_per[is.na(SB_PER$SB_per)] = ## na값을 뭘로 바꿔야 좋을까요..? 0/(0+0)인 경우,즉 도루를 시도하지 않은 선수들

###------------------결과 저장-----------------------### 

write.csv(P_KBB,'C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/P_KBB.csv')
write.csv(SB_PER,'C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/B_KBB_SB_PER.csv')



