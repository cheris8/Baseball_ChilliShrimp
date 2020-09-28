
###----------???? ?? ???? ??À²(KBB,Å¸?Ú±???)---------###
##
### ?Ï´? ???â¼­ batter_tidy?? ?×³? ?Ò·??Í¼? ?????ß½À´Ï´?.
### ?Õ¿? ?Úµå°¡ ?Ì¾????? ?Ò·??? ?Å¸? ??Á¦?Ï¸? ?? ?? ???À´Ï´?!
###
##
batter_tidy = read.csv('C:/Users/seungjuhttps://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/mastery.csv')


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

batter_tidy = left_join(batter_tidy,select(B_KBB,c('P_ID','KBB')),by='P_ID')

#------------???? ?Ãµ?À², ???? ????À² ----------------------------# 
SB_try = batter_tidy %>%
  group_by(P_ID) %>%
  summarise(SB = sum(SB), CS = sum(CS), PA = sum(PA)) %>%          
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



select(SB_try,c(SB_try,SB) )  # KBB,SB_rate tidy?? ?ß°?
batter_tidy2 = left_join(batter_tidy,select(SB_try,c(P_ID,SB_try,SB_succ)),by= 'P_ID' )

#------------BABIP------------------------------#
BABIP = batter_tidy2 %>%                     
  group_by(P_ID) %>%                #  Å¸?? P_ID ???? ???Õµ? ?????? ????
  summarise(Total_HIT = sum(HIT),Total_HR = sum(HR),Total_AB = sum(AB),Total_KK = sum(KK),Total_SF = sum(SF)) %>%
  mutate(BABIP = (Total_HIT - Total_HR) / (Total_AB - Total_KK - Total_HR + Total_SF))   # BABIP ????

sum(is.na(BABIP$BABIP))             
sum(is.infinite((BABIP$BABIP)))

BABIP$BABIP[is.na(BABIP$BABIP)] = 0

sum(is.na(BABIP$BABIP))

batter_tidy3 = left_join(batter_tidy2,select(BABIP,P_ID,BABIP), by='P_ID')

#------------??Á¾_rate----------------------#
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
  mutate(XR = 0.5*singles + 0.72*H2 + 1.04*H3 + 1.44*HR + 0.34*(HP + BB) 
         + 0.18*SB - 0.32*CS - 0.09*(AB - HIT - KK)
         - 0.098*KK - 0.37*GD + 0.27*SF ) %>%
  select(XR)

sum(is.na(XR$XR))
sum(is.infinite(XR$XR))

XR$XR[is.na(XR$XR)] = 0


batter_tidy5 = cbind(batter_tidy4,XR)

#--------Å¸À²_????À²_??Å¸À²_OPS-------------------------#
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



names(batter1)


batter_tidy6[is.na(batter_tidy6$PA),]

batter_tidy6[is.na(batter_tidy6$PA),'PA'] = c(19,0,0,3)
batter_tidy6[is.na(batter_tidy6$SB),'SB'] = c(0,0,0,0)
batter_tidy6[is.na(batter_tidy6$CS),'CS'] = c(0,0,0,0)
batter_tidy6[is.na(batter_tidy6$SF),'SF'] = c(0,0,0,0)
summary(batter_tidy6)

batter1 = batter_tidy6 %>% select(-c(T_ID,year,month,P_ID,BAT_ORDER,KK_rate,KBB,
                                     SB,CS,BB,KK,AB,HIT,H2,H3,HR,SF,HP,GD,
                                     VS_T_ID_HH,VS_T_ID_HT,VS_T_ID_KT,VS_T_ID_LG,VS_T_ID_LG,VS_T_ID_LT,VS_T_ID_NC,
                                     VS_T_ID_OB,VS_T_ID_SK,VS_T_ID_SS,VS_T_ID_WO,HOME,AWAY))

batter_cor = cor(batter1)           
corrplot(batter_cor ,method="shade",addshade="all",tl.col="red",tl.srt=30, diag=FALSE)

batter_selection = batter_tidy6 %>% select(-c(KK_rate,KBB,SB,CS,BB,KK,AB,HIT,H2,H3
                                              ,HR,SF,HP,GD))

names(batter_selection)  #  ???Ãµ? ?????? -> batter_selection?? ?????ß½À´Ï´?.

write.csv(batter_selection,'C:/Users/seungjun/Desktop/baseball/data/batter_feature_selection.csv')
write.csv(batter_tidy6,'batter_all.csv')






