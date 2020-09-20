# batter feature selection #

#install.packages("corrplot")
#install.packages('glmnet')

library(tidyverse)
library(corrplot) 
library(glmnet)


batter = read.csv('C:/Users/seungjun/Desktop/baseball/data/batter_all.csv',header=T)
batter = batter  %>%
  mutate(H2_rate=H2/HIT,H3_rate=H3/HIT,HR_rate=HR/HIT,
         BB_rate=BB/PA, HP_rate=HP/PA, KK_rate=KK/PA, GD_rate=GD/PA)
names(batter)

batter$H2_rate[is.na(batter$H2_rate)] = 0
batter$H3_rate[is.na(batter$H3_rate)] = 0
batter$HR_rate[is.na(batter$HR_rate)] = 0
batter$BB_rate[is.na(batter$BB_rate)] = 0
batter$HP_rate[is.na(batter$HP_rate)] = 0
batter$KK_rate[is.na(batter$KK_rate)] = 0
batter$GD_rate[is.na(batter$GD_rate)] = 0

sum(is.na(batter$H2_rate))
sum(is.na(batter$H3_rate))
sum(is.na(batter$HR_rate))
sum(is.na(batter$BB_rate))
sum(is.na(batter$HP_rate))
sum(is.na(batter$KK_rate))
sum(is.na(batter$GD_rate))

batter$H2_rate[is.infinite(batter$H2_rate)] = 0
batter$H3_rate[is.infinite(batter$H3_rate)] = 0
batter$HR_rate[is.infinite(batter$HR_rate)] = 0
batter$BB_rate[is.infinite(batter$BB_rate)] = 0
batter$HP_rate[is.infinite(batter$HP_rate)] = 0
batter$KK_rate[is.infinite(batter$KK_rate)] = 0
batter$GD_rate[is.infinite(batter$GD_rate)] = 0

sum(is.infinite(batter$H2_rate))
sum(is.infinite(batter$H3_rate))
sum(is.infinite(batter$HR_rate))
sum(is.infinite(batter$BB_rate))
sum(is.infinite(batter$HP_rate))
sum(is.infinite(batter$KK_rate))
sum(is.infinite(batter$GD_rate))





batter1 = batter %>% select(-c(X,T_ID,year,month,P_ID,BAT_ORDER,KK_rate,KBB,
                              SB,CS,BB,KK,AB,HIT,H2,H3,RBI,RUN,HR,SH,SF,IB,HP,GD,ERR,ERR,LOB,P_AB_CN,P_HIT_CN,
                              VS_T_ID_HH,VS_T_ID_HT,VS_T_ID_KT,VS_T_ID_LG,VS_T_ID_LG,VS_T_ID_LT,VS_T_ID_NC,
                              VS_T_ID_OB,VS_T_ID_SK,VS_T_ID_SS,VS_T_ID_WO,HOME,AWAY))


names(batter1)
batter_cor = cor(batter1)           
corrplot(batter_cor ,method="shade",addshade="all",tl.col="red",tl.srt=30, diag=FALSE)

batter = batter %>% select(-c(X,KK_rate,KBB,SB,CS,BB,KK,AB,HIT,H2,H3
                                ,RBI,RUN,HR,SH,SF,IB,HP,GD,ERR,ERR,LOB,HOME,AWAY))
names(batter)


write.csv(batter, 'batter_feature_selection.csv')
