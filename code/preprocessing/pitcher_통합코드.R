library(tidyverse)
pitcher <- read.csv('https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/pitcher_tidy.csv')

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
## ???? ???? ERA
Total_ERA = pitcher1 %>%
  select(year,ER,PA,HIT,BB,HP) %>% 
  group_by(year) %>%
  summarise(ER = sum(ER), PA= sum(PA), HIT= sum(HIT),BB= sum(BB), HP= sum(HP)) %>%
  mutate(Total_ERA = ER*9/(  (PA-HIT-BB-HP)/3) ) %>%
  select(year,Total_ERA)


## ?????? ERA
ERA = pitcher1 %>%
  select(P_ID,year,ER,PA,HIT,BB,HP) %>% 
  mutate(ERA = ER*9/(  (PA-HIT-BB-HP)/3) ) %>%
  select(ERA)

ERA$ERA[is.na(ERA$ERA)] = 0
ERA$ERA[is.infinite(ERA$ERA)] = 99.99

sum(is.na(ERA$ERA))
sum(is.infinite(ERA$ERA))


##?????? FIP.  IB ???? x

Total_FIP = pitcher1 %>%
  group_by(year) %>%
  summarise(HR= sum(HR),KK=sum(KK) ,PA= sum(PA), HIT= sum(HIT),BB= sum(BB), HP= sum(HP)) %>%
  mutate(Total_FIP = (13*HR + 3*(BB+HP) - 2*KK) /  ((PA-HIT-BB-HP)/3)) %>%
  select(year,Total_FIP)


FIP = pitcher %>%
  mutate(FIP = (13*HR + 3*(BB+HP) - 2*KK) /  ((PA-HIT-BB-HP)/3)) 


FIP$FIP[is.na(FIP$FIP)] = 0
FIP$FIP[is.infinite(FIP$FIP)] = 0

sum(is.na(FIP$FIP))
sum(is.infinite(FIP$FIP))


R_FIP = FIP %>%
  left_join(Total_ERA,by='year') %>%
  left_join(Total_FIP,by='year') %>%
  mutate(FIP = FIP + (Total_ERA-Total_FIP)) %>% 
  select(FIP)



sum(is.na(R_FIP$FIP))
sum(is.infinite(R_FIP$FIP))


kwERA = pitcher1 %>%
  mutate(kwERA = (5.40 -12*(KK-BB)/PA) ) %>%
  select(kwERA)


kwERA$kwERA[is.na(kwERA$kwERA)] = 0
kwERA$kwERA[is.infinite(kwERA$kwERA)] = 99.99

sum(is.na(kwERA$kwERA))
sum(is.infinite(kwERA$kwERA))

pitcher2 <- cbind(pitcher1,ERA,FIP = R_FIP,kwERA)
#---------------?????õ?�� ???? ????�� GD rate------------------------#
data_sb = read.csv('https://raw.githubusercontent.com/njj06135/Baseball_ChilliShrimp/master/data/pitcher_to_get_total.csv')

SB_try = data_sb %>%
  group_by(P_ID) %>%
  summarise(SB = sum(SB), CS = sum(CS), PA = sum(PA),GD =sum(GD)) %>%          
  mutate(SB_try = (SB + CS) / PA, SB_succ = SB/(SB + CS),GD_rate=GD/PA ) %>%
  select(c(P_ID,SB_try,SB_succ,GD_rate))

sum(is.na(SB_try$SB_try))
sum(is.na(SB_try$SB_succ))
sum(is.na(SB_try$GD_rate))

sum(is.infinite(SB_try$SB_try))
sum(is.infinite(SB_try$SB_succ))
sum(is.infinite(SB_try$GD_rate))

SB_try$SB_try[is.na(SB_try$SB_try)] = 0
SB_try$SB_try[is.infinite(SB_try$SB_try)] = 0

SB_try$SB_succ[is.na(SB_try$SB_succ)] = 0
SB_try$SB_succ[is.infinite(SB_try$SB_succ)] = 0

sum(is.na(SB_try$SB_try))
sum(is.infinite(SB_try$SB_try))
sum(is.na(SB_try$SB_succ))
sum(is.infinite(SB_try$SB_succ))

pitcher3 <- left_join(pitcher2,SB_try,by='P_ID')



#-------------------------------------------------#
rate = pitcher3  %>%
  mutate(H2_rate=H2/HIT,H3_rate=H3/HIT,HR_rate=HR/HIT,BB_rate=BB/PA,
         HP_rate=HP/PA, KK_rate=KK/PA, 
         BK_rate= BK/(HIT + BB + HP))
names(rate)

rate$H2_rate[is.na(rate$H2_rate)] = 0
rate$H3_rate[is.na(rate$H3_rate)] = 0
rate$HR_rate[is.na(rate$HR_rate)] = 0
rate$BB_rate[is.na(rate$BB_rate)] = 0
rate$HP_rate[is.na(rate$HP_rate)] = 0
rate$KK_rate[is.na(rate$KK_rate)] = 0
rate$BK_rate[is.na(rate$BK_rate)] = 0

sum(is.na(rate$H2_rate))
sum(is.na(rate$H3_rate))
sum(is.na(rate$HR_rate))
sum(is.na(rate$BB_rate))
sum(is.na(rate$HP_rate))
sum(is.na(rate$KK_rate))
sum(is.na(rate$BK_rate))


rate$H2_rate[is.infinite(rate$H2_rate)] = 0
rate$H3_rate[is.infinite(rate$H3_rate)] = 0
rate$HR_rate[is.infinite(rate$HR_rate)] = 0
rate$BB_rate[is.infinite(rate$BB_rate)] = 0
rate$HP_rate[is.infinite(rate$HP_rate)] = 0
rate$KK_rate[is.infinite(rate$KK_rate)] = 0
rate$BK_rate[is.infinite(rate$BK_rate)] = 0

sum(is.infinite(rate$H2_rate))
sum(is.infinite(rate$H3_rate))
sum(is.infinite(rate$HR_rate))
sum(is.infinite(rate$BB_rate))
sum(is.infinite(rate$HP_rate))
sum(is.infinite(rate$KK_rate))
sum(is.infinite(rate$BK_rate))

pitcher4 <- rate
#----------???? ?? ???? ??��(KBB,????????)---------#

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

AVG = pitcher5 %>%
  mutate(AVG = HIT / AB, 
         OBP = (HIT + BB + HP)/(AB + BB + HP + SF),
         SLG = ((HIT - H2 - H3 - HR)*1 + H2*2 + H3*3 + HR*4 ) / AB ,
         OPS = OBP + SLG)

sum(is.na(AVG$AVG))
sum(is.na(AVG$OBP))
sum(is.na(AVG$SLG))
sum(is.na(AVG$OPS))


AVG$AVG[is.na(AVG$AVG)] = 0
AVG$OBP[is.na(AVG$OBP)] = 0
AVG$SLG[is.na(AVG$SLG)] = 0
AVG$OPS[is.na(AVG$OPS)] = 0

sum(is.infinite(AVG$AVG))
sum(is.infinite(AVG$OBP))
sum(is.infinite(AVG$SLG))
sum(is.infinite(AVG$OPS))

AVG

#-------------------------------------------------#
pitcher6 = AVG %>%
  group_by(year,T_ID) %>%
  mutate(ER_rate = ER/R)

sum(is.na(pitcher6$ER_rate))
sum(is.infinite(pitcher6$ER_rate))

pitcher6$ER_rate[is.na(pitcher6$ER_rate)] = 0

sum(is.na(pitcher6$ER_rate))

ERR_rate = data_sb %>%
  group_by(year,T_ID) %>%
  summarise(PA = sum(PA), ERR = sum(ERR)) %>%
  mutate(ERR_rate = ERR/PA) %>%
  select(-PA)

  
data <- left_join(pitcher6,ERR_rate, by=c('year','T_ID'))
#-------------------------------------------------#
library(corrplot) 

names(data)

data_set = data %>% select(-c(year,month,T_ID,VS_T_ID_HH,VS_T_ID_HT,VS_T_ID_KT,VS_T_ID_LG,VS_T_ID_LT,
                              VS_T_ID_NC,VS_T_ID_OB,VS_T_ID_SK,VS_T_ID_SS,VS_T_ID_WO,P_ID,SB_try,SB_succ,GD_rate,
                                  AB,HIT,H2,H3,HR,SF,BB,HP,KK,ERR,ER,KBB,BK,stadium_MH,stadium_MS,stadium_JS,stadium_SW,
                                  stadium_DJ,stadium_DG,stadium_GJ,stadium_GC,stadium_SJ,stadium_PH,stadium_US,stadium_CJ,stadium_CW))


data_set = data_set %>% ungroup() %>% select(-c(T_ID))

pitcher_cor = cor(data_set)           
corrplot(pitcher_cor ,method="shade",addshade="all",tl.col="red",tl.srt=30, diag=FALSE )

pitcher_selection = data %>% select(-c(KBB,ER, ERR, 
                                BB,KK,AB,HIT,H2,H3,HR,SF,HP,BK, ERA))

names(pitcher_selection)  # ???õ? ?????? pitcher_selection?̶??? ?̸??? ?????߽��ϴ?.
write.csv(pitcher_selection,'C:\\Users\\dhxog\\Desktop\\ESC_summer\\데이터분석분야_퓨처스리그_칠리새우\\데이터\\2. preprocessing\\pitcher_feature_selection.csv', row.names = F)


write.csv(data,'C:\\Users\\dhxog\\Desktop\\ESC_summer\\데이터분석분야_퓨처스리그_칠리새우\\데이터\\2. preprocessing\\pitcher_all.csv', row.names = F)






