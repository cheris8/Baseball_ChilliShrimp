library(tidyverse)

raw <- read.csv('C:/Users/seungjun/Desktop/baseball/data/raw_pitcher.csv')
modeling <- read.csv('C:/Users/seungjun/Desktop/baseball/data/modeling_pitcher_stadium.csv')

names(raw)
names(modeling)


df1 <- raw %>%
  filter(year==2020) %>%
  group_by(P_ID) %>%
  summarise(PA = sum(PA), H2 = sum(H2), H3 = sum(H3), HR = sum(HR), BB = sum(BB), HP= sum(HP),
            KK= sum(KK), BK=sum(BK)) %>%
  mutate(H2_rate= H2/PA, H3_rate = H3/PA, HR_rate = HR/PA, BB_rate = BB/PA, HP_rate=HP/PA,
         KK_rate = KK/PA, BK_rate = BK/PA) %>%
  select(P_ID,H2_rate,H3_rate,HR_rate,BB_rate,HP_rate,KK_rate,BK_rate)

write.csv(df1,'C:/Users/seungjun/Desktop/baseball/data/pitcher_2020_ratio.csv')  
