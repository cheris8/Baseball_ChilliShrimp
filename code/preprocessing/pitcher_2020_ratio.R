library(tidyverse)

data <- read.csv('C:\\Users\\dhxog\\Desktop\\ESC_summer\\데이터분석분야_퓨처스리그_칠리새우\\데이터\\2. preprocessing\\pitcher_tidy.csv')


df1 <- data %>%
  filter(year==2020) %>%
  group_by(P_ID) %>%
  summarise(PA = sum(PA),HIT = sum(HIT), H2 = sum(H2), H3 = sum(H3), HR = sum(HR), BB = sum(BB), HP= sum(HP),
            KK= sum(KK), BK=sum(BK)) %>%
  mutate(H2_rate= H2/HIT, H3_rate = H3/HIT, HR_rate = HR/HIT, BB_rate = BB/PA, HP_rate=HP/PA,
         KK_rate = KK/PA, BK_rate = BK/PA) %>%
  select(P_ID,H2_rate,H3_rate,HR_rate,BB_rate,HP_rate,KK_rate,BK_rate)

write.csv(df1,'C:\\Users\\dhxog\\Desktop\\ESC_summer\\데이터분석분야_퓨처스리그_칠리새우\\데이터\\4. prediction\\pitcher_2020_ratio.csv')  
