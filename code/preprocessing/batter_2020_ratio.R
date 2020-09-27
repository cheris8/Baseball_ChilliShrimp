library(tidyverse)

data <- read.csv('C:/Users/seungjun/Desktop/baseball/data/batter_789ХыЧе.csv')
names(data)

df1 <- data %>%
  filter(year==2020) %>%
  group_by(P_ID) %>%
  summarise(PA = sum(PA), H2 = sum(H2), H3 = sum(H3), HR = sum(HR), BB = sum(BB), HP= sum(HP),
            KK= sum(KK)) %>%
  mutate(H2_rate= H2/PA, H3_rate = H3/PA, HR_rate = HR/PA, BB_rate = BB/PA, HP_rate=HP/PA,
         KK_rate = KK/PA) %>%
  select(P_ID,H2_rate,H3_rate,HR_rate,BB_rate,HP_rate,KK_rate)



write.csv(df1,'C:/Users/seungjun/Desktop/baseball/data/batter_2020_ratio.csv')  
