
#------------------pitcher 데이터셋 정리하기---------------------#
library(tidyverse)
library(lubridate)

pit_2016 = read_csv('C:/Users/seungjun/Desktop/baseball/data/개인투수/2020빅콘테스트_스포츠투아이_제공데이터_개인투수_2016.csv')
pit_2017 = read_csv('C:/Users/seungjun/Desktop/baseball/data/개인투수/2020빅콘테스트_스포츠투아이_제공데이터_개인투수_2017.csv')
pit_2018 = read_csv('C:/Users/seungjun/Desktop/baseball/data/개인투수/2020빅콘테스트_스포츠투아이_제공데이터_개인투수_2018.csv')
pit_2019 = read_csv('C:/Users/seungjun/Desktop/baseball/data/개인투수/2020빅콘테스트_스포츠투아이_제공데이터_개인투수_2019.csv')
pit_2020 = read_csv('C:/Users/seungjun/Desktop/baseball/data/개인투수/2020빅콘테스트_스포츠투아이_제공데이터_개인투수_2020.csv')

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

#---------- BABIP -----------------------#

BABIP = pitcher %>%                     
  group_by(P_ID) %>%                
  summarise(Total_HIT = sum(HIT),Total_HR = sum(HR),Total_AB = sum(AB),Total_KK = sum(KK),Total_SF = sum(SF)) %>%
  mutate(BABIP = (Total_HIT - Total_HR) / (Total_AB - Total_KK - Total_HR + Total_SF))  

head(BABIP)

sum(is.na(BABIP$BABIP))             
sum(is.infinite((BABIP$BABIP)))

BABIP$BABIP[is.na(BABIP$BABIP)] = 0

sum(is.na(BABIP$BABIP))

pitcher1 = left_join(pitcher,select(BABIP,P_ID,BABIP), by='P_ID')


#------------------------------------------------------------------#
## ERA
ERA = pitcher1 %>%
  mutate(ERA = ER/PA)

ERA$ERA[is.na(ERA$ERA)] = 0
ERA$ERA[is.infinite(ERA$ERA)] = 0

sum(is.na(ERA$ERA))
sum(is.infinite(ERA$ERA))


## WHIP
WHIP = ERA %>%
  mutate(WHIP = (HIT + BB)/PA )

WHIP$WHIP[is.na(WHIP$WHIP)] = 0
WHIP$WHIP[is.infinite(WHIP$WHIP)] = 0

sum(is.na(WHIP$WHIP))
sum(is.infinite(WHIP$WHIP))


# FIP = (13*HR + 3*(BB-IBB+HBP) - 2*K) / IP + C
# C = (9*lgER + 2*lgK - 13*lgHR - 3*(lgBB-lgIBB+lgHBP)) / lgIP
#C는 상수라고 해서 그냥 제외. 결측치 압도적으로 줄었다.


FIP = WHIP %>%
  mutate(FIP=(13*HR + 3*(BB-IB+HP) - 2*KK) / PA )

names(FIP)

sum(is.na(FIP$FIP))
sum(is.infinite(FIP$FIP))

FIP$FIP[is.na(FIP$FIP)] = 0
sum(is.na(FIP$FIP))

df2 = FIP %>% 
  select(c(ERA,WHIP,FIP))

pitcher2 <- cbind(pitcher1,df2)

#---------------도루시도율 도루 성공율------------------------#

SB_try = pitcher2 %>%
  mutate(SB_try = (SB + CS) / PA, SB_succ = SB/(SB + CS) )

sum(is.na(SB_try$SB_try))
sum(is.infinite(SB_try$SB_try))
sum(is.na(SB_try$SB_succ))
sum(is.infinite(SB_try$SB_succ))

SB_try$SB_try[is.na(SB_try$SB_try)] = 0
SB_try$SB_succ[is.na(SB_try$SB_succ)] = 0
SB_try$SB_try[is.infinite(SB_try$SB_try)] = 0
SB_try$SB_succ[is.infinite(SB_try$SB_succ)] = 0

sum(is.na(SB_try$SB_try))
sum(is.infinite(SB_try$SB_try))
sum(is.na(SB_try$SB_succ))
sum(is.infinite(SB_try$SB_succ))


## ERC 고의사구를 인정할 경우

ERC = SB_try %>%
  mutate(PTB= 0.89*(1.255*(HIT-HR)+4*HR)+0.56*(BB + HP -IB) )  %>%
  mutate(ERC = 9*((HIT + BB + HP)*PTB)/(PA*AB)-0.56) %>%
  select(-PTB)

sum(is.na(ERC$ERC))
sum(is.infinite((ERC$ERC)))

ERC$ERC[is.na(ERC$ERC)] = 0
ERC$ERC[is.infinite(ERC$ERC)] = 0

sum(is.na(ERC$ERC))
sum(is.infinite((ERC$ERC)))

names(ERC)

pitcher3 <- ERC

#-------------------------------------------------#
rate = pitcher3  %>%
  mutate(H2_rate=H2/HIT,H3_rate=H3/HIT,HR_rate=HR/HIT,BB_rate=BB/PA,
         HP_rate=HP/PA, KK_rate=KK/PA, GD_rate=GD/PA,BF_per_PA=BF/PA,
         BK_rate= BK/(HIT + BB + HP))
names(rate)

rate$H2_rate[is.na(rate$H2_rate)] = 0
rate$H3_rate[is.na(rate$H3_rate)] = 0
rate$HR_rate[is.na(rate$HR_rate)] = 0
rate$BB_rate[is.na(rate$BB_rate)] = 0
rate$HP_rate[is.na(rate$HP_rate)] = 0
rate$KK_rate[is.na(rate$KK_rate)] = 0
rate$GD_rate[is.na(rate$GD_rate)] = 0
rate$BF_per_PA[is.na(rate$BF_per_PA)] = 0
rate$BK_rate[is.na(rate$BK_rate)] = 0

sum(is.na(rate$H2_rate))
sum(is.na(rate$H3_rate))
sum(is.na(rate$HR_rate))
sum(is.na(rate$BB_rate))
sum(is.na(rate$HP_rate))
sum(is.na(rate$KK_rate))
sum(is.na(rate$GD_rate))
sum(is.na(rate$BF_per_PA))
sum(is.na(rate$BK_rate))


rate$H2_rate[is.infinite(rate$H2_rate)] = 0
rate$H3_rate[is.infinite(rate$H3_rate)] = 0
rate$HR_rate[is.infinite(rate$HR_rate)] = 0
rate$BB_rate[is.infinite(rate$BB_rate)] = 0
rate$HP_rate[is.infinite(rate$HP_rate)] = 0
rate$KK_rate[is.infinite(rate$KK_rate)] = 0
rate$GD_rate[is.infinite(rate$GD_rate)] = 0
rate$BF_per_PA[is.infinite(rate$BF_per_PA)] = 0
rate$BK_rate[is.infinite(rate$BK_rate)] = 0

sum(is.infinite(rate$H2_rate))
sum(is.infinite(rate$H3_rate))
sum(is.infinite(rate$HR_rate))
sum(is.infinite(rate$BB_rate))
sum(is.infinite(rate$HP_rate))
sum(is.infinite(rate$KK_rate))
sum(is.infinite(rate$GD_rate))
sum(is.infinite(rate$BF_per_PA))
sum(is.infinite(rate$BK_rate))

pitcher4 <- rate
#----------볼넷 당 삼진 비율(KBB,투수기준)---------#

P_KBB = pitcher4 %>%
  group_by(P_ID) %>%
  summarise(Total_KK = sum(KK), Total_BB = sum(BB)) %>%
  mutate(KBB = Total_KK/Total_BB) %>%
  select(P_ID,KBB)

sum(is.na(P_KBB$KBB))          
sum(is.infinite(P_KBB$KBB))    

P_KBB$KBB[is.na(P_KBB$KBB)] = 0
P_KBB$KBB[is.infinite(P_KBB$KBB)] = 0   

sum(is.na(P_KBB$KBB)) 
sum(is.infinite(P_KBB$KBB))

names(P_KBB)
pitcher5 <- left_join(pitcher4,P_KBB,by='P_ID')
names(pitcher5)
#-------------------------------------------------#
DER = pitcher5 %>%
  mutate(DER = (PA - HIT - KK - BB - HP - ERR ) + (PA - HR - KK - BB - HP))

sum(is.na(DER$DER))
sum(is.infinite((DER$DER)))

DER$DER[is.na(DER$DER)] = 0
DER$DER[is.infinite((DER$DER))] = 0

sum(is.na(DER$DER))
sum(is.infinite((DER$DER)))

pitcher6 <- DER
#-------------------------------------------------#
library(corrplot) 

data_set = pitcher6 %>% select(-c(year,month,T_ID,VS_T_ID,TB_SC,P_ID,START_CK,RELIEF_CK,
                                  CG_CK,WLS,HOLD,INN2,AB,HIT,H2,H3,HR,SB,CS,SH,SF,BB,IB,
                                  HP,KK,GD,WP,ERR,ERR,ER,KBB,BF,BK))



names(data_set)
pitcher_cor = cor(data_set)           
corrplot(pitcher_cor ,method="shade",addshade="all",tl.col="red",tl.srt=30, diag=FALSE )

pitcher_selection = pitcher5 %>% select(-c(KBB,ER,HOLD,INN2,WP,
                                SB,CS,BB,KK,AB,HIT,H2,H3,HR,SH,SF,IB,HP,GD,ERR,ERR,BF,BK))

names(pitcher_selection)  # 선택된 변수를 pitcher_selection이라는 이름에 저장했습니다.


#--------------------------------------------------------------------------#
### ridge, rasso 해보긴 했는데 이를 어떻게 해석해야할지 잘 모르겠습니다  ###
require(glmnet)

# 범주형만 뺴고 나머지 전부 넣음
names(pitcher6)
cand = pitcher6 %>%  
  select(-c(year,month,T_ID,VS_T_ID,TB_SC,P_ID,START_CK,RELIEF_CK,CG_CK,
            WLS))

x=model.matrix(R~.,cand)[,-1]
y=pitcher6$R

# lasso Regression
set.seed(1)

train=sample(1:nrow(x), 0.8*nrow(x))
test=(-train)
y.test=y[test]

grid=10^seq(10,-2,length=100)

lasso.mod=glmnet(x[train,],y[train],alpha=1,lambda=grid)
plot(lasso.mod)

set.seed(1)
cv.out=cv.glmnet(x[train,],y[train],alpha=1)
plot(cv.out)
bestlam=cv.out$lambda.min
bestlam

lasso.pred=predict(lasso.mod,s=bestlam,newx=x[test,])
mean((lasso.pred-y.test)^2)

out=glmnet(x,y,alpha=1,lambda=grid)
lasso.coef=predict(out,type="coefficients",s=bestlam)
lasso.coef

#ridge regression

cv.out=cv.glmnet(x[train,],y[train],alpha=0)
plot(cv.out)
bestlam=cv.out$lambda.min
bestlam

ridge.pred=predict(lasso.mod,s=bestlam,newx=x[test,])
mean((lasso.pred-y.test)^2)

out=glmnet(x,y,alpha=0,lambda=grid)
ridge.coef=predict(out,type="coefficients",s=bestlam)
ridge.coef
#----------------------------------------------------------#








