#----------------batter 생성-----------------------#
library(tidyverse)

bat_2016 = read_csv('C:/Users/seungjun/Desktop/baseball/data/개인타자/2020빅콘테스트_스포츠투아이_제공데이터_개인타자_2016.csv')
bat_2017 = read_csv('C:/Users/seungjun/Desktop/baseball/data/개인타자/2020빅콘테스트_스포츠투아이_제공데이터_개인타자_2017.csv')
bat_2018 = read_csv('C:/Users/seungjun/Desktop/baseball/data/개인타자/2020빅콘테스트_스포츠투아이_제공데이터_개인타자_2018.csv')
bat_2019 = read_csv('C:/Users/seungjun/Desktop/baseball/data/개인타자/2020빅콘테스트_스포츠투아이_제공데이터_개인타자_2019.csv')
bat_2020 = read_csv('C:/Users/seungjun/Desktop/baseball/data/개인타자/2020빅콘테스트_스포츠투아이_제공데이터_개인타자_2020.csv')
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
batter %>% view

#------------------batter_tidy 생성-----------------------------------#

batter_tidy = batter %>% group_by(year, month, T_ID, P_ID) %>% 
  mutate(max_bat = max(BAT_ORDER_NO_1, BAT_ORDER_NO_2, BAT_ORDER_NO_3, BAT_ORDER_NO_4, BAT_ORDER_NO_5, BAT_ORDER_NO_6, BAT_ORDER_NO_7, BAT_ORDER_NO_8, BAT_ORDER_NO_9)) %>% 
  ungroup() %>%
  mutate(BAT_ORDER = case_when(
    max_bat == BAT_ORDER_NO_1 ~ 1,
    max_bat == BAT_ORDER_NO_2 ~ 2,
    max_bat == BAT_ORDER_NO_3 ~ 3,
    max_bat == BAT_ORDER_NO_4 ~ 4,
    max_bat == BAT_ORDER_NO_5 ~ 5,
    max_bat == BAT_ORDER_NO_6 ~ 6,
    max_bat == BAT_ORDER_NO_7 ~ 7,
    max_bat == BAT_ORDER_NO_8 ~ 8,
    max_bat == BAT_ORDER_NO_9 ~ 9
  ), HOME = TB_SC_B, AWAY = TB_SC_T) %>% select(-c(BAT_ORDER_NO_1, BAT_ORDER_NO_2, BAT_ORDER_NO_3, BAT_ORDER_NO_4, BAT_ORDER_NO_5, BAT_ORDER_NO_6, BAT_ORDER_NO_7, BAT_ORDER_NO_8, BAT_ORDER_NO_9, TB_SC_B, TB_SC_T, max_bat)) 

###----------볼넷 당 삼진 비율(KBB,타자기준)---------###
##
### 일단 여기서 batter_tidy를 그냥 불러와서 진행했습니다.
### 앞에 코드가 이어지면 불러온 거만 삭제하면 될 것 같습니다!
###
##
batter_tidy = read.csv('C:/Users/seungjun/Desktop/baseball/data/batter_tidy.csv')


B_KBB = batter_tidy %>%
  group_by(P_ID) %>%
  summarise(Total_KK = sum(KK), Total_BB = sum(BB)) %>%   
  mutate(KBB = Total_KK/Total_BB)


sum(is.na(B_KBB$KBB))           
sum(is.infinite(B_KBB$KBB))    

B_KBB$KBB[is.na(B_KBB$KBB)] =  0
B_KBB$KBB[is.infinite(B_KBB$KBB)] =  0

sum(is.na(B_KBB$KBB))
sum(is.infinite(B_KBB$KBB))


#------------도루 성공율 ----------------------------# 

SB_RATE = batter_tidy %>%
  group_by(P_ID) %>%
  summarise(Total_SB = sum(SB), Total_CS = sum(CS)) %>%          
  mutate(SB_rate = Total_SB/(Total_SB+Total_CS))


sum(is.na(SB_RATE$SB_rate))         
sum(is.infinite(SB_RATE$SB_rate))   

SB_RATE$SB_rate[is.na(SB_RATE$SB_rate)] = 0

sum(is.infinite(SB_RATE$SB_rate))

B_df1 = cbind(select(B_KBB,P_ID), select(B_KBB,KBB), select(SB_RATE,SB_rate) )  # KBB,SB_rate tidy에 추가
batter_tidy2 = left_join(batter_tidy,B_df1,by= 'P_ID' )

#------------BABIP------------------------------#
BABIP = batter_tidy2 %>%                     
  group_by(P_ID) %>%                #  타자 P_ID 별로 통합된 변수들 생성
  summarise(Total_HIT = sum(HIT),Total_HR = sum(HR),Total_AB = sum(AB),Total_KK = sum(KK),Total_SF = sum(SF)) %>%
  mutate(BABIP = (Total_HIT - Total_HR) / (Total_AB - Total_KK - Total_HR + Total_SF))   # BABIP 계산

sum(is.na(BABIP$BABIP))             
sum(is.infinite((BABIP$BABIP)))

BABIP$BABIP[is.na(BABIP$BABIP)] = 0

sum(is.na(BABIP$BABIP))

batter_tidy3 = left_join(batter_tidy2,select(BABIP,P_ID,BABIP), by='P_ID')

#------------각종_rate----------------------#
df = batter_tidy %>%
  mutate(H2_rate=H2/HIT,H3_rate=H3/HIT,HR_rate=HR/HIT,BB_rate=BB/PA,
         KK_rate=KK/PA, HP_rate=HP/PA, GD_rate=GD/PA)


rate = select(df,c(H2_rate,H3_rate,HR_rate,BB_rate,KK_rate,HP_rate,GD_rate))


rate$H2_rate[is.na(rate$H2_rate)] = 0
rate$H3_rate[is.na(rate$H3_rate)] = 0
rate$HR_rate[is.na(rate$HR_rate)] = 0
rate$BB_rate[is.na(rate$BB_rate)] = 0
rate$HP_rate[is.na(rate$HP_rate)] = 0
rate$KK_rate[is.na(rate$KK_rate)] = 0
rate$GD_rate[is.na(rate$GD_rate)] = 0

sum(is.na(rate$H2_rate))
sum(is.na(rate$H3_rate))
sum(is.na(rate$HR_rate))
sum(is.na(rate$BB_rate))
sum(is.na(rate$HP_rate))
sum(is.na(rate$KK_rate))
sum(is.na(rate$GD_rate))

rate$H2_rate[is.infinite(rate$H2_rate)] = 0
rate$H3_rate[is.infinite(rate$H3_rate)] = 0
rate$HR_rate[is.infinite(rate$HR_rate)] = 0
rate$BB_rate[is.infinite(rate$BB_rate)] = 0
rate$HP_rate[is.infinite(rate$HP_rate)] = 0
rate$KK_rate[is.infinite(rate$KK_rate)] = 0
rate$GD_rate[is.infinite(rate$GD_rate)] = 0

sum(is.infinite(rate$H2_rate))
sum(is.infinite(rate$H3_rate))
sum(is.infinite(rate$HR_rate))
sum(is.infinite(rate$BB_rate))
sum(is.infinite(rate$HP_rate))
sum(is.infinite(rate$KK_rate))
sum(is.infinite(rate$GD_rate))


batter_tidy4 = cbind(batter_tidy3,rate)

#--------------------XR---------------------#
XR = batter_tidy %>%
  mutate(singles = HIT - H2 - H3 - HR) %>%
  mutate(XR = 0.5*singles + 0.72*H2 + 1.04*H3 + 1.44*HR + 0.34*(HP - IB + BB) 
         + 0.25*IB + 0.18*SB - 0.32*CS - 0.09*(AB - HIT - KK)
         - 0.098*KK - 0.37*GD + 0.27*SF + 0.04*SH) %>%
  select(XR)

batter_tidy5 = cbind(batter_tidy4,XR)

#--------타율_출루율_장타율_OPS-------------------------#
AVG = batter_tidy %>%
  mutate(AVG = HIT / AB, 
         OBP = (HIT + BB + HP)/(AB + BB + HP + SF),
         SLG = ((HIT - H2 - H3 - HR)*1 + H2*2 + H3*3 + HR*4 ) / AB ,
         OPS = OBP + SLG) %>%
  select(AVG,OBP,SLG,OPS)

sum(is.na(AVG))

sum(is.infinite(AVG$AVG))
sum(is.infinite(AVG$OBP))
sum(is.infinite(AVG$SLG))
sum(is.infinite(AVG$OPS))

AVG$AVG[is.na(AVG$AVG)] = 0
AVG$OBP[is.na(AVG$OBP)] = 0
AVG$SLG[is.na(AVG$SLG)] = 0
AVG$OPS[is.na(AVG$OPS)] = 0

batter_tidy6 = cbind(batter_tidy5,AVG)

#---------------------------------#
library(corrplot) 
batter1 = batter_tidy6 %>% select(-c(T_ID,year,month,P_ID,BAT_ORDER,KK_rate,KBB,
                               SB,CS,BB,KK,AB,HIT,H2,H3,RBI,RUN,HR,SH,SF,IB,HP,GD,ERR,ERR,LOB,P_AB_CN,P_HIT_CN,
                               VS_T_ID_HH,VS_T_ID_HT,VS_T_ID_KT,VS_T_ID_LG,VS_T_ID_LG,VS_T_ID_LT,VS_T_ID_NC,
                               VS_T_ID_OB,VS_T_ID_SK,VS_T_ID_SS,VS_T_ID_WO,HOME,AWAY))


names(batter1)
batter_cor = cor(batter1)           
corrplot(batter_cor ,method="shade",addshade="all",tl.col="red",tl.srt=30, diag=FALSE)

batter_selection = batter_tidy6 %>% select(-c(KK_rate,KBB,SB,CS,BB,KK,AB,HIT,H2,H3
                              ,RBI,RUN,HR,SH,SF,IB,HP,GD,ERR,ERR,LOB,HOME,AWAY))

names(batter_selection)  #  선택된 변수들 -> batter_selection에 저장했습니다.
write.csv(batter_selection,'C:/Users/seungjun/Desktop/baseball/data/batter_feature_selection.csv')


#--------------------------------------------------------------------------#
### ridge, rasso 해보긴 했는데 이를 어떻게 해석해야할지 잘 모르겠습니다  ###
require(glmnet)

# 범주형만 뺴고 나머지 전부 넣음
cand = batter_tidy %>%  
  select(-c(T_ID,year,month,P_ID,BAT_ORDER,P_AB_CN,P_HIT_CN,
              VS_T_ID_HH,VS_T_ID_HT,VS_T_ID_KT,VS_T_ID_LG,VS_T_ID_LG,VS_T_ID_LT,VS_T_ID_NC,
              VS_T_ID_OB,VS_T_ID_SK,VS_T_ID_SS,VS_T_ID_WO,HOME,AWAY))



x=model.matrix(XR~.,cand)[,-1]
y=batter1$XR

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













