# 상관계수 플롯
install.packages("corrplot")
install.packages('glmnet')

library(tidyverse)
library(corrplot) 
library(glmnet)


batter = read.csv('C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/batter_all.csv',header=T)
batter = batter  %>%
  mutate(H2_rate=H2/HIT,H3_rate=H3/HIT)
names(batter)

batter$H2_rate[is.na(batter$H2_rate)] = 0
batter$H3_rate[is.na(batter$H3_rate)] = 0

dummy = batter %>%
  select(c(T_ID,year,month,P_ID,BAT_ORDER,VS_T_ID_HH,VS_T_ID_HT,
           VS_T_ID_KT,VS_T_ID_LG,VS_T_ID_LG,VS_T_ID_LT,VS_T_ID_NC,
           VS_T_ID_OB,VS_T_ID_SK,VS_T_ID_SS,VS_T_ID_WO))

numeric = batter %>% select(-c(X,T_ID,year,month,P_ID,BAT_ORDER,KK_rate,KBB,
                              SB,CS,BB,KK,AB,HIT,H2,H3,RBI,RUN,HR,SH,SF,IB,HP,GD,ERR,ERR,LOB,P_AB_CN,P_HIT_CN,
                              VS_T_ID_HH,VS_T_ID_HT,VS_T_ID_KT,VS_T_ID_LG,VS_T_ID_LG,VS_T_ID_LT,VS_T_ID_NC,
                              VS_T_ID_OB,VS_T_ID_SK,VS_T_ID_SS,VS_T_ID_WO,HOME,AWAY))



names(numeric)
batter_cor = cor(numeric)           
corrplot(batter_cor ,method="shade",addshade="all",tl.col="red",tl.srt=30, diag=FALSE ) 

batter_selection = cbind(numeric,dummy)
names(batter_selection)  



write.csv(batter_selection,'C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/batter_feature_selection.csv')
