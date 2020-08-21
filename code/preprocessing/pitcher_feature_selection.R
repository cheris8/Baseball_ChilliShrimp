# pitcher feature selection #

library(tidyverse)
library(corrplot) 
library(glmnet)

pitcher = read.csv('/Users/kimchaehyeong/Documents/BIGCONTEST/Baseball_ChilliShrimp/data/pitcher_all.csv',header=T)
head(pitcher)

pitcher = pitcher  %>%
  mutate(H2_rate=H2/HIT,H3_rate=H3/HIT,HR_rate=HR/HIT)
names(pitcher)

pitcher$H2_rate[is.na(pitcher$H2_rate)] = 0
pitcher$H3_rate[is.na(pitcher$H3_rate)] = 0
pitcher$HR_rate[is.na(pitcher$HR_rate)] = 0

sum(is.na(pitcher$H2_rate))
sum(is.na(pitcher$H3_rate))
sum(is.na(pitcher$HR_rate))

pitcher$H2_rate[is.infinite(pitcher$H2_rate)] = 0
pitcher$H3_rate[is.infinite(pitcher$H3_rate)] = 0
pitcher$HR_rate[is.infinite(pitcher$HR_rate)] = 0

sum(is.infinite(pitcher$H2_rate))
sum(is.infinite(pitcher$H3_rate))
sum(is.infinite(pitcher$HR_rate))


names(pitcher)
pitcher = pitcher %>% select(-c(X,T_ID,year,month,P_ID,KBB,TB_SC_B,TB_SC_T,WLS_D,WLS_L,WLS_ND,WLS_S,WLS_W,ER,HOLD,INN2,WP,
                                SB,CS,BB,KK,AB,HIT,H2,H3,HR,SH,SF,IB,HP,GD,ERR,ERR,START_CK,RELIEF_CK,CG_CK,
                                VS_T_ID_HH,VS_T_ID_HT,VS_T_ID_KT,VS_T_ID_LG,VS_T_ID_LG,VS_T_ID_LT,VS_T_ID_NC,
                                VS_T_ID_OB,VS_T_ID_SK,VS_T_ID_SS,VS_T_ID_WO))


names(pitcher)
pitcher_cor = cor(pitcher)           
corrplot(pitcher_cor ,method="shade",addshade="all",tl.col="red",tl.srt=30, diag=FALSE )

write.csv(pitcher, 'pitcher_feature_selection.csv')