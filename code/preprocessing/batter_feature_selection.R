# batter feature selection #

#install.packages("corrplot")
#install.packages('glmnet')

library(tidyverse)
library(corrplot) 
library(glmnet)


batter = read.csv('/Users/kimchaehyeong/Documents/BIGCONTEST/Baseball_ChilliShrimp/data/batter_all.csv',header=T)
batter = batter  %>%
  mutate(H2_rate=H2/HIT,H3_rate=H3/HIT)
names(batter)

batter$H2_rate[is.na(batter$H2_rate)] = 0
batter$H3_rate[is.na(batter$H3_rate)] = 0


batter = batter %>% select(-c(X,T_ID,year,month,P_ID,BAT_ORDER,KK_rate,KBB,
                              SB,CS,BB,KK,AB,HIT,H2,H3,RBI,RUN,HR,SH,SF,IB,HP,GD,ERR,ERR,LOB,P_AB_CN,P_HIT_CN,
                              VS_T_ID_HH,VS_T_ID_HT,VS_T_ID_KT,VS_T_ID_LG,VS_T_ID_LG,VS_T_ID_LT,VS_T_ID_NC,
                              VS_T_ID_OB,VS_T_ID_SK,VS_T_ID_SS,VS_T_ID_WO,HOME,AWAY))


names(batter)
batter_cor = cor(batter)           
corrplot(batter_cor ,method="shade",addshade="all",tl.col="red",tl.srt=30, diag=FALSE)

write.csv(batter, 'batter_feature_selection.csv')