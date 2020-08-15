Batter_tidy = read.csv('C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/batter_tidy.csv',header=T)
head(Batter_tidy)
str(Batter_tidy)

batter_tidy = Batter_tidy %>%
  group_by(P_ID) %>%
summarise(total_KK = sum(KK), total_BB =sum(BB), total_HR =sum(HR), total_AB = sum(AB) )

rate = batter_tidy %>%
  mutate(KK_rate = total_KK/total_AB, BB_rate = total_BB/total_AB, HR_rate = total_HR/total_AB)

head(rate)

sum(is.na(rate))
sum(is.infinite(rate$total_KK))
sum(is.infinite(rate$total_BB))
sum(is.infinite(rate$total_HR))
sum(is.infinite(rate$total_AB))

rate[is.na(rate)] = 0
sum(is.na(rate))


write.csv(rate,'C:/Users/seungjun/Desktop/baseball/Baseball_ChilliShrimp/data/batter_KK_BB_HR_rate.csv' )

