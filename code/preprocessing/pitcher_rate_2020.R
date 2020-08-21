library(tidyverse)
pitcher_rate = read.csv('C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/pitcher.csv',header=T)
pitcher_rate
names(pitcher_rate)

data = pitcher_rate %>%
  filter(year==2020) %>%
  group_by(P_ID) %>%
  summarise(BF=sum(BF),PA=sum(PA),AB=sum(AB), HIT=sum(HIT),H2=sum(H2),H3=sum(H3),HR=sum(HR),SB=sum(SB),CS=sum(CS),
            BB=sum(BB),HP=sum(HP),KK=sum(KK),GD=sum(GD),BK=sum(BK))

data =data %>%
  mutate(BF_per_PA=BF/PA, H2_rate=H2/HIT, H3_rate=H3/HIT, HR_rate=HR/HIT,SB_rate=(SB+CS)/PA, 
         BB_rate=BB/PA, HP_rate=HP/PA, KK_rate=KK/PA, GD_rate=GD/PA, BK_rate= BK/(HIT + BB + HP) )

names(data)

data$BF_per_PA[is.na(data$BF_per_PA)] = 0
data$H2_rate[is.na(data$H2_rate)] = 0
data$H3_rate[is.na(data$H3_rate)] = 0
data$HR_rate[is.na(data$HR_rate)] = 0
data$SB_rate[is.na(data$SB_rate)] = 0
data$BB_rate[is.na(data$BB_rate)] = 0
data$HP_rate[is.na(data$HP_rate)] = 0
data$KK_rate[is.na(data$KK_rate)] = 0
data$GD_rate[is.na(data$GD_rate)] = 0
data$BK_rate[is.na(data$BK_rate)] = 0

data$BF_per_PA[is.infinite(data$BF_per_PA)] = 0
data$H2_rate[is.infinite(data$H2_rate)] = 0
data$H3_rate[is.infinite(data$H3_rate)] = 0
data$HR_rate[is.infinite(data$HR_rate)] = 0
data$SB_rate[is.infinite(data$SB_rate)] = 0
data$BB_rate[is.infinite(data$BB_rate)] = 0
data$HP_rate[is.infinite(data$HP_rate)] = 0
data$KK_rate[is.infinite(data$KK_rate)] = 0
data$GD_rate[is.infinite(data$GD_rate)] = 0
data$BK_rate[is.infinite(data$BK_rate)] = 0





data = data %>%
  select(c(P_ID,BF_per_PA,H2_rate,H3_rate,HR_rate,SB_rate,BB_rate,HP_rate,KK_rate,GD_rate,BK_rate))

names(data)
write.csv(data,'C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/pitcher_rate_BABIP_2020.csv')
